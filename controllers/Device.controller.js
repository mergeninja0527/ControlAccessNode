//query information about devices

const stringify = require("json-stringify-safe");
const { Cmd } = require("../utils/Cmd");
const { Db } = require("../utils/Db");

const deviceServlet = (req, res) => {
  let data = [];
  let ret = {};
  let desc = "ok";
  try {
    let type = req.query.type ?? req.body.type ?? "";
    if (type !== null && type.trim() !== "") {
      if (type === "1") {//query device
        let devMap = Db.devMap;
        let set = Array.from(devMap.keys());
        for (const sn of set) {
          let dev = devMap.get(sn);
          let options = dev.get("options");
          let obj = {};
          let optionsKeys = Array.from(options.keys());
          if (optionsKeys.some(item => item === "MaskDetectionFunOn")) {
            obj["MaskDetectionFunOn", options.get("MaskDetectionFunOn")];
          }
          if (optionsKeys.some(item => item === "IRTempDetectionFunOn")) {
            obj["IRTempDetectionFunOn", options.get("IRTempDetectionFunOn")];
          }
          obj = {
            ...obj,
            "sn": sn,
            "LockCount": options.get("LockCount"),//Lock count
            "FirmVer": options.get("FirmVer"),//firmware version
            "registrycode": dev.get("registrycode"),//register code
            "DeviceName": options.get("~DeviceName")//device name
          };
          data.push(obj);
        }
      } else if (type === "2") {//synchronize device's data
        let sn = req.type.sn;
        let sb = "";
        //delete access
        Cmd.addDevCmd(sn, "DATA DELETE userauthorize *");
        //delete person
        Cmd.addDevCmd(sn, "DATA DELETE user *");
        //delete time
        Cmd.addDevCmd(sn, "DATA DELETE timezone *");

        Cmd.addDevCmd(sn, "DATA DELETE biophoto *");

        //query time door and person about this device
        let list = [];
        let info;
        let groups = Db.authGroupMap;
        let groupCodeSet = Array.from(groups.keys());
        for (const code of groupCodeSet) {
          let group = groups.get(code);
          let doors = group.get("doors");//sn_doorNo|sn_doorNo
          let snDoorMap = getdevSvAndDoor(doors, sn);//<sn,1><sn,3>
          if (snDoorMap !== null && snDoorMap.get(sn) !== null && Db.empAuthMap.get(code) !== null) {//door is not null and person is not null
            info = new Map([
              ["doors", snDoorMap.get(sn)],
              ["emps", Db.empAuthMap.get(code)],
              ["time", group.get("time")]
            ]);
            list.push(info);
          }
        }
        //send time command to device
        for (let i = 0; i < list.length; i++) {
          info = list.get(i);
          let timeId = info.get("time");
          let doors = info.get("doors");
          let emps = info.get("emps");

          let cmd = getTimeCmd(timeId);

          Cmd.addDevCmd(sn, cmd);

          //send person and access level command to device
          emps = emps.substring(0, emps.length - 1);
          let subArr = emps.split("\\|");
          let empInfo = "";
          let empAuth = "";
          for (let j = 0; j < subArr.length; j++) {
            let tPin = subArr[i];
            let empMap = Db.empMap.get(tPin);
            if (empInfo.length === 0) {
              if (empMap !== null) {
                empInfo += `DATA UPDATE user CardNo=${empMap.get("empCard")}\tPin=${empMap.get("empPin")}\t`;
                empInfo += `Password=${empMap.get("empPwd")}\tGroup=0\tStartTime=0\tEndTime=0\tName=${empMap.get("empName")}\t`;
                empInfo += `SuperAuthorize=${empMap.get("empSuper")}\tDisable=${empMap.get("empDisable")}\r\n`;
              }
            } else {
              if (empMap !== null) {
                empInfo += `CardNo=${empMap.get("empCard")}\tPin=${empMap.get("empPin")}\tPassword=${empMap.get("empPwd")}\t`;
                empInfo += `Group=0\tStartTime=0\tEndTime=0\tName=${empMap.get("empName")}\tSuperAuthorize=${empMap.get("empSuper")}\t`;
                empInfo += `Disable=${empMap.get("empDisable")}\r\n`;
              }
            }
            if (empAuth.length === 0) {
              empAuth += `DATA UPDATE userauthorize Pin=${tPin}\tAuthorizeTimezoneId=${timeId}\tAuthorizeDoorId=${doors}\r\n`;
            } else {
              empAuth += `Pin=${tPin}\tAuthorizeTimezoneId=${timeId}\tAuthorizeDoorId=${doors}\r\n`;
            }
          }
          if (empInfo.length > 0) {
            Cmd.addDevCmd(sn, empInfo);
            Cmd.addDevCmd(sn, empAuth);
            empInfo = "";
            empAuth = "";
          }
        }
      }
    }
  } catch (_) {
    desc = "error";
  } finally {
    ret["desc"] = desc;
    ret["data"] = data;
    return res.status(200).set("Content-Type", "text/plain").send(stringify(ret));
  }
}

function getdevSnAndDoor(doors, sn) {
  let ret = new Map();
  let temp = new Map();//<'SN','1,2,4'>
  if (doors !== null && doors.length > 0) {
    let doorArr = doors.split("\\|");
    for (const info of doorArr) {
      if (info !== "") {
        let sn_door = info.split("_");
        if (sn !== null && sn_door[0] !== sn) {
          break;
        }
        if (temp.get(sn_door[0]) === null) {
          temp.set(sn_door[0], sn_door[1]);
        } else {
          temp.set(sn_door[0], `${temp.get(sn_door[0])},${sn_door[1]}`);
        }
      }
    }
  }
  let set = Array.from(temp.keys());
  for (const devSn of set) {
    ret.set(devSn, getAuthDoorId(temp.get(devSn)));
  }
  return ret;
}

function getAuthDoorId(doorNos) {
  let doorNoArray = doorNos.split(",");
  let authSum = 0;
  for (const doorNo of doorNoArray) {
    authSum = authSum + parseInt(Math.pow(2, parseInt(doorNo) - 1));
  }
  return String(authSum);
}

//Create time segment command
function getTimeCmd(timeId) {
  let timeSegSet = new Map();
  let timeSegMap = new Map();
  let timeMap = Db.timeMap.get(timeId);

  timeSegMap.set("timeSegId", timeId);

  timeSegMap.set("MonTime1", formatTime(timeMap.get("mon_start_1"), timeMap.get("mon_end_1")));
  timeSegMap.set("MonTime2", formatTime(timeMap.get("mon_start_2"), timeMap.get("mon_end_2")));
  timeSegMap.set("MonTime3", formatTime(timeMap.get("mon_start_3"), timeMap.get("mon_end_3")));

  timeSegMap.set("TueTime1", formatTime(timeMap.get("tue_start_1"), timeMap.get("tue_end_1")));
  timeSegMap.set("TueTime2", formatTime(timeMap.get("tue_start_1"), timeMap.get("tue_end_1")));
  timeSegMap.set("TueTime3", formatTime(timeMap.get("tue_start_1"), timeMap.get("tue_end_1")));

  timeSegMap.set("WedTime1", formatTime(timeMap.get("wed_start_1"), timeMap.get("wed_end_1")));
  timeSegMap.set("WedTime2", formatTime(timeMap.get("wed_start_1"), timeMap.get("wed_end_1")));
  timeSegMap.set("WedTime3", formatTime(timeMap.get("wed_start_1"), timeMap.get("wed_end_1")));

  timeSegMap.set("ThuTime1", formatTime(timeMap.get("thu_start_1"), timeMap.get("thu_end_1")));
  timeSegMap.set("ThuTime2", formatTime(timeMap.get("thu_start_1"), timeMap.get("thu_end_1")));
  timeSegMap.set("ThuTime3", formatTime(timeMap.get("thu_start_1"), timeMap.get("thu_end_1")));

  timeSegMap.set("FriTime1", formatTime(timeMap.get("fri_start_1"), timeMap.get("fri_end_1")));
  timeSegMap.set("FriTime2", formatTime(timeMap.get("fri_start_1"), timeMap.get("fri_end_1")));
  timeSegMap.set("FriTime3", formatTime(timeMap.get("fri_start_1"), timeMap.get("fri_end_1")));

  timeSegMap.set("SunTime1", formatTime(timeMap.get("sun_start_1"), timeMap.get("sun_end_1")));
  timeSegMap.set("SunTime2", formatTime(timeMap.get("sun_start_1"), timeMap.get("sun_end_1")));
  timeSegMap.set("SunTime3", formatTime(timeMap.get("sun_start_1"), timeMap.get("sun_end_1")));

  timeSegMap.set("SatTime1", formatTime(timeMap.get("sat_start_1"), timeMap.get("sat_end_1")));
  timeSegMap.set("SatTime2", formatTime(timeMap.get("sat_start_1"), timeMap.get("sat_end_1")));
  timeSegMap.set("SatTime3", formatTime(timeMap.get("sat_start_1"), timeMap.get("sat_end_1")));

  timeSegMap.set("Hol1Time1", formatTime(timeMap.get("hol1_start_1"), timeMap.get("hol1_end_1")));
  timeSegMap.set("Hol1Time2", formatTime(timeMap.get("hol1_start_1"), timeMap.get("hol1_end_1")));
  timeSegMap.set("Hol1Time3", formatTime(timeMap.get("hol1_start_1"), timeMap.get("hol1_end_1")));

  timeSegMap.set("Hol2Time1", formatTime(timeMap.get("hol2_start_1"), timeMap.get("hol2_end_1")));
  timeSegMap.set("Hol2Time2", formatTime(timeMap.get("hol2_start_1"), timeMap.get("hol2_end_1")));
  timeSegMap.set("Hol2Time3", formatTime(timeMap.get("hol2_start_1"), timeMap.get("hol2_end_1")));

  timeSegMap.set("Hol3Time1", formatTime(timeMap.get("hol3_start_1"), timeMap.get("hol3_end_1")));
  timeSegMap.set("Hol3Time2", formatTime(timeMap.get("hol3_start_1"), timeMap.get("hol3_end_1")));
  timeSegMap.set("Hol3Time3", formatTime(timeMap.get("hol3_start_1"), timeMap.get("hol3_end_1")));
  timeSegSet.add(timeSegMap);
  return decodeTimeSeg(timeSegSet);
}

//Create time segment command
function decodeTimeSeg(timeSegOptColl) {
  let cmdStrBuf = "";
  let tempBuffer = "";
  for (const opt of timeSegOptColl) {
    tempBuffer += `TimezoneId=${opt.get("timeSegId")}\t`;
    tempBuffer += `SunTime1=${opt.get("SunTime1")}\t`;
    tempBuffer += `SunTime2=${opt.get("SunTime2")}\t`;
    tempBuffer += `SunTime3=${opt.get("SunTime3")}\t`;
    tempBuffer += `MonTime1=${opt.get("MonTime1")}\t`;
    tempBuffer += `MonTime2=${opt.get("MonTime2")}\t`;
    tempBuffer += `MonTime3=${opt.get("MonTime3")}\t`;
    tempBuffer += `TueTime1=${opt.get("TueTime1")}\t`;
    tempBuffer += `TueTime2=${opt.get("TueTime2")}\t`;
    tempBuffer += `TueTime3=${opt.get("TueTime3")}\t`;
    tempBuffer += `WedTime1=${opt.get("WedTime1")}\t`;
    tempBuffer += `WedTime2=${opt.get("WedTime2")}\t`;
    tempBuffer += `WedTime3=${opt.get("WedTime3")}\t`;
    tempBuffer += `ThuTime1=${opt.get("ThuTime1")}\t`;
    tempBuffer += `ThuTime2=${opt.get("ThuTime2")}\t`;
    tempBuffer += `ThuTime3=${opt.get("ThuTime3")}\t`;
    tempBuffer += `FriTime1=${opt.get("FriTime1")}\t`;
    tempBuffer += `FriTime2=${opt.get("FriTime2")}\t`;
    tempBuffer += `FriTime3=${opt.get("FriTime3")}\t`;
    tempBuffer += `SatTime1=${opt.get("SatTime1")}\t`;
    tempBuffer += `SatTime2=${opt.get("SatTime2")}\t`;
    tempBuffer += `SatTime3=${opt.get("SatTime3")}\t`;
    tempBuffer += `Hol1Time1=${opt.get("Hol1Time1")}\t`;
    tempBuffer += `Hol1Time2=${opt.get("Hol1Time2")}\t`;
    tempBuffer += `Hol1Time3=${opt.get("Hol1Time3")}\t`;
    tempBuffer += `Hol2Time1=${opt.get("Hol2Time1")}\t`;
    tempBuffer += `Hol2Time2=${opt.get("Hol2Time2")}\t`;
    tempBuffer += `Hol2Time3=${opt.get("Hol2Time3")}\t`;
    tempBuffer += `Hol3Time1=${opt.get("Hol3Time1")}\t`;
    tempBuffer += `Hol3Time2=${opt.get("Hol3Time2")}\t`;
    tempBuffer += `Hol3Time3=${opt.get("Hol3Time3")}`;
    cmdStrBuf += tempBuffer + "\r\n";
  }
  let cmd = `DATA UPDATE timezone ${cmdStrBuf}`;
  return cmd;
}

//Time format switch
function formatTime(startTime, endTime) {
  let start = parseInt(startTime.split(":")[0]) * 100 + parseInt(startTime.split(":")[1]);
  let end = parseInt(endTime.split(":")[0]) * 100 + parseInt(endTime.split(":")[1]);
  return (start << 16) + (end & (0xFFFF));
}

module.exports = { deviceServlet }