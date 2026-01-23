const { Router } = require('express');
const { validateQR } = require('../controllers/Invitation.controller');

const router = Router();

// QR validation endpoint for equipment
router.post('/validate-qr', validateQR);  // POST /access/validate-qr

module.exports = { accessRouter: router };
