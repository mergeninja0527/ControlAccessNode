const { Router } = require('express')
const { realEvent } = require('../controllers/RealEvent.controller.js')
const router = Router()

router.post('/realEvent', realEvent)

module.exports = { realEventRouter: router }