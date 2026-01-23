const stringify = require("json-stringify-safe");
const { Cmd } = require("../utils/Cmd");
const { Db } = require("../utils/Db");
const path = require("path");
// const { BaseImgEncodeUtil } = require("../utils/BaseImgEncodeUtil")

const authorityServlet = (req, res) => {
  let dev = [];
  let emp = [];
  let time = [];
  let data = [];
  let ret = "ok";
  try {
    let type = req.body.type || "";
    if (type === '1') {//query
      //devices
      let devs = Db.devMap;
      let keys = Array.from(devs.keys());
      for (const sn of keys) {
        let options = devs.get(sn).get("options");
        let d = {
          "sn": sn,
          "lockCount": options.get("LockCount")
        };
        dev.push(d);
      }

      //persons
      let emps = Db.empMap;
      let groutCode = req.query.authGroup;
      groutCode = (groutCode == null || groutCode == undefined || groutCode === 'null') ? "" : groutCode;
      let hasEmp = Db.empAuthMap.get(groutCode) == null ? "" : Db.empAuthMap.get(groutCode);
      let empKeys = Array.from(emps.keys());
      for (const pin of empKeys) {
        let vals = new Map(emps.get(pin))
        let e = {
          "empName": vals.get("empName"),
          "pin": pin
        };
        if (hasEmp.split("|").includes(pin)) {
          e["has_select"] = "selected";
        } else {
          e["has_select"] = "";
        }
        emp.push(e);
      }

      //time
      let times = Db.timeMap;
      let timeKeys = Array.from(times.keys());
      for (const id of timeKeys) {
        let vals = new Map(times.get(id));
        let e = {
          "desc": vals.get("desc"),
          "id": id,
        }
        time.push(e);
      }
    } else if (type === '2') {//Add Access Level
      let code = req.query.code ?? req.body.code ?? "";
      let desc = req.query.desc ?? req.body.desc ?? "";
      let timeId = req.query.time ?? req.body.time ?? "";
      let doors = req.query.doors ?? req.body.doors ?? "";
      if (code !== null && code !== "" && timeId !== null && timeId !== "") {
        let map = new Map([["desc", desc], ["time", timeId], ["doors", doors]]);
        Db.authGroupMap.set(code, map);
      } else {
        ret = "error";
      }
    } else if (type === '3') {
      let authGroup = Db.authGroupMap;
      let set = Array.from(authGroup.keys());
      for (const code of set) {
        let time = new Map(Db.timeMap.get(authGroup.get(code).get("time")))
        let temp = {
          "desc": authGroup.get(code).get("desc"),
          "code": code,
          "timeDesc": time.get("desc"),
        }
        data.push(temp);
      }
    } else if (type === '4') { //Access Level Setting
      let groupCode = req.query.groupCode ?? req.body.groupCode ?? "";
      groupCode = groupCode === "null" || !groupCode || groupCode === "" ? "" : groupCode;
      let del = req.query.del ?? req.body.del ?? ""; //Deleted person
      let add = req.query.add ?? req.body.add ?? ""; //Saved person
      if (groupCode.trim() !== "" && (del.trim() !== "" || add.trim() !== "")) {
        let map = new Map();
        let saveEmp = Db.empAuthMap.get(groupCode) == null ? "" : Db.empAuthMap.get(groupCode);
        let subArr;
        let tempArr;
        //Delete
        if (del.trim() !== "") {
          del = del.endsWith("|") ? del.substring(0, del.length - 1) : del;
          tempArr = saveEmp.split("\\|");
          subArr = del.split("\\|");
          for (let i = 0; i < subArr.length; i++) {
            if (tempArr.includes(subArr[i])) {
              saveEmp = saveEmp.replaceAll(subArr[i] + "|", "")
            }
          }
        }

        //save
        if (add.trim() !== "") {
          add = add.endsWith("|") ? add.substring(0, add.length - 1) : add;
          tempArr = saveEmp.split("\\|");
          subArr = add.split("\\|");
          for (let i = 0; i < subArr.length; i++) {
            if (!tempArr.includes(subArr[i])) {
              saveEmp += subArr[i] + "|";
            }
          }
        }

        Db.empAuthMap.set(groupCode, saveEmp);

        //+++++++++++++++++++++ Synchronize Access Level To Device  ++++++++++++++++++++++++++++

        let authGroup = Db.authGroupMap;
        //present access Level group
        let groupInfo = authGroup.get(groupCode);
        //present access Level group's devices and parameters
        let doors = groupInfo.get("doors");//sn_doorNo1|sn_doorNo2
        let groupTime = groupInfo.get("time");
        let snAndDoor = getdevSnAndDoor(doors, null);
        let snSet = Array.from(snAndDoor.keys());

        //1.delete all when delete ,then send all
        if (del.trim() !== "") {
          //get all devices in this access level group
          let delEmps = del.split("\\|");
          let sb;

          //send command to remove person from access level
          for (const sn of snSet) {
            let hasEmp = [];
            sb += "DATA DELETE userauthorize ";
            //									"DATA DELETE userauthorize Pin=1001\r\nPin=20150186\r\n";
            for (const pin of delEmps) {
              sb += `Pin=${pin}\r\n`;
            }
            Cmd.addDevCmd(sn, sb);
            sb = "";
            let authSet = Array.from(authGroup.keys());
            for (const authCode of authSet) {
              let group = authGroup.get(authCode);
              let emps = Db.empAuthMap.get(authCode);
              let door = group.get("doors");
              let timeId = group.get("time");
              for (const pin of delEmps) {
                //DATA UPDATE userauthorize Pin=116\tAuthorizeTimezoneId=1\tAuthorizeDoorId=3\r\nPin=96\tAuthorizeTimezoneId=1\tAuthorizeDoorId=3\r\n 
                if (door !== null && door.includes(`${sn}_`) && emps !== null && emps.includes(pin)) {
                  hasEmp.push(pin);
                  let authMap = getdevSnAndDoor(door, sn);
                  if (sb.length === 0) {
                    sb += `DATA UPDATE userauthorize Pin=${pin}\tAuthorizeTimezoneId=${timeId}\tAuthorizeDoorId=${authMap.get(sn)}\r\n`;
                  } else {
                    sb += `Pin=${pin}\tAuthorizeTimezoneId=${timeId}\tAuthorizeDoorId=${authMap.get(sn)}\r\n`;
                  }
                }
              }
              if (sb.length === 0) {
                Cmd.addDevCmd(sn, sb);
                sb = "";
              }
            }

            //delete person informations which who has no access
            for (const pin of delEmps) {
              if (!hasEmp.includes(pin)) {
                if (sb.length === 0) {
                  sb += `DATA DELETE user Pin=${pin}\r\n`;
                } else {
                  sb += `pin=${pin}\r\n`;
                }
              }
            }

            if (sb.length === 0) {
              Cmd.addDevCmd(sn, sb);
              sb = "";
            }
          }
        }
        if (add.trim() !== '') {
          //DATA UPDATE user CardNo=2\tPin=2\tPassword=281\tGroup=0\tStartTime=0\tEndTime=0\tName=郑2\tSuperAuthorize=0\tDisable=0\tCardNo=2812364\r\n
          //DATA UPDATE userauthorize Pin=116\tAuthorizeTimezoneId=1\tAuthorizeDoorId=3\r\n
          subArr = add.split("\\|");
          let empInfo = "";
          let empAuth = "";
          let empFace = "";
          let empUserPic = "";
          for (const sn of snSet) {
            for (let i = 0; i < subArr.length; i++) {
              let tPin = subArr[i];
              let empMap = Db.empMap.get(tPin);
              if (empInfo.length === 0) {
                empInfo += `DATA UPDATE user CardNo=${empMap.get("empCardNo")}\tPin=${empMap.get("empPin")}\tPassword=${empMap.get("empPwd")}\tGroup=0\t`;
                empInfo += `StartTime=${empMap.get("startTime")}\tEndTime=${empMap.get("endTime")}\tName=${empMap.get("empName")}\tSuperAuthorize=${empMap.get("issuper")}\t`;
                empInfo += `Disable=${empMap.get("empDisable")}\r\n`;
              } else {
                empInfo += `CardNo=${empMap.get("empCardNo")}\tPin=${empMap.get("empPin")}\tPassword=${empMap.get("empPwd")}\tGroup=0\t`;
                empInfo += `StartTime=${empMap.get("startTime")}\tEndTime=${empMap.get("endTime")}\tName=${empMap.get("empName")}\tSuperAuthorize=${empMap.get("issuper")}\t`;
                empInfo += `Disable=${empMap.get("empDisable")}\r\n`;
              }
              if (empAuth.length === 0) {
                empAuth += `DATA UPDATE userauthorize Pin=${tPin}\tAuthorizeTimezoneId=${groupTime}\tAuthorizeDoorId=${snAndDoor.get(sn)}\r\n`;
              } else {
                empAuth += `Pin=${tPin}\tAuthorizeTimezoneId=${groupTime}\tAuthorizeDoorId=${snAndDoor.get(sn)}\r\n`;
              }
              if (empMap.get("photoPath") && empMap.get("photoPath") !== "") {
                //Base64 Encode Image
                // let base64 = BaseImgEncodeUtil.encodeBase64(`${path.resolve(__dirname)}\\${empMap.get("photoPath")}`);
                //DATA UPDATE BIOPHOTO PIN={0}	Type={1}	Size={2}	Content={3}
                //empFace.append("DATA UPDATE BIOPHOTO PIN=" + empMap.get("empPin") + " Type=2" +  " Size=" + base64.length() + " Content=" + base64);
                //empFace.append("DATA UPDATE BIOPHOTO PIN=" + empMap.get("empPin") + " Type=9" +  " Size=0" + " Content=\tFormat=1\tUrl=" + empMap.get("photoPath"));
                // empFace += `DATA UPDATE BIOPHOTO PIN=${empMap.get("empPin")}\tType=9\tSize=0\tContent=\tFormat=1\tUrl=${empMap.get("photoPath").replaceAll("\\\\", "/") ?? "undefined"}\r\n`;
                //empUserPic.append("DATA UPDATE USERPIC PIN=" + empMap.get("empPin") + "\tSize=" + base64.length() + "\tContent=" + base64  +"\r\n");
              }
            }
            if (empInfo.length > 0) {
              Cmd.addDevCmd(sn, empInfo);
              Cmd.addDevCmd(sn, empAuth);
              Cmd.addDevCmd(sn, `DATA UPDATE timezone TimezoneId=${groupTime}${timezoneCmd(Db.timeMap.get(groupTime))}`);
              Cmd.addDevCmd(sn, empFace);
              Cmd.addDevCmd(sn, empUserPic);
              empInfo = "";
              empAuth = "";
            }
          }
        }
      } else {
        ret = "error";
      }
    }
  } catch (error) {
    console.log(error)
    ret = "error";
  } finally {
    let info = {
      "ret": ret,
      "dev": dev,
      "emp": emp,
      "time": time,
      "data": data
    }

    return res.status(200).set("Content-Type", "text/plain").send(stringify(info));
  }
}

//faltan funciones

function getdevSnAndDoor(doors, sn) {
  let ret = new Map();
  let temp = new Map();//<'SN','1,2,4'>
  if (doors !== null && doors.length > 0) {
    let doorArr = doors.split("|");
    for (const info of doorArr) {
      if (info !== "") {
        let sn_door = info.split("_");
        if (sn !== null && sn_door[0] !== sn) {
          break;
        }
        if (!temp.get(sn_door[0])) {
          temp.set(sn_door[0], sn_door[1])
        } else {
          temp.set(sn_door[0], `${temp.get(sn_door[0])},${sn_door[1]}`);
        }
      }
    }
  }
  let set = Array.from(temp.keys());
  for (const devSn of set) {
    ret.set(devSn, getAuthDoorId(temp.get(devSn)))
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

function timezoneCmd(map) {
  map = new Map(map)
  let paraString =
    "\tSunTime1=" + calculateTime(map.get("sun_start_1"), map.get("sun_end_1")) +
    "\tSunTime2=" + calculateTime(map.get("sun_start_2"), map.get("sun_end_2")) +
    "\tSunTime3=" + calculateTime(map.get("sun_start_3"), map.get("sun_end_3")) +
    "\tMonTime1=" + calculateTime(map.get("mon_start_1"), map.get("mon_end_1")) +
    "\tMonTime2=" + calculateTime(map.get("mon_start_2"), map.get("mon_end_2")) +
    "\tMonTime3=" + calculateTime(map.get("mon_start_3"), map.get("mon_end_3")) +
    "\tTueTime1=" + calculateTime(map.get("tue_start_1"), map.get("tue_end_1")) +
    "\tTueTime2=" + calculateTime(map.get("tue_start_2"), map.get("tue_end_2")) +
    "\tTueTime3=" + calculateTime(map.get("tue_start_3"), map.get("tue_end_3")) +
    "\tWedTime1=" + calculateTime(map.get("wed_start_1"), map.get("wed_end_1")) +
    "\tWedTime2=" + calculateTime(map.get("wed_start_2"), map.get("wed_end_2")) +
    "\tWedTime3=" + calculateTime(map.get("wed_start_3"), map.get("wed_end_3")) +
    "\tThuTime1=" + calculateTime(map.get("thu_start_1"), map.get("thu_end_1")) +
    "\tThuTime2=" + calculateTime(map.get("thu_start_2"), map.get("thu_end_2")) +
    "\tThuTime3=" + calculateTime(map.get("thu_start_3"), map.get("thu_end_3")) +
    "\tFriTime1=" + calculateTime(map.get("fri_start_1"), map.get("fri_end_1")) +
    "\tFriTime2=" + calculateTime(map.get("fri_start_2"), map.get("fri_end_2")) +
    "\tFriTime3=" + calculateTime(map.get("fri_start_3"), map.get("fri_end_3")) +
    "\tSatTime1=" + calculateTime(map.get("sat_start_1"), map.get("sat_end_1")) +
    "\tSatTime2=" + calculateTime(map.get("sat_start_2"), map.get("sat_end_2")) +
    "\tSatTime3=" + calculateTime(map.get("sat_start_3"), map.get("sat_end_3")) +
    "\tHol1Time1=" + calculateTime(map.get("hol1_start_1"), map.get("hol1_end_1")) +
    "\tHol1Time2=" + calculateTime(map.get("hol1_start_2"), map.get("hol1_end_2")) +
    "\tHol1Time3=" + calculateTime(map.get("hol1_start_3"), map.get("hol1_end_3")) +
    "\tHol2Time1=" + calculateTime(map.get("hol2_start_1"), map.get("hol2_end_1")) +
    "\tHol2Time2=" + calculateTime(map.get("hol2_start_2"), map.get("hol2_end_2")) +
    "\tHol2Time3=" + calculateTime(map.get("hol2_start_3"), map.get("hol2_end_3")) +
    "\tHol3Time1=" + calculateTime(map.get("hol3_start_1"), map.get("hol3_end_1")) +
    "\tHol3Time2=" + calculateTime(map.get("hol3_start_2"), map.get("hol3_end_2")) +
    "\tHol3Time3=" + calculateTime(map.get("hol3_start_3"), map.get("hol3_end_3")) +
    "\r\n";
  return paraString;
}

function calculateTime(start, end) {
  let startHour = parseInt(start.split(":")[0]);
  let startMin = parseInt(start.split(":")[1]);
  let endHour = parseInt(end.split(":")[0]);
  let endMin = parseInt(end.split(":")[1]);
  let value = ((startHour * 100 + startMin) << 16) + endHour * 100 + endMin;
  return value;
}

module.exports = { authorityServlet }