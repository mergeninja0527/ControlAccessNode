const { Db } = require('../utils/Db.js');
const { parseObjToMap, parseStringToMap, getRandomString, getServiceParamete, parseDevState, parseJumpingString, parseObjToMap2 } = require('../utils/Functions.js');
const { allEventMap, USER, BIOPHOTO } = require("../utils/Constantes.js");
const { Cmd } = require('../utils/Cmd.js');
const stringify = require('json-stringify-safe');
const { findOne, findMany, pool } = require('../database/database.js');
const moment = require("moment-timezone");

// const { Db2 } = require('../utils/DatabaseUtils.js');

//Recevie all of the requestes from Devices

const cdata = async (req, res) => {
  let retValue = 'OK';
  try {
    let type = req.query.table ?? req.body.table ?? undefined;
    const sn = req.query.SN || undefined;
    const authType = req.query.AuthType || undefined;
    type = !type && authType ? "BGV" : type; //background verification
    type = !type ? "isConnect" : type;

    const existingDev = Db.devMap.get(sn)
    if (existingDev && existingDev.size > 0) {
      const registrycode = existingDev.get("registrycode")
      retValue = `registry=ok`;
      retValue += `RegistryCode=${registrycode}`;
      retValue += getServiceParamete(sn);
    }

    // const device = await Db2.getDeviceBySN(sn);
    // if (device) {
    //   const { CodigoRegistro } = device
    //   retValue = `registry=ok`;
    //   retValue += `RegistryCode=${CodigoRegistro}`;
    //   retValue += getServiceParamete(sn);
    // }

    if (type === 'isConnect') {
      console.log("***************/cdata type=isconnect  || first step: set up connections between device and server***************")
    }
    else if (type === 'rtstate') {
      let datas = typeof req.body === 'object' ? req.body : parseJumpingString(req.body);
      console.log("***************/cdata type=rtstate  || post device's state to server***************")
      parseDevState(datas, sn);
    }
    else if (type === 'rtlog') {
      console.log("***************/cdata type=rtlog  || post device's event to server***************");
      const rawBody = typeof req.body === 'string' ? req.body : (req.body ? JSON.stringify(req.body) : '');
      let datas = typeof req.body === 'object' && req.body !== null && !Array.isArray(req.body) ? req.body : (typeof req.body === 'string' ? parseStringToMap(req.body) : {});
      const cardnoReceived = datas?.cardno || '(none)';
      console.log('[IClock] rtlog received: cardno=' + cardnoReceived + ', bodyKeys=' + Object.keys(datas || {}).join(',') + ', rawLen=' + (rawBody ? rawBody.length : 0));
      let eventName = '';
      if (datas && Object.keys(datas).length > 0) {
        if (Db.realEventList.size >= 40) {
          Db.realEventList = [];
        }
        Db.realEventList.push(objectToMap(datas));
        const eventMap = { ...datas, sn };
        //cardno = hex from decimal saved in qr
        if (eventMap["cardno"] && eventMap["cardno"] !== '') {
          const decimal = Number.isNaN(Number(eventMap["cardno"])) ? parseInt(eventMap["cardno"], 16) : Number(eventMap["cardno"]);
          const cardNoStr = String(decimal);
          const puerta = eventMap["eventaddr"] === "1" && eventMap["inoutstatus"] === "0" ? 1 : 2;
          const ubicacionRaw = await findMany("call spPRY_Ubicacion_ObtenerPorSNPuerta(?,?);", [sn, String(puerta)]);
          let ubicacion = Array.isArray(ubicacionRaw) ? ubicacionRaw : (ubicacionRaw ? [ubicacionRaw] : []);
          if (ubicacion.length > 0 && Array.isArray(ubicacion[0]) && ubicacion[0].length > 0 && typeof ubicacion[0][0] === 'object' && !Array.isArray(ubicacion[0][0])) {
            ubicacion = ubicacion[0];
          }
          const getIdSala = (row) => {
            if (!row || typeof row !== 'object' || Array.isArray(row)) return undefined;
            return row.IDSala ?? row.idsala ?? row.IDSALA ?? row['IDSala'] ?? row['idsala'];
          };
          const getPuerta = (row) => {
            if (!row || typeof row !== 'object' || Array.isArray(row)) return undefined;
            return row.Puerta ?? row.puerta ?? row.PUERTA ?? row['Puerta'] ?? row['puerta'];
          };
          let accessGranted = false;

          // 1. Check PRY_Acceso (personal QR from app users)
          const acceso = await findOne('call spPRY_Acceso_ObtenerPorAcceso(?);', [cardNoStr]);
          if (acceso && acceso.Payload) {
            const accesoPayload = JSON.parse(acceso.Payload);
            const isAdmin = accesoPayload.roleId === 1 || accesoPayload.roleId === '1';
            const salaRestricted = accesoPayload.sala != null && accesoPayload.sala !== '';
            const firstMatch = isAdmin || !salaRestricted
              ? ubicacion[0]  // Admin / no sala: allow any door
              : ubicacion.find(u => Number(accesoPayload.sala) === getIdSala(u));
            if (firstMatch) {
              // Payload dates are UTC (from obtainQR toISOString); parse as UTC for correct comparison
              const tiempohoy = moment.utc();
              const startTime = moment.utc(accesoPayload.fechaInicio || accesoPayload.fechalnicio, "YYYY-MM-DD HH:mm:ss");
              const endTime = moment.utc(accesoPayload.fechaFin, "YYYY-MM-DD HH:mm:ss");
              if (tiempohoy.isAfter(startTime) && tiempohoy.isBefore(endTime)) {
                eventMap["event"] = "200";
                Cmd.addDevCmd(eventMap["sn"], Cmd.openDoor(getPuerta(firstMatch) || 1));
                accessGranted = true;
                if (accesoPayload.isVisit) {
                  await pool.query("call spPRY_Acceso_Eliminar(?);", [cardNoStr]);
                }
              } else {
                console.log('[IClock] Personal QR cardno=' + cardNoStr + ' sala match but time window failed. Now(UTC)=' + tiempohoy.format() + ', valid=' + startTime.format() + ' to ' + endTime.format());
              }
            } else {
              const deviceSalas = ubicacion.length ? ubicacion.map(u => getIdSala(u)).join(',') : 'none';
              console.log('[IClock] Personal QR cardno=' + cardNoStr + ' denied: sala mismatch. Payload sala=' + accesoPayload.sala + ', device SN=' + sn + ' linked to IDSala=[' + deviceSalas + ']');
            }
          }

          // 2. If not found in PRY_Acceso, check PRY_Invitacion (visitor/delivery invitation QR)
          if (!accessGranted) {
            const invitation = await findOne('call spPRY_Invitacion_Validar(?);', [cardNoStr]);
            if (invitation && invitation.ValidationResult === 'VALID') {
              const invIdSala = getIdSala(invitation);
              const firstMatch = ubicacion.find(u => Number(invIdSala) === getIdSala(u));
              if (firstMatch) {
                eventMap["event"] = "200";
                Cmd.addDevCmd(eventMap["sn"], Cmd.openDoor(getPuerta(firstMatch) || 1));
                await pool.query('call spPRY_Invitacion_MarcarUsada(?);', [cardNoStr]);
                accessGranted = true;
              } else {
                const deviceSalas = (ubicacion && ubicacion.length) ? ubicacion.map(u => getIdSala(u)).join(',') : 'none';
                console.log('[IClock] Invitation cardno=' + cardNoStr + ' is VALID but denied: device SN=' + sn + ' puerta=' + puerta + ' is not linked to invitation room. Invitation IDSala=' + invIdSala + ', device linked to IDSala=[' + deviceSalas + ']. Link this device to that room in PRY_Ubicacion.');
              }
            } else if (invitation) {
              console.log('[IClock] Invitation cardno=' + cardNoStr + ' denied, ValidationResult=' + (invitation.ValidationResult || 'UNKNOWN'));
            }
          }

          if (!accessGranted) {
            eventMap["event"] = "29";
          }
          // }
          // const emps = Db.empMap;
          // const existEmp = [...emps.values()].find(innerMap => innerMap.get("empCard") === decimal.toString())
          // const existEmp = [...emps.values()].find(innerMap => (innerMap.get("empPin") || "").replace(/\./g, '').replace(/-/g, '') === decimal.toString())
          // if (emps && emps.size > 0 && existEmp && existEmp.size > 0) {
          // const a = await findMany("call spPRY_Sala_Puerta_ObtenerPorSN(?);", [sn])
          // const dateInit = existEmp?.get("empStartTime") !== "" ? new Date(existEmp?.get("empStartTime")) : "";
          // const dateEnd = existEmp?.get("empEndTime") !== "" ? new Date(existEmp?.get("empEndTime")) : undefined;
          // const dateCheck = new Date(eventMap["time"]);
          // if (dateCheck >= dateInit && (!dateEnd || dateCheck <= dateEnd)) {
          //   eventMap["event"] = "200";
          //   Cmd.addDevCmd(eventMap["sn"], Cmd.openDoor());
          // } else {
          //   eventMap["event"] = "29";
          // }
          // }
        }
        const eventNo = eventMap["event"]
        if (eventNo && eventNo.length > 0) {
          eventName = allEventMap.get(eventNo)
        }
      }
      // Cmd.openDoor()
      // Cmd.addDevCmd(sn, cmd);
      console.log(`\t(${eventName}) ${JSON.stringify(datas)}`)
    }
    else if (type === 'BGV') {
      console.log("***************/cdata type=BGV  || background verification***************")
      console.log(`◎background verification: ${authType}`)
      let datas = typeof req.body === 'object' ? req.body : parseStringToMap(req.body);
      console.log(`\t device event data: ${JSON.stringify(datas)}`)
      const ret = Cmd.retrunBGVerifyData(JSON.stringify(datas))
      console.log(`\t verify result: ${ret}`)
      retValue = ret;
    }
    else if (type === 'tabledata') {
      //UPDATE FINGERPRINT TEMPLATE
      let table = req.query.table ?? req.body.table ?? undefined;
      let count = req.query.count ?? req.body.count ?? undefined;
      let data = typeof req.body === 'object' ? req.body : parseStringToMap(req.body);
      let actualCount = data.length === 0 ? 0 : data.length;
      data = objectToMap(data);

      let retInfo = table + '=' + actualCount;
      let fieldArr = null;
      let fieldMap = null;
      let keyValArr = null;

      fieldArr = data.split(table)[1].trim();
      fieldArr = fieldArr.split("\t");
      fieldMap = new Map();

      for (let i = 0, len = fieldArr.length; i < len; i++) {
        keyValArr = fieldArr[i].trim().split('2', 2);
        if (keyValArr[0].toLowerCase() === 'name') {
          if (keyValArr[1].includes("#")) {
            fieldMap.set(keyValArr[0], keyValArr[1].split("#")[0]);
            fieldMap.set('lastName', keyValArr[1].split("#")[1]);
          } else {
            fieldMap.set(keyValArr[0], keyValArr[1]);
          }
        } else if (keyValArr[0].toLowerCase() === 'cardno') {
          let cardNo = keyValArr[1];
          if (table === 'mulcarduser') {
            cardNo = convertCardNo(cardNo, 16, 10);
          }
          if (cardNo !== '' && "0" === "1") {
            fieldMap.set(keyValArr[0], convertCardNo(cardNo, 10, 16));
          } else {
            fieldMap.set(keyValArr[0], cardNo);
          }
        } else {
          fieldMap.set(keyValArr[0], keyValArr[1]);
        }
      }

      let pin = fieldMap.get('pin')
      if (table === USER) {
        let startTime = fieldMap.get('starttime')
        let name = fieldMap.get('name')
        let password = fieldMap.get('password')
        let endTime = fieldMap.get('endtime')
        let cardNo = fieldMap.get('cardno')

        const map = new Map([
          ["empPin", pin],
          ["startTime", startTime],
          ["empName", name],
          ["empPwd", password],
          ["empCardNo", cardNo]
        ]);

        Db.empMap.set(pin, map);
      } else if (table === BIOPHOTO) {
        let picBase64 = fieldMap.get('content')
        let fileName = fieldMap.get('filename')
        let photoPath = generateBioPhoto(pin, fileName, picBase64, getServletContext())
        Db.empMap.get(fieldMap.get('pin')).set('photoPath', photoPath);
      }
    }
    else {
      console.log(`***************/cdata type=unknown  || request:${type}***************`)
    }
  } catch ({ message }) {
    retValue = `404`;
  } finally {
    return res.status(200).set("Content-Type", "text/plain").send(retValue)
  }
}

const registry = (req, res) => {
  try {
    console.log("***************/registry  || Start to regist***************")
    let retValue = '404';
    const sn = req.query.SN || null;
    if (sn) {
      const existingDev = Db.devMap.get(sn)
      // const device = Db2.getDeviceBySN(sn);
      if (existingDev) {//registrado
        const { CodigoRegistro } = existingDev;
        retValue = `RegistryCode=${CodigoRegistro}`;
        console.log(`\t has been registed, register code:${CodigoRegistro}`);
      }
      else {//no registrado
        const randomString = getRandomString(10);
        const datas = typeof req.body === 'object' ? req.body : parseStringToMap(req.body);
        let options = parseObjToMap2(datas);

        options += `ServerVersion=10.2,ServerName=ZKTECO,PushVersion=5.6,ErrorDelay=30,RequestDelay=3,TransTimes=00:30\t13:00,TransInterval=1,TransTables=User\tTransaction,Realtime=1,SessionID=${req.sessionID}`;


        // Db2.setDevice(sn, randomString);
        // Db2.setOptions(sn, options);
        retValue = `RegistryCode=${randomString}`;
        console.log(`\t not registered, go to regist, return register code:${randomString}`)
      }

      if (existingDev && existingDev.size > 0) { //registrado
        const registrycode = existingDev.get("registrycode")
        retValue = `RegistryCode=${registrycode}`;
        console.log(`\t has been registed, register code:${registrycode}`);
      }
      else { //no registrado
        //save device's informaation and part of server's information when registering
        //device information
        const randomString = getRandomString(10);
        let datas = typeof req.body === 'object' ? req.body : parseStringToMap(req.body);
        const dataMap = parseObjToMap(datas);
        const sessionId = req.sessionID;
        dataMap.set("ServerVersion", "10.2");
        dataMap.set("ServerName", "ZKTECO");
        dataMap.set("PushVersion", "5.6");
        dataMap.set("ErrorDelay", "30");
        dataMap.set("RequestDelay", "3");
        dataMap.set("TransTimes", "00:30\t13:00");
        dataMap.set("TransInterval", "1");
        dataMap.set("TransTables", "User\tTransaction");
        dataMap.set("Realtime", "1");
        dataMap.set("SessionID", sessionId);

        const optionsMap = new Map([
          ["options", dataMap],
          ["registrycode", randomString]
        ]);
        Db.devMap.set(sn, optionsMap)
        retValue = `RegistryCode=${randomString}`;
        console.log(`\t not registered, go to regist, return register code:${randomString}`)
      }
    }
    else {
      retValue = 'Invalid SN';
      return res.status(403).set("Content-Type", "text/plain").send(retValue)
    }
    console.log(retValue)
    return res.status(200).set("Content-Type", "text/plain").send(retValue)
  } catch ({ message }) {
    return res.status(403).set("Content-Type", "text/plain").send(message)
  }
}

const push = (req, res) => {
  let retValue = 'OK';
  try {
    console.log("***************/push  || device get parameters from server***************");
    const sn = req.query.SN || null
    if (sn) {
      retValue = getServiceParamete(sn);
    } else {
      throw new Error("Invalid SN");
    }
  } catch ({ message }) {
    retValue = '404';
  } finally {
    console.log(retValue)
    return res.status(200).set("Content-Type", "text/plain").send(retValue);
  }
}

const objectToMap = (obj) => {
  const map = new Map();
  for (const key in obj) {
    if (Object.hasOwnProperty.call(obj, key)) {
      const value = obj[key];
      map.set(key, value);
    }
  }
  return map;
}

const convertCardNo = (cardNo, beforeRadix, afterRadix) => {
  cardNo = new BigInt("0x" + cardNo).toString(afterRadix);
  return cardNo;
}

function generateBioPhoto(pin, photoName, imgStr, servletContext) {
  if (!imgStr) {
    return "";
  }
  try {
    const realPath = servletContext.getRealPath('/upload');
    const personPhotoPath = `\\upload\\${photoName}`;
    const b = Uint8Array.from(atob(imgStr), c => c.charCodeAt(0));
    const photoDir = realPath; // Assuming this is a directory path
    if (!fs.existsSync(photoDir)) {
      fs.mkdirSync(photoDir, { recursive: true });
    }
    const imgFilePath = `${realPath}\\${photoName}`;
    fs.writeFileSync(imgFilePath, b);

    return personPhotoPath;
  } catch (e) {
    return "";
  }
}


const getrequest = (req, res) => {
  let retValue = 'OK';
  try {
    console.log("device say: give me instructions");
    const sn = req.query.SN || null;
    let size = 0;
    if (sn) {
      if (Db.cmdListMap.get(sn)) {
        size = Db.cmdListMap.get(sn).length;
        if (size > 0) {
          console.log('◎get commands from server and execute');
          const cmd = Db.cmdListMap.get(sn).shift();
          console.log(`\t${cmd}`);
          retValue = cmd;
        }
      }
    }
  } catch ({ message }) {
    retValue = '404';
  } finally {
    return res.status(200).set("Content-Type", "text/plain").send(retValue)
  }
}

const devicecmd = (req, res) => {
  let retValue = 'OK';
  try {
    console.log("***************/devicecmd  || return the result of executed command to server***************");
    let datas = req.body;
    console.log(`◎result of executed command:${stringify(datas)}`);
    //save result to map
    let cmdId = parseInt(datas.split("&")[0].split("=")[1])
    if (Db.cmdMap.get(cmdId)) {
      let cmdArr = Db.cmdMap.get(cmdId);
      cmdArr[1] = datas;
      Db.cmdMap.set(cmdId, cmdArr);
    }
  } catch ({ message }) {
    retValue = '404';
  } finally {
    return res.status(200).set("Content-Type", "text/plain").send(retValue)
  }
}

const rtdata = (req, res) => {
  let retValue = 'OK';
  try {
    const type = req.query.type || null
    if (type === 'time') {
      console.log(`Entryt${Db.cmdMapdata}`)
      if (Db.cmdMapdata.has("devDet")) {
        retValue = Db.cmdMapdata.get("devDet");
        Db.cmdMapdata.delete("devDet");
        console.log(`Entrytgfd${Db.cmdMapdata}`)
      }
      console.log(`Db.cmdMap${mapToString(Db.cmdMap)}`)
    }
  } catch ({ message }) {
    retValue = '404';
  } finally {
    return res.status(200).set("Content-Type", "text/plain").send(retValue)
  }
}

const querydata = (req, res) => {
  let retValue = 'OK';
  try {
    console.log("***************/querydata  ||response the server with person data that server asked***************");
    let datas = typeof req.body === 'object' ? req.body : parseStringToMap(req.body);
    let type = req.query.type || null
    if (type === 'tabledata') {//returned value   /iclock/querydata?SN=0566141900195&type=tabledata&type=tabledata&cmdid=1&tablename=user&count=1&packcnt=1&packidx=1
      let table = req.query.tablename;
      let count = req.query.count;
      let actualCount = !datas ? 0 : datas.split("\r\n").length;
      if (count === actualCount) {
        retValue = `${table}=${actualCount}`;
      } else {
        return -731;
      }
    } else {
      //SN=0566141900195&type=count&cmdid=1&tablename=user&count=1&packcnt=1&packidx=1
      //SN=0566141900195&type=options&cmdid=1&tablename=options&count=1&packcnt=1&packidx=1
      //****above 2 request,return "ok" to device,
    }
    console.log(`◎returned value:${datas}`);
    //save the result
    let cmdId = parseInt(req.query.cmdid)
    if (Db.cmdMap.get(cmdId)) {
      let cmdArr = Db.cmdMap.get(cmdId);
      cmdArr[3] = datas.replaceAll("\\t", " ");
      Db.cmdMap.set(cmdId, cmdArr);
    }
  } catch ({ message }) {
    retValue = '404';
  } finally {
    return res.status(200).set("Content-Type", "text/plain").send(retValue)
  }
}

module.exports = {
  registry,
  cdata,
  push,
  getrequest,
  devicecmd,
  rtdata,
  querydata
}