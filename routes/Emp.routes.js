const { Router } = require('express')
const { addEmp, getEmp, deleteEmp, post } = require('../controllers/Emp.controller.js')
const router = Router()

router.get('/emp', getEmp)

router.post('/emp', addEmp)

router.post('/empServlet', post)

router.delete('/emp', deleteEmp)

module.exports = { empRouter: router }