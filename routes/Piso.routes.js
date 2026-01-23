const { Router } = require('express');
const { getData, postData, patchData, deleteData, pisoSelect } = require('../controllers/Piso.controller.js');

const router = Router();

router.get('/piso', getData);

router.post('/piso', postData);

router.patch('/piso/:idPiso', patchData);

router.delete('/piso/:idPiso', deleteData);

router.get('/piso/select', pisoSelect);

module.exports = {
  pisoRouter: router
}