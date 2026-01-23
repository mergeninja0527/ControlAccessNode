const express = require("express")
const { login, password } = require("../controllers/auth.controller.js")

const router = express.Router()

router.post('/login', login)

router.patch('/password', password)

module.exports = {
  authRouter: router
}