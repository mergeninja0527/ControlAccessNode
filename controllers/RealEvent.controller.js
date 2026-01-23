const stringify = require("json-stringify-safe");
const { Db } = require("../utils/Db");

const realEvent = (_, res) => {
  let desc = 'ok';
  let ret = {
    "desc": desc,
    "data": Db.realEventList
  };
  return res.status(200).set("Content-Type", "text/plain").send(stringify(ret))
}

module.exports = { realEvent }