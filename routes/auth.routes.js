const express = require("express")
const { login } = require("../controllers/auth.controller.js")

const router = express.Router()

router.post('/login', login)

module.exports = {
  authRouter: router
}