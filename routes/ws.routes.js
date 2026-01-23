const { Router } = require('express')
const { findByRut, saveFingerprint } = require('../controllers/ws.controller.js')
const router = Router()

router.get('/ws/user/:rut', findByRut)
router.post('/ws/fingerprint', saveFingerprint)

module.exports = { wsRouter: router }