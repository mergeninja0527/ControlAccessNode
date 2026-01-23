const { Router } = require('express')
const { cmdServlet } = require('../controllers/Cmd.controller.js')
const router = Router()

router.post('/cmdServlet', cmdServlet)

module.exports = { cmdRouter: router }