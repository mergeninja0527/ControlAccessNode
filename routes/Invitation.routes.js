const { Router } = require('express');
const {
  createInvitation,
  listInvitations,
  getInvitation,
  cancelInvitation,
  deleteInvitation,
  validateQR,
  getInvitationEvents,
  linkDeviceToInvitationRoom
} = require('../controllers/Invitation.controller');

const router = Router();

// Invitation CRUD
router.post('/', createInvitation);           // POST /invitations
router.post('/link-device', linkDeviceToInvitationRoom); // POST /invitations/link-device (body: idAcceso, sn, puerta)
router.get('/', listInvitations);             // GET /invitations?userId=xxx
router.get('/:id', getInvitation);            // GET /invitations/:id
router.post('/:id/cancel', cancelInvitation); // POST /invitations/:id/cancel
router.delete('/:id', deleteInvitation);     // DELETE /invitations/:id (remove from history)
router.get('/:id/events', getInvitationEvents); // GET /invitations/:id/events

module.exports = { invitationRouter: router };
