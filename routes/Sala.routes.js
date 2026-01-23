const { Router } = require('express');
const { getData, postData, patchData, deleteData, salaSelect, salaFullSelect } = require('../controllers/Sala.controller.js');

const router = Router();

router.get('/sala', getData);

router.post('/sala', postData);

router.patch('/sala/:idSala', patchData);

router.delete('/sala/:idSala', deleteData);

router.get('/sala/select', salaSelect);

router.get('/sala/full/select', salaFullSelect);

module.exports = {
  salaRouter: router
}