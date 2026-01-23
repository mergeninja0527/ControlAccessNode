const { Router } = require('express');
const { getDevice, devicesSelect, devicesDoorsSelect } = require('../controllers/Dispositivo.controller.js');

const router = Router();

router.get('/dispositivos', getDevice);

router.get('/dispositivos/select', devicesSelect);

router.get('/dispositivos/doors/select/:searchSN', devicesDoorsSelect);

module.exports = {
  dispositivoRouter: router
}