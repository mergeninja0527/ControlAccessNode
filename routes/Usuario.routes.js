const { Router } = require('express')
const { getUsers, getRolesSelect, deleteData, postData, postEnlace, getEnlace } = require('../controllers/Usuario.controller.js')
const router = Router()

router.get('/usuario', getUsers)

router.post('/usuario', postData)

router.get('/usuario/enlace/:idUsuario', getEnlace)

router.post('/usuario/enlace', postEnlace)

router.delete('/usuario/:idUsuario', deleteData)

router.get('/rol/select/:idUsuario', getRolesSelect)


module.exports = { usuarioRouter: router }