const { Db } = require('../utils/Db.js')
const { pool, exists, findMany } = require('../database/database.js');
const { Cmd } = require('../utils/Cmd.js');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const stringify = require('json-stringify-safe');
const { sendMail } = require('./mail.controller.js');
const qr = require('qr-image');
const { client: whatsappClient } = require('./whatsapp.controller.js');
const { MessageMedia } = require('whatsapp-web.js');

const addEmp = async (req, res) => {
  try {
    //       empPin    empName  empCard         empPwd    empStartTime  empEndTime          empSuper
    const { idUsuario, nombre, numeroTarjeta, contraseña, tiempoInicio,
      tiempoFinal, superUser, empGroup = '', empDisable = '', email } = req.body;
    const emp = new Map([
      ["empPin", idUsuario],
      ["empName", nombre],
      ["empCard", numeroTarjeta],
      ["empPwd", contraseña],
      ["empStartTime", tiempoInicio],
      ["empEndTime", tiempoFinal],
      ["empGroup", empGroup],
      ["empSuper", superUser],
      ["empDisable", empDisable],
      ["email", email]
    ]);

    const existe = await exists('tbl_emp', `IDUsuario = '${idUsuario}'`);

    if (existe)
      return res.status(400).json({ message: 'Emp ya existe.' })

    await pool.query(' call spPRY_Emp_Guardar(?,?,?,?,?,?,?); ',
      [idUsuario, nombre, numeroTarjeta, contraseña, tiempoInicio, tiempoFinal, superUser])

    Db.empMap.set(idUsuario, emp);

    return res.status(200).json({ message: 'Emp agregado' })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const getEmp = async (_, res) => {
  try {
    const empMap = Db.empMap;
    const sets = empMap.keys();
    const arr = [];
    for (pin of sets) {
      const emp = empMap.get(pin);
      const keySet = emp.keys();
      let t = {}
      for (key of keySet) {
        t[key] = emp.get(key);
      }
      t["id"] = pin;
      arr.push(t);
    }

    const data = await findMany("call spPRY_Emp_Listar();", [])

    if (!data || data.length === 0) {
      return res.status(200).json([])
    }

    const emps = mappingEmp(data)

    return res.status(200).json(emps)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const deleteEmp = async (req, res) => {
  try {
    //       empPin
    const { idUsuario } = req.body;
    Db.empMap.delete(idUsuario)
    const sets = Db.devMap;
    const set = sets.keys();
    for (sn of set) {
      Cmd.addDevCmd(sn, `DATA DELETE userauthorize Pin=${idUsuario}`)
      Cmd.addDevCmd(sn, `DATA DELETE user Pin=${idUsuario}`)
      Cmd.addDevCmd(sn, `DATA DELETE biophoto PIN=${idUsuario}`)
    }

    const existe = await exists('tbl_emp', `IDUsuario = '${idUsuario}'`);

    if (!existe)
      return res.status(400).json({ message: 'Emp no existe.' })

    await pool.query(' call spPRY_Emp_Eliminar(?); ', [idUsuario])

    res.status(200).json({ message: 'Empleado eliminado' });
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const mappingEmp = (datalist) => {
  return datalist.map(({ IDUsuario, Nombre, NumeroTarjeta, Password, TiempoInicio,
    TiempoFinal, SuperUser }) => ({
      idUsuario: IDUsuario,
      nombre: Nombre,
      numeroTarjeta: NumeroTarjeta,
      contraseña: Password,
      tiempoInicio: TiempoInicio,
      tiempoFinal: TiempoFinal,
      superUser: SuperUser[0]
    }))
}

const post = async (req, res) => {
  let ja = []
  let ret = "ok"
  try {
    let type = req.query.type ?? req.body.type ?? "";
    if (type === "0" || type === "") {//Add
      let empPin = req.query.empPin ?? req.body.pin ?? "";
      if (empPin !== null && empPin.trim().length > 0) {
        let empCard = req.query.empCard ?? req.body.card ?? "";
        let empName = req.query.empName ?? req.body.name ?? "";
        let empPwd = req.query.empPwd ?? req.body.pwd ?? "";
        let empStartTime = req.query.empStartTime ?? req.body.startTime ?? "";
        let empEndTime = req.query.empEndTime ?? req.body.endTime ?? "";
        let empGroup = req.query.empGroup ?? req.body.group ?? "";
        let empSuper = req.query.empSuper ?? req.body.isSuper ?? "";
        let empDisable = req.query.empDisable ?? req.body.isDisable ?? "";
        let map = new Map([
          ["empPin", empPin],
          ["empCard", empCard],
          ["empName", empName],
          ["empPwd", empPwd],
          ["empStartTime", empStartTime],
          ["empEndTime", empEndTime],
          ["empGroup", empGroup],
          ["empSuper", empSuper],
          ["empDisable", empDisable],
        ]);
        Db.empMap.set(empPin, map);
        const qrImage = qr.image(empCard.toString(), { type: 'png' });
        qrImage.pipe(fs.createWriteStream('./images/qr-code.png'));
        const data = fs.readFileSync('./images/qr-code.png')
        const image64 = data.toString("base64")
        const media = new MessageMedia('image/png', image64)
        let caption = "\nCódigo para acceso Sistema de Dispositivos";
        if (empStartTime.trim() !== "") {
          let fechaStart = empStartTime.split(empStartTime.includes('T') ? 'T' : " ")
          fechaStart = `${fechaStart[0].split("-").reverse().join("-")} ${fechaStart[1]}`
          caption += `\nVálido desde: ${fechaStart}`
        }
        if (empEndTime.trim() !== "") {
          let fechaFin = empEndTime.split(empEndTime.includes('T') ? 'T' : " ")
          fechaFin = `${fechaFin[0].split("-").reverse().join("-")} ${fechaFin[1]}`
          caption += `\nVálido hasta: ${fechaFin}`
        }
        // sendMessage(`56${empCard}`, media, caption)
      }
    } else if (type === "1") {
      let empMap = Db.empMap;
      let sets = Array.from(empMap.keys());
      for (const pin of sets) {
        let emp = empMap.get(pin);
        let keySet = Array.from(emp.keys());
        let t = {}
        for (const key of keySet) {
          t[key] = emp.get(key) + "";
        }
        t["id"] = pin;
        ja.push(t);
      }
    } else if (type === "2") {
      let pin = req.query.empPin ?? req.body.pin ?? "";
      Db.empMap.delete(pin);
      let devMap = Db.devMap;
      let set = Array.from(devMap.keys());
      for (const sn of set) {
        let dev = devMap.get(sn)
        Cmd.addDevCmd(sn, "DATA DELETE userauthorize Pin=" + pin);
        Cmd.addDevCmd(sn, "DATA DELETE user Pin=" + pin);
        Cmd.addDevCmd(sn, "DATA DELETE biophoto PIN=" + pin);
      }
    }
  } catch (_) {
    ret = "error"
  }

  let info = {
    ret: ret,
    data: ja
  }

  return res.status(200).set("Content-Type", "text/plain").send(stringify(info))
}

// function sendMessage(phone, content, caption = undefined) {
//   whatsappClient.sendMessage(`${phone}@c.us`, content, { caption })
// }

module.exports = {
  addEmp,
  getEmp,
  deleteEmp,
  post
}