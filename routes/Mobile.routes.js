const { Router } = require('express')
const { obtainQR, addUsuario, obtenerQR, login, checkRutExists, getUserByRut, getUnidades } = require('../controllers/Mobile.controller.js')
const router = Router()

router.post('/obtainQR', obtainQR)

router.post('/login', login)

router.get('/obtainQR/:user', obtenerQR)

router.post('/createUser', addUsuario)

router.post('/check-rut', checkRutExists)
router.post('/get-user-by-rut', getUserByRut)
router.get('/unidades', getUnidades)

module.exports = { mobileRouter: router }