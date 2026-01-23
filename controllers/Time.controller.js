const stringify = require("json-stringify-safe");
const { Db } = require("../utils/Db");

const timeServlet = (req, res) => {
  let ja = [];
  let ret = 'ok';
  try {
    let type = req.query.type ?? req.body.type ?? "";
    if (type === '0') {//Add or edit
      let enu = Object.getOwnPropertyNames(req.query);
      let id = req.query.id;
      let map = new Map();
      enu.forEach(e => {
        let key = e;
        if (key !== 'id') {
          map.set(key, req.query[key]);
        }
        Db.timeMap.set(id, map);
      });
    } else if (type === '1') {//query
      let times = Db.timeMap;
      let ids = Array.from(times.keys());
      let i = 0;
      for (const id of ids) {
        if (i != 0) break;//this demo just return one time segment
        let time = new Map(times.get(id));
        let keys = Array.from(time.keys());
        time.set("id", id);
        let t = {};
        for (const key of keys) {
          t[key] = time.get(key);
        }
        t["id"] = id;
        ja.push(t);
        i++;
      }
    }
  } catch (_) {
    ret = 'error';
  } finally {
    let info = {
      'ret': ret,
      'data': ja
    }
    return res.status(200).set("Content-Type", "text/plain").send(stringify(info))
  }
}

module.exports = { timeServlet }