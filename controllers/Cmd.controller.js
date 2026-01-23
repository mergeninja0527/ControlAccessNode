const stringify = require("json-stringify-safe");
const { Db } = require("../utils/Db");

const cmdServlet = (_, res) => {
  let retJson = {}
  try {
    let cmdMap = Db.cmdMap;
    let set = Array.from(cmdMap.keys());
    let jsonArray = [];
    let value = "";
    let obj = {};
    for (const cmdId of set) {
      obj = {
        "cmdId": cmdId,
        "cmd": cmdMap.get(cmdId)[0],
        "cmdRet": cmdMap.get(cmdId)[1],
        "sn": cmdMap.get(cmdId)[2],
        //"cmdData": cmdMap.get(cmdId)[3],
      }
      jsonArray.push(obj);
      value = cmdMap.get(cmdId)[3];
    }

    retJson = {
      "cmdArray": jsonArray,
      "cmdData": value,
    }
  } catch (_) {
    retJson = 404
  }

  return res.status(200).set("Content-Type", "text/plain").send(stringify(retJson));
}

module.exports = {
  cmdServlet
}