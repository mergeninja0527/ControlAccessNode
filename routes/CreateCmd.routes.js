const { Router } = require('express')
const { createCmd } = require('../controllers/CreateCmd.controller.js')
const router = Router()

router.post('/createCmd', createCmd)

module.exports = { createCmdRouter: router }