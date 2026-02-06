const { Router } = require('express');
const { openDoor } = require('../controllers/Door.controller.js');

const router = Router();

router.post('/open', openDoor);

module.exports = { doorRouter: router };
