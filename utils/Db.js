class Db {
  static bdId = 0;

  static getDbId() {
    return this.bdId++;
  }

  static devMap = new Map();
  static cmdMap = new Map();
  static cmdMapdata = new Map();
  static cmdListMap = new Map();
  static empMap = new Map();
  static empAuthMap = new Map();
  static authGroupMap = new Map();
  static realEventList = [];
  static time = new Map([
    ["mon_start_1", "00:00"],
    ["mon_start_2", "00:00"],
    ["mon_start_3", "00:00"],
    ["mon_end_1", "23:59"],
    ["mon_end_2", "00:00"],
    ["mon_end_3", "00:00"],

    ["tue_start_1", "00:00"],
    ["tue_start_2", "00:00"],
    ["tue_start_3", "00:00"],
    ["tue_end_1", "23:59"],
    ["tue_end_2", "00:00"],
    ["tue_end_3", "00:00"],

    ["wed_start_1", "00:00"],
    ["wed_start_2", "00:00"],
    ["wed_start_3", "00:00"],
    ["wed_end_1", "23:59"],
    ["wed_end_2", "00:00"],
    ["wed_end_3", "00:00"],

    ["thu_start_1", "00:00"],
    ["thu_start_2", "00:00"],
    ["thu_start_3", "00:00"],
    ["thu_end_1", "23:59"],
    ["thu_end_2", "00:00"],
    ["thu_end_3", "00:00"],

    ["fri_start_1", "00:00"],
    ["fri_start_2", "00:00"],
    ["fri_start_3", "00:00"],
    ["fri_end_1", "23:59"],
    ["fri_end_2", "00:00"],
    ["fri_end_3", "00:00"],

    ["sat_start_1", "00:00"],
    ["sat_start_2", "00:00"],
    ["sat_start_3", "00:00"],
    ["sat_end_1", "23:59"],
    ["sat_end_2", "00:00"],
    ["sat_end_3", "00:00"],

    ["sun_start_1", "00:00"],
    ["sun_start_2", "00:00"],
    ["sun_start_3", "00:00"],
    ["sun_end_1", "23:59"],
    ["sun_end_2", "00:00"],
    ["sun_end_3", "00:00"],

    ["hol1_start_1", "00:00"],
    ["hol1_start_2", "00:00"],
    ["hol1_start_3", "00:00"],
    ["hol1_end_1", "00:00"],
    ["hol1_end_2", "00:00"],
    ["hol1_end_3", "00:00"],

    ["hol2_start_1", "00:00"],
    ["hol2_start_2", "00:00"],
    ["hol2_start_3", "00:00"],
    ["hol2_end_1", "00:00"],
    ["hol2_end_2", "00:00"],
    ["hol2_end_3", "00:00"],

    ["hol3_start_1", "00:00"],
    ["hol3_start_2", "00:00"],
    ["hol3_start_3", "00:00"],
    ["hol3_end_1", "00:00"],
    ["hol3_end_2", "00:00"],
    ["hol3_end_3", "00:00"],

    ["desc", "24-Hour Accessible"],
  ]);

  static timeMap = new Map([
    ["1", [...this.time]]
  ])

  static VERIFY_MODE = new Map();

  VERIFY_MODE_CARDORFPORPWD = 0; // card , fingerprint or password
  VERIFY_MODE_ONLYFP = 1; // fingerprint only
  VERIFY_MODE_ONLYPIN = 2; // pin only
  VERIFY_MODE_ONLYPWD = 3; // password only
  VERIFY_MODE_ONLYCARD = 4; // card only
  VERIFY_MODE_FPORPWD = 5; // fingerprint or password
  VERIFY_MODE_CARDORFP = 6; // card or fingerprint
  VERIFY_MODE_CARDORPWD = 7; // card or password
  VERIFY_MODE_PINANDFP = 8; // pin and fingerprint
  VERIFY_MODE_FPANDPWD = 9; // fingerprint and password
  VERIFY_MODE_CARDANDFP = 10; // card and fingerprint
  VERIFY_MODE_CARDANDPWD = 11; // card and password
  VERIFY_MODE_FPANDCARDANDPWD = 12; // fingerprint and password and card
  VERIFY_MODE_PINANDFPANDPWD = 13; // fingerprint and password and pin
  VERIFY_MODE_PINANDFPORCARDANDFP = 14; // pin+fingerprint or card+fingerprint
  VERIFY_MODE_PINORCARDANDPWD = 15; // pin or card+password
  VERIFY_MODE_OTHER = 200; // others

  static {
    this.VERIFY_MODE.set(Db.VERIFY_MODE_CARDORFPORPWD, "card or fingerprint or password"); // card or fingerprint or password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_ONLYFP, "fingerprint only"); // fingerprint only
    this.VERIFY_MODE.set(Db.VERIFY_MODE_ONLYPIN, "pin only"); // pin only
    this.VERIFY_MODE.set(Db.VERIFY_MODE_ONLYPWD, "password only"); // password only
    this.VERIFY_MODE.set(Db.VERIFY_MODE_ONLYCARD, "card only"); // card only
    this.VERIFY_MODE.set(Db.VERIFY_MODE_FPORPWD, "fingerprint or password"); // fingerprint or password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_CARDORFP, "card or fingerprint"); // card or fingerprint
    this.VERIFY_MODE.set(Db.VERIFY_MODE_CARDORPWD, "card or password"); // card or password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_PINANDFP, "pin and fingerprint"); // pin and fingerprint
    this.VERIFY_MODE.set(Db.VERIFY_MODE_FPANDPWD, "fingerprint and password"); // fingerprint and password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_CARDANDFP, "card and fingerprint"); // card and fingerprint
    this.VERIFY_MODE.set(Db.VERIFY_MODE_CARDANDPWD, "card and password"); // card and password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_FPANDCARDANDPWD, "fingerprint and password and card"); // fingerprint and password and card
    this.VERIFY_MODE.set(Db.VERIFY_MODE_PINANDFPANDPWD, "pin and fingerprint and password"); // pin and fingerprint and password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_PINANDFPORCARDANDFP, "pin+fingerprint or card+fingerprint"); // pin+fingerprint or card+fingerprint
    this.VERIFY_MODE.set(Db.VERIFY_MODE_PINORCARDANDPWD, "pin or card+password"); // pin or card+password
    this.VERIFY_MODE.set(Db.VERIFY_MODE_OTHER, "others"); // others
  }

  constructor() {
    this.empMap = new Map();
    this.devMap = new Map();
    this.timeMap = new Map();
    this.verifyModeMap = new Map();
    this.verifyModeMap.set(Db.VERIFY_MODE_CARDORFPORPWD, "card or fingerprint or password"); // card or fingerprint or password
    this.verifyModeMap.set(Db.VERIFY_MODE_ONLYFP, "fingerprint only"); // fingerprint only
    this.verifyModeMap.set(Db.VERIFY_MODE_ONLYPIN, "pin only"); // pin only
    this.verifyModeMap.set(Db.VERIFY_MODE_ONLYPWD, "password only"); // password only
    this.verifyModeMap.set(Db.VERIFY_MODE_ONLYCARD, "card only"); // card only
    this.verifyModeMap.set(Db.VERIFY_MODE_FPORPWD, "fingerprint or password"); // fingerprint or password
    this.verifyModeMap.set(Db.VERIFY_MODE_CARDORFP, "card or fingerprint"); // card or fingerprint
    this.verifyModeMap.set(Db.VERIFY_MODE_CARDORPWD, "card or password"); // card or password
  }
}

module.exports = {
  Db
};