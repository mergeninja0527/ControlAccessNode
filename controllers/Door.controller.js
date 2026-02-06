const { Cmd } = require('../utils/Cmd.js');

/**
 * Queue an open-door command for a device. The device will receive it on its next GET /iclock/getrequest poll.
 * POST /door/open
 * Body: { sn: "MWA5244600020", puerta: "1" }
 */
const openDoor = (req, res) => {
  try {
    const sn = req.body?.sn ?? req.query?.sn ?? '';
    const puerta = req.body?.puerta ?? req.query?.puerta ?? '1';
    if (!sn || String(sn).trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'sn is required (device serial number, e.g. MWA5244600020)'
      });
    }
    const deviceSn = String(sn).trim();
    const door = String(puerta).trim() || '1';
    const cmd = Cmd.openDoor(door);
    Cmd.addDevCmd(deviceSn, cmd);
    console.log('[Door] Queued open door for SN=' + deviceSn + ', puerta=' + door);
    return res.status(200).json({
      success: true,
      message: 'Open-door command queued. Device will receive it on next getrequest.',
      data: { sn: deviceSn, puerta: door }
    });
  } catch (error) {
    console.error('[Door] Error:', error);
    return res.status(500).json({
      success: false,
      message: error.message || 'Error queuing door command'
    });
  }
};

module.exports = {
  openDoor
};
