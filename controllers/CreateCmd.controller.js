const { Cmd } = require("../utils/Cmd");

//Create commands that can be read by devices

const createCmd = (req, res) => {
  let ret = '{"ret":"ok"}';
  try {
    let cmd = '';
    let sn = req.query.sn ?? req.body.sn ?? "";
    let cmdType = req.query.cmdType ?? req.body.cmdType ?? "";
    let door = req.query.door ?? req.body.door ?? "1";
    if (cmdType && cmdType.length > 0) {
      if (cmdType === 'openDoor') {// ◎command that has already been defined
        cmd = Cmd.openDoor(door);
      } else if (cmdType === 'userDefined') {
        let originalCmd = req.query.originalCmd ?? req.body.originalCmd ?? "";//original command
        if (originalCmd && originalCmd.trim() !== "") {
          cmd = originalCmd;
        }
      }
      if (cmd && cmd.length > 0) {
        Cmd.addDevCmd(sn, cmd);
      }
    }
  } catch (error) {
    ret = '{"ret":"error"}';
  } finally {
    return res.status(200).set("Content-Type", "text/plain").send(ret)
  }
}

module.exports = { createCmd }