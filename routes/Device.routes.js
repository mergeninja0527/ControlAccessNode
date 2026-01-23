const { Router } = require('express')
const { deviceServlet } = require('../controllers/Device.controller.js')
const router = Router()

router.post('/deviceServlet', deviceServlet)

module.exports = { deviceRouter: router }