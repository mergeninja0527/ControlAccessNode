const { pool, findOne, findMany } = require("../database/database.js")

class Db2 {
  static async getDeviceBySN(sn) {
    return await findOne("call spPRY_Device_GetBySN(?)", [sn]);
  }

  static async getOptionsBySN(sn) {
    return await findOne("call spPRY_Options_GetBySN(?)", [sn]);
  }

  static async getDevices() {
    return await findMany("call spPRY_Device_Get()", []);
  }

  static async setDevice(sn, registrycode) {
    await pool.query("call spPRY_Device_Set(?,?)", [sn, registrycode]);
  }

  static async setOptions(sn, options) {
    await pool.query("call spPRY_Options_Set(?,?)", [sn, options]);
  }
}

module.exports = { Db2 };