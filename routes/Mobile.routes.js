const { Router } = require('express')
const { obtainQR, addVisita, addUsuario, obtenerQR, login } = require('../controllers/Mobile.controller.js')
const router = Router()

router.post('/obtainQR', obtainQR)

router.post('/auth/login', login)

router.get('/obtainQR/:user', obtenerQR)

router.post('/visita', addVisita)

router.post('/registrar', addUsuario)

module.exports = { mobileRouter: router }