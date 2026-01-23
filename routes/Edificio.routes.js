const { Router } = require('express');
const { getData, postData, patchData, deleteData, edificioSelect } = require('../controllers/Edificio.controller.js');

const router = Router();

router.get('/edificio', getData);

router.post('/edificio', postData);

router.patch('/edificio/:idEdificio', patchData);

router.delete('/edificio/:idEdificio', deleteData);

router.get('/edificio/select', edificioSelect);

module.exports = {
  edificioRouter: router
}