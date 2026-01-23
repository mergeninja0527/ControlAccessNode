const { Router } = require('express');
const { getData, postData, deleteData } = require('../controllers/Ubicacion.controller.js');

const router = Router();

router.get('/ubicacion', getData);

router.post('/ubicacion', postData);

router.delete('/ubicacion/:idPiso', deleteData);

module.exports = {
  ubicacionRouter: router
}