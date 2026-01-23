//Descripción estado de los sensores de puerta
const sensorDesMap = new Map([
  ["0", "no sensor"],
  ["1", "closed"],
  ["2", "open"],
])

//Descripción estado de cerrado de puerta
const relayDesMap = new Map([
  ["0", "closed"],
  ["1", "open"],
])

//Descripción estado de alarma
const alarmDesMap = new Map([
  ["0", "no"],
  ["1", "Opened Forcefully"],
  ["2", "Tamper alarm"],
  ["4", "Duress password Alarm"],
  ["8", "Duress fingerprint Alarm"],
  ["16", "Door sensor alarm"],
  ["32", "reserved 32"],
  ["64", "reserved 64"],
  ["128", "reserved 128"],
])

//Descripción de eventos
const baseEventMap = new Map([
  ["0", "Normal Verify Open"],
  ["1", "Verify During Passage Mode Time Zone"],
  ["2", "First-Personnel Open"],
  ["3", "Multi-Personnel Open"],
  ["4", "Emergency Password Open"],
  ["5", "Open during Passage Mode Time Zone"],
  ["6", "Linkage Event Triggered"],
  ["7", "Cancel Alarm"],
  ["8", "Remote Opening"],
  ["9", "Remote Closing"],
  ["10", "Disable Normal Open"],
  ["11", "Enable Normal Open"],
  ["12", "Auxiliary Outpu Remotely Open"],
  ["13", "Auxiliary Output Remotely Close"],
  ["20", "Operate Interval too Short"],
  ["21", "Door Inactive Time Zone Verify Open"],
  ["22", "Illegal Time Zone"],
  ["23", "Access Denied"],
  ["24", "Anti-Passback"],
  ["25", "Interlock"],
  ["26", "Multi-Personnel Authentication Wait"],
  ["27", "Unregistered Personnel"],
  ["28", "Open Door Timeout"],
  ["29", "Personnel Expired"],
  ["36", "Door Inactive Time Zone(Press Exit Button)"],
  ["37", "Failed to Close during Passage Mode Time Zone"],
  ["38", "Card Reoirted Lost"],
  ["39", "Blacklisted"],
  ["41", "Verify Mode Error"],
  ["42", "Wiegand Format Error"],
  ["44", "Background Verify Failed"],
  ["45", "Background Verify Timed Out"],
  ["48", "Multi-Personnel Verify Failed"],
  ["100", "Tamper alarm"],
  ["101", "Duress Open Alarm"],
  ["102", "Opened Forcefully"],
  ["105", "Can not connect to server"],
  ["200", "Door Opened Correctly"],
  ["201", "Door Closed Correctly"],
  ["202", "Exit Button Open"],
  ["204", "Passage Mode Time Zone Over"],
  ["205", "Remote Normal Opening"],
  ["206", "Device Started"],
  ["208", "Superuser Open Doors"],
  ["209", "Exit Button triggered(Without Unlock)"],
  ["214", "Connected to the server"],
  ["220", "Auxiliary Input Disconnected"],
  ["221", "Auxiliary Input Shorted"],
  ["222", "Background Verification Success"],
  ["223", "Background Verification"],
  ["700", "Lost Connect"],
])

const allEventMap = new Map(baseEventMap);

const USER = "user";
const TABLEDATA = "tabledata";
const USERPIC = "userpic";
const OPTIONS = "options";
const COUNT = "count";
const BIOPHOTO = "biophoto";

module.exports = {
  sensorDesMap,
  relayDesMap,
  alarmDesMap,
  baseEventMap,
  allEventMap,
  USER,
  TABLEDATA,
  USERPIC,
  OPTIONS,
  COUNT,
  BIOPHOTO,
}