const { Cmd } = require("../utils/Cmd")
const { Db } = require('../utils/Db.js');

const syncFingerprint = async (req, res) => {
    const { user_id, fingerprint, finger_id } = req.body

    try {
        /**
         * En inbio
         * Pin = UserID
         * FingerID = Numero dedo 0 al 9
         * Valid = Invalido 0 Valido 1 Duress 3
         * Template = Base64 Template Fingerprint
         */
        const command = `DATA UPDATE templatev10 Pin=${user_id}\tFingerID=${finger_id}\tValid=${1}\tTemplate=${fingerprint}`;
        Cmd.addDevCmd("AJYX233160037", command)
    } catch ({ message }) {
        return res.status(403).json({ message })
    }
}

const syncUser = async (req, res) => {
    try {
        const { cardno, pin, password, group = 1, startime = 0, endtime = 0, name, privilege } = req.body
        /**
         * En inbio es user por tabla usuario
         * CardNo = Entero positivo Hex o string
         * Pin = User ID
         * Password = password
         * Group = grupo al que pertenece default 1
         * StartTime = inicio temporal de validez if DateFmtFunOn = 1 en seg if 0 en YYYYMMDD, valor es 0 usuario sin limite
         * EndTime = Termino temporal de validez if DateFmtFunOn = 1 en seg if 0 en YYYYMMDD, valor es 0 usuario sin limite
         * Name = nombre usuario
         * Privilege =  usuario comun = 0 registrar = 2 administrator = 6 user-defined = 10 super-admin = 14
         */

        const command = `DATA UPDATE user CardNo=${cardno}\tPin=${pin}` +
            `\tPassword=${password}\tGroup=${group}\tStartTime=${startime}` +
            `\tEndTime=${endtime}\tName=${name}\tPrivilege=${privilege}`;

        Cmd.addDevCmd("AJYX233160037", command)
    } catch ({ message }) {
        return res.status(403).json({ message })
    }
}

const getCountFingerprint = (_, res) => {
    try {
        /**
         * En inbio
         * type = 0 general 1 fingerprint 2 face (infrared) 3 voiceprint 4 iris 5 retina 6 palmprint 7 fingervein 8 palm 9 visible light face
         */
        const command = `DATA COUNT biophoto Type=${1}`;
        Cmd.addDevCmd("AJYX233160037", command)
    } catch ({ message }) {
        return res.status(403).json({ message })
    }
}

const getCountUser = (_, res) => {
    try {
        /**
         * En inbio
         */
        const command = `DATA COUNT user`;
        Cmd.addDevCmd("AJYX233160037", command)

        let a = []
        setTimeout(()=>{
            a = Db.cmdMap;
        }, 1000)
        console.log(a)
    } catch ({ message }) {
        return res.status(403).json({ message })
    }
}

const deleteFingerprint = (req, res) => {
    try {
        const { pin, finger_id } = req.params
        /**
         * En inbio
         */
        const command = `DATA DELETE templatev10 Pin=${pin}\tFingerID=${finger_id}`;
        Cmd.addDevCmd("AJYX233160037", command)
    } catch ({ message }) {
        return res.status(403).json({ message })
    }
}

const deleteUser = (req, res) => {
    try {
        const { pin } = req.params
        /**
         * En inbio
         */
        const command = `DATA DELETE user Pin=${pin}`;
        Cmd.addDevCmd("AJYX233160037", command)
    } catch ({ message }) {
        return res.status(403).json({ message })
    }
}

module.exports = {
    syncFingerprint,
    syncUser,
    getCountFingerprint,
    getCountUser,
    deleteFingerprint,
    deleteUser,
}