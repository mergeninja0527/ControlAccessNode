const { Db } = require('./Db.js')

class Cmd {
  constructor(name, description, func) {
    this.name = name;
    this.description = description;
    this.func = func;
  }

  static openDoor(puerta = "1") {
    return `CONTROL DEVICE 010${puerta}0106`;
  }

  static retrunBGVerifyData(data) {
    return `AUTH=SUCCESS\r\n${data}\r\nCONTROL DEVICE 1 1 1 15\r\n`; //despues de verificar exitoso, abrir puerta por 15 seg
  }

  static addDevCmd(sn, cmd) {
    cmd = "C:" + Db.getDbId() + ":" + cmd;

    let cmdList;
    if (!Db.cmdListMap.get(sn)) {
      cmdList = [];
    } else {
      cmdList = Db.cmdListMap.get(sn);
    }
    cmdList.push(cmd);
    Db.cmdListMap.set(sn, cmdList);
    const cmdId = parseInt(cmd.split(":")[1]);
    const cmdArr = new Array(4); // save command and its result
    cmdArr[0] = cmd;
    cmdArr[1] = "";
    cmdArr[2] = sn;
    cmdArr[3] = "";

    if (cmd.includes("OPTIONS")) {
      const arrOfStr = cmd.split("OPTIONS");
      Db.cmdMapdata.set("devDet", arrOfStr[1].trim());
    }
    Db.cmdMap.set(cmdId, cmdArr);
  }
}
module.exports = {
  Cmd
}