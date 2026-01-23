const { Router } = require('express')
const { authorityServlet } = require('../controllers/Authority.controller.js')
const router = Router()

router.post('/authorityServlet', authorityServlet)

module.exports = { authorityRouter: router }