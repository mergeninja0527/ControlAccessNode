const { sensorDesMap, relayDesMap, alarmDesMap } = require("./Constantes.js");
const { Db2 } = require("./DatabaseUtils.js");
const { Db } = require("./Db.js");
function getRandomString(length) {
  const buffer = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let sb = '';
  const range = buffer.length;
  for (let i = 0; i < length; i++) {
    sb += buffer.charAt(Math.floor(Math.random() * range));
  }
  return sb;
}

function getRandomNumericString(length) {
  const buffer = "0123456789";
  let sb = '';
  const range = buffer.length;
  for (let i = 0; i < length; i++) {
    sb += buffer.charAt(Math.floor(Math.random() * range));
  }
  return sb;
}


function getServiceParamete(sn) {
  const serverParamete = ["ServerVersion", "ServerName", "PushVersion", "ErrorDelay", "RequestDelay", "TransTimes", "TransInterval", "TransTables", "Realtime", "SessionID", "TimeoutSec", "BioPhotoFun", "BioDataFun", "MultiBioDataSupport", "MultiBioPhotoSupport", "QRCodeDecryptKey", "QRCodeDecryptType"];

  const options = Db.devMap.get(sn).get('options')
  let sb = '';
  for (const param of serverParamete) {
    const value = options.get(param);
    if (value) {
      sb += `${param}=${value.replaceAll('\t', ' ')}\n`;
    }
  }

  return sb;
}

//TODO: falta realizar el parseo de los datos de la base de datos al formato map desde desconocido
function getServiceParamete2(sn) {
  const serverParamete = ["ServerVersion", "ServerName", "PushVersion", "ErrorDelay", "RequestDelay", "TransTimes", "TransInterval", "TransTables", "Realtime", "SessionID", "TimeoutSec", "BioPhotoFun", "BioDataFun", "MultiBioDataSupport", "MultiBioPhotoSupport", "QRCodeDecryptKey", "QRCodeDecryptType"];

  const { Options } = Db2.getOptionsBySN(sn);
  let sb = '';
  for (const param of serverParamete) {
    const value = options.get(param);
    if (value) {
      sb += `${param}=${value.replaceAll('\t', ' ')}\n`;
    }
  }

  return sb;
}

function parseJumpingString(data) {
  const result = {};
  data = data.split(' ');
  for (let i = 0; i < data.length; i++) {
    if (!data[i].includes('=')) {
      data[i - 1] = data[i - 1] + ' ' + data[i];
      data.splice(i, 1);
    }
  }
  data.forEach(option => {
    const optionArr = option.split('=');
    if (optionArr.length === 2) {
      result[optionArr[0]] = optionArr[1];
    }
  });
  return result;
}

function parseStringToMap(data) {
  const options = data.split(',');
  const ret = {}
  options.forEach((option) => {
    const optionArr = option.split('=');
    if (optionArr.length === 2) {
      ret[optionArr[0]] = optionArr[1]
    }
  })
  return ret
}

function getBinary(hexStrValue, lockCount, bitConvert, reverse) {
  let setValue = "";
  let intValue = 0n;
  if (reverse) {
    const validLetterLen = bitConvert * lockCount / 4;
    for (let i = 0; i < validLetterLen / 2; i++) {
      setValue += hexStrValue.substring(validLetterLen - (i + 1) * 2, validLetterLen - i * 2);
    }
    intValue = BigInt(parseInt(setValue, 16));
  } else {
    intValue = BigInt(parseInt(hexStrValue, 16));
  }
  let ret = ""; // "1,2,3,4"
  let sum = 0; // 8 doors need 8 bytes, type "int" is not enough
  for (let i = 0; i < bitConvert; i++) {
    sum += Math.pow(2, i); // 2^(i-1) // Bitwise operate
  }
  for (let i = 0; i < lockCount; i++) {
    if (ret === "") {
      ret += (intValue & BigInt(sum)).toString(); // >> 0
    } else {
      ret += "," + ((intValue >> BigInt(bitConvert * i)) & BigInt(sum)).toString();
    }
  }
  return ret;
}

function parseDoorStateDes(state, stateDesMap) {
  let stateDesc = "";
  const stateArr = state.split(",");
  for (const key of stateArr) {
    if (stateDesc.length === 0) {
      stateDesc = stateDesMap.get(key);
    } else {
      stateDesc += "," + stateDesMap.get(key);
    }
  }
  return stateDesc;
}

function parseDevState(datas, sn) {
  const stateMap = { ...datas }
  const optionsMap = Db.devMap.get(sn).get('options');
  const lockCount = parseInt(optionsMap.get('LockCount'));
  let sensor = stateMap.sensor;
  sensor = getBinary(sensor, lockCount, 2, false);
  let relay = stateMap.relay;
  relay = getBinary(relay, lockCount, 1, false);
  let alarm = stateMap.alarm;
  alarm = getBinary(alarm, lockCount, 8, true);
  let door = stateMap.door || 0;
  door = getBinary(door, lockCount, 8, false);
  console.log(`\tsensor:${sensor}  relay:${relay} alarm:${alarm}`);
  console.log('\t Door Sensor:(' + parseDoorStateDes(sensor, sensorDesMap) + ')'
    + ' Door Lock:(' + parseDoorStateDes(relay, relayDesMap) + ')'
    + ' Alarm:(' + parseDoorStateDes(alarm, alarmDesMap) + ')'
    + ' Door:(' + parseDoorStateDes(door, alarmDesMap) + ')')
}

function parseObjToMap(data) {
  const ret = new Map();
  for (const key in data) {
    ret.set(key, data[key]);
  }
  return ret;
}

function parseObjToMap2(data) {
  let rets = "";
  for (const key in data) {
    rets = `${key}=${data[key]},`;
  }
  return rets;
}

function mapToString(map) {
  let maptext = JSON.stringify(Object.fromEntries(map));
  maptext = maptext.replaceAll('"', '').replaceAll(':', '=').replaceAll(',', ', ');
}

function stringToObject(ll) {
  let obj = {};
  let arr = ll.split(',');
  for (let i = 0; i < arr.length; i++) {
    let temp = arr[i].split('=');
    obj[temp[0]] = temp[1];
  }
}

module.exports = {
  getRandomString,
  getRandomNumericString,
  getServiceParamete,
  getServiceParamete2,
  parseStringToMap,
  parseDevState,
  parseJumpingString,
  parseObjToMap,
  parseObjToMap2,
  mapToString,
  stringToObject,
}