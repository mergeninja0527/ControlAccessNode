const { Router } = require('express')
const { timeServlet } = require('../controllers/Time.controller.js')
const router = Router()

router.post('/timeServlet', timeServlet)

module.exports = { timeRouter: router }