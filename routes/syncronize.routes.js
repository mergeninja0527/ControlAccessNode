const { Router } = require("express");
const { syncFingerprint, syncUser, getCountFingerprint, getCountUser, deleteFingerprint, deleteUser } = require("../controllers/syncronize.controller");

const router = Router()

router.post("/sync/fingerprint", syncFingerprint)
router.post("/sync/user", syncUser)

router.get("/sync/count/fingerprint", getCountFingerprint)
router.get("/sync/count/user", getCountUser)

router.delete("/sync/fingerprint", deleteFingerprint)
router.delete("/sync/user", deleteUser)

module.exports = {
    syncronizeRouter: router
}