const { pool } = require('../database/database.js');
const { Cmd } = require('../utils/Cmd.js');
// const { Db2 } = require('../utils/DatabaseUtils.js');
const { Db } = require('../utils/Db.js');
const { stringToObject } = require('../utils/Functions.js');

const getDevice = (_, res) => {
  try {
    const devMap = Db.devMap;
    const set = devMap.keys();
    const data = []
    for (const sn of set) {
      const dev = devMap.get(sn);
      const options = dev.get('options');
      const optionsSet = Array.from(options.keys());
      let obj = {
        "sn": sn,
        "LockCount": options.get('LockCount'),
        "FirmVer": options.get('FirmVer'),
        "registrycode": dev.get('registrycode'),
        "deviceName": options.get('~DeviceName'),
      }
      if (optionsSet.some(item => item === 'MaskDetectionFunOn')) {
        obj['MaskDetectionFunOn'] = options.get('MaskDetectionFunOn');
      }
      if (optionsSet.some(item => item === 'IRTempDetectionFunOn')) {
        obj['IRTempDetectionFunOn'] = options.get('IRTempDetectionFunOn');
      }
      data.push(obj);
    }
    return res.status(200).json(data)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const get = async (_, res) => {
  try {
    const device = await Db2.getDevices();
    const data = device.map(({ NumeroSerial, CodigoRegistro, Options }) => {
      let options = stringToObject(Options);
      let obj = {
        "sn": NumeroSerial,
        "LockCount": options['LockCount'] || "",
        "FirmVer": options['FirmVer'] || "",
        "registrycode": CodigoRegistro || "",
        "deviceName": options['~DeviceName'] || "",
      }
      if (options.MaskDetectionFunOn) {
        obj['MaskDetectionFunOn'] = options['MaskDetectionFunOn'];
      }
      if (options.IRTempDetectionFunOn) {
        obj['IRTempDetectionFunOn'] = options['IRTempDetectionFunOn'];
      }
      return obj;
    })
    return res.status(200).json(data)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const devicesSelect = async (_, res) => {
  try {
    const devMap = Db.devMap;
    const set = devMap.keys();
    const data = []
    for (const sn of set) {
      // const dev = devMap.get(sn);
      // const options = dev.get('options');
      // const optionsSet = Array.from(options.keys());
      let obj = {
        "value": sn,
        "label": sn,
        // "LockCount": options.get('LockCount'),
        // "FirmVer": options.get('FirmVer'),
        // "registrycode": dev.get('registrycode'),
        // "deviceName": options.get('~DeviceName'),
      }
      // if (optionsSet.some(item => item === 'MaskDetectionFunOn')) {
      //   obj['MaskDetectionFunOn'] = options.get('MaskDetectionFunOn');
      // }
      // if (optionsSet.some(item => item === 'IRTempDetectionFunOn')) {
      //   obj['IRTempDetectionFunOn'] = options.get('IRTempDetectionFunOn');
      // }
      data.push(obj);
    }
    return res.status(200).json(data)
  } catch ({ message }) {
    return res.status(403).json({ message });
  }
}

const devicesDoorsSelect = async (req, res) => {
  try {
    const { searchSN } = req.params
    const devMap = Db.devMap.get(searchSN);
    if (!devMap)
      throw new Error("No se encuentra información del dispositivo indicado.")
    const options = devMap.get("options");
    const puertas = options.get("LockCount")
    if (!puertas || puertas.length === 0)
      throw new Error("No se encuentra información del dispositivo indicado.")
    const data = [];
    for (let i = 1; i <= Number(puertas); i++) {
      let obj = {
        value: `${searchSN}_${i}`,
        label: `Puerta ${i}`
      }
      data.push(obj);
    }
    return res.status(200).json(data)
  } catch ({ message }) {
    return res.status(403).json({ message });
  }
}

module.exports = {
  getDevice,
  devicesSelect,
  devicesDoorsSelect
}