const qr = require("qr-image");
const { pool, findOne, findMany } = require("../database/database");
const { sendMail } = require("./mail.controller");
const { getRandomNumericString } = require("../utils/Functions");

/** Get row property with case-insensitive fallback (MySQL may return different casing) */
function rowVal(row, ...keys) {
  if (!row || typeof row !== 'object') return undefined;
  for (const k of keys) {
    if (row[k] !== undefined && row[k] !== null) return row[k];
    const lower = k.toLowerCase();
    const found = Object.keys(row).find((key) => key.toLowerCase() === lower);
    if (found && row[found] !== undefined && row[found] !== null) return row[found];
  }
  return undefined;
}

/**
 * Validate RUT format and non-empty only (invited visitors do not use the app / are not in tbl_usuarios).
 * @param {string} rut - RUT string (e.g. "12.345.678-9")
 * @returns {{ valid: boolean, message?: string }}
 */
function validateRutInvitee(rut) {
  if (rut == null || String(rut).trim() === '') {
    return { valid: false, message: 'El RUT es requerido.' };
  }
  const s = String(rut).trim();
  if (!s.includes('-')) {
    return { valid: false, message: 'El RUT debe incluir un guión (ej: 12345678-9).' };
  }
  const parts = s.split('-');
  if (parts.length !== 2) {
    return { valid: false, message: 'Formato de RUT inválido.' };
  }
  const numbers = parts[0].replace(/\./g, '');
  const verifier = parts[1];
  if (!/^\d{7,8}$/.test(numbers)) {
    return { valid: false, message: 'El RUT debe tener entre 7 y 8 dígitos antes del guión.' };
  }
  if (!/^[\dkK]$/.test(verifier)) {
    return { valid: false, message: 'El dígito verificador debe ser un número o la letra K.' };
  }
  return { valid: true };
}

/**
 * Parse Payload from tbl_acceso. If Payload is varchar(255) and truncated, JSON.parse fails;
 * fallback: detect "isInvitation":true and extract fields so the row still appears in the list.
 */
function parsePayload(payloadRaw) {
  if (payloadRaw == null) return null;
  if (typeof payloadRaw === 'object') return payloadRaw;
  const s = String(payloadRaw).trim();
  if (!s) return null;
  try {
    return JSON.parse(s);
  } catch (_) {
    if (!s.includes('"isInvitation":true') && !s.includes('"isInvitation": true')) return null;
    const get = (key) => {
      const re = new RegExp(`"${key}"\\s*:\\s*"([^"]*)"`);
      const m = s.match(re);
      return m ? m[1] : null;
    };
    // For dates: truncated Payload may cut before closing quote; match value to end of string
    const getDate = (key) => {
      const quoted = new RegExp(`"${key}"\\s*:\\s*"([^"]*)"`);
      const m = s.match(quoted);
      if (m) return m[1];
      const truncated = new RegExp(`"${key}"\\s*:\\s*"([^"]*)$`);
      const m2 = s.match(truncated);
      return m2 ? m2[1] : null;
    };
    const getNum = (key) => {
      const re = new RegExp(`"${key}"\\s*:\\s*(\\d+)`);
      const m = s.match(re);
      return m ? parseInt(m[1], 10) : null;
    };
    return {
      isInvitation: true,
      nombreInvitado: get('nombreInvitado') || '',
      rutInvitado: get('rutInvitado') || '',
      correoInvitado: get('correoInvitado') || null,
      telefonoInvitado: get('telefonoInvitado') || null,
      tipoInvitacion: get('tipoInvitacion') || 'Visitante',
      motivo: get('motivo') || null,
      fechaInicio: getDate('fechaInicio') || get('fechaInicio') || null,
      fechaFin: getDate('fechaFin') || get('fechaFin') || null,
      idSala: getNum('idSala') ?? null,
      sala: get('sala') ?? null,
      status: get('status') || 'ACTIVE',
      usageLimit: getNum('usageLimit') ?? 1,
      usedCount: getNum('usedCount') ?? 0,
      qrCode: null
    };
  }
}

/**
 * Create a new invitation (stored in tbl_acceso with Payload.isInvitation = true)
 * POST /invitations
 * Invited visitor RUT is validated for format and non-empty only; they are not required to exist in tbl_usuarios.
 */
const createInvitation = async (req, res) => {
  console.log('[Invitation] Creating invitation...');
  console.log('[Invitation] Body:', JSON.stringify(req.body));

  try {
    const {
      createdBy,
      nombreInvitado,
      rutInvitado,
      correoInvitado,
      telefonoInvitado,
      tipoInvitacion,
      motivo,
      fechaInicio,
      fechaFin,
      idSala,
      usageLimit: usageLimitBody
    } = req.body;

    const tipo = (tipoInvitacion === 'Delivery' || tipoInvitacion === 'Visitante') ? tipoInvitacion : 'Visitante';
    const usageLimit = tipo === 'Delivery' ? 1 : (usageLimitBody ?? 1);

    // Validate required fields
    if (!createdBy || !nombreInvitado || !fechaInicio || !fechaFin) {
      return res.status(400).json({
        success: false,
        message: 'Campos requeridos: createdBy, nombreInvitado, fechaInicio, fechaFin'
      });
    }

    // RUT: format and non-empty only (invitee does not use the app)
    const rutVal = validateRutInvitee(rutInvitado);
    if (!rutVal.valid) {
      return res.status(400).json({ success: false, message: rutVal.message || 'RUT inválido.' });
    }

    // Unique code: check tbl_acceso only (integrated schema - invitations live in tbl_acceso)
    const existingAcceso = await findMany("call spPRY_IDAcceso_Listar();", []);
    const existingCodes = new Set((existingAcceso || []).map(r => String(rowVal(r, 'IDAcceso'))));
    let codigo;
    do {
      codigo = getRandomNumericString(10);
    } while (existingCodes.has(codigo));

    // Ensure codigo is a string (critical for consistency with QR and database)
    codigo = String(codigo);
    console.log('[Invitation] Generated code:', codigo, '| Type:', typeof codigo);

    // Generate QR code using the exact same code string
    const qrImage = qr.imageSync(codigo, { type: 'png' });
    const qrBase64 = `data:image/png;base64,${qrImage.toString("base64")}`;
    console.log('[Invitation] QR code generated for:', codigo);

    // Normalize RUT for storage (no dots)
    const normalizedRut = (rutInvitado || '').replace(/\./g, '').trim();
    const normalizedCreatedBy = String(createdBy).replace(/\./g, '').trim();

    // Payload for invitation in tbl_acceso. If DB has Payload VARCHAR(255), alter to TEXT to avoid truncation.
    // activo in payload: 1 = active, 0 = soft-deleted (no separate Activo column on tbl_acceso).
    const payload = {
      isInvitation: true,
      activo: 1,
      nombreInvitado,
      rutInvitado: normalizedRut,
      correoInvitado: correoInvitado || null,
      telefonoInvitado: telefonoInvitado || null,
      tipoInvitacion: tipo,
      motivo: motivo || null,
      fechaInicio,
      fechaFin,
      idSala: idSala != null ? idSala : null,
      usageLimit,
      usedCount: 0,
      status: 'ACTIVE',
      qrCode: qrBase64
    };

    // Insert with explicit string conversion to ensure consistency
    // If IDAcceso is bigint, MySQL will convert string to number, but we ensure it's the same value
    const codigoForDB = String(codigo).trim();
    console.log('[Invitation] Inserting into DB - IDAcceso:', codigoForDB, '| Type:', typeof codigoForDB);
    
    await pool.query(
      'INSERT INTO tbl_acceso (IDAcceso, IDUsuario, Payload) VALUES (?, ?, ?)',
      [codigoForDB, normalizedCreatedBy, JSON.stringify(payload)]
    );
    
    // Verify the inserted value matches what we sent
    try {
      const [verifyRows] = await pool.query('SELECT IDAcceso FROM tbl_acceso WHERE IDAcceso = ?', [codigoForDB]);
      const insertedId = verifyRows?.[0]?.IDAcceso;
      const insertedIdStr = insertedId != null ? String(insertedId).trim() : null;
      const match = insertedIdStr === codigoForDB;
      console.log('[Invitation] Verification - Inserted IDAcceso:', insertedIdStr, '| Expected:', codigoForDB, '| Match:', match);
      if (!match) {
        console.error('[Invitation] MISMATCH DETECTED! QR code will contain:', codigoForDB, 'but database has:', insertedIdStr);
      }
    } catch (verifyErr) {
      console.error('[Invitation] Verification query failed:', verifyErr.message);
    }

    // Send email with QR if email provided
    if (correoInvitado) {
      try {
        const mailOptions = {
          from: `"Control De Acceso" <${process.env.EMAIL_USER}>`,
          to: correoInvitado,
          subject: 'Invitación de Acceso',
          html: `
            <h2>Invitación de Acceso</h2>
            <p>Hola <strong>${nombreInvitado}</strong>,</p>
            <p>Has recibido una invitación de acceso.</p>
            <p><strong>Válido desde:</strong> ${fechaInicio}</p>
            <p><strong>Válido hasta:</strong> ${fechaFin}</p>
            ${motivo ? `<p><strong>Motivo:</strong> ${motivo}</p>` : ''}
            <p>Presenta el código QR adjunto en la entrada.</p>
          `,
          attachments: [{
            filename: 'qr-acceso.png',
            content: Buffer.from(qrBase64.replace(/^data:image\/\w+;base64,/, ""), 'base64'),
            encoding: 'base64'
          }]
        };
        await sendMail(mailOptions);
        console.log('[Invitation] Email sent to:', correoInvitado);
      } catch (emailErr) {
        console.error('[Invitation] Email error:', emailErr.message);
      }
    }

    console.log('[Invitation] Created successfully, idAcceso:', codigo, '| QR contains:', codigo);

    // Return the exact same code string to ensure frontend QR matches database
    const responseCode = String(codigo);
    return res.status(201).json({
      success: true,
      message: 'Invitación creada exitosamente',
      data: {
        idInvitacion: responseCode,
        idAcceso: responseCode,  // Ensure this matches what's in QR code
        qrCode: qrBase64,
        fechaInicio,
        fechaFin,
        status: 'ACTIVE'
      }
    });

  } catch (error) {
    console.error('[Invitation] Error creating:', error);
    return res.status(500).json({ 
      success: false, 
      message: error.message || 'Error al crear invitación' 
    });
  }
};

/**
 * List invitations for a user (tbl_acceso: IDUsuario = creator, Payload.isInvitation = true).
 * GET /invitations?userId=xxx
 * Matches IDUsuario normalized (no dots) so both "12.345.678-5" and "12345678-5" in DB match.
 */
const listInvitations = async (req, res) => {
  console.log('[Invitation] Listing invitations...');

  try {
    const { userId } = req.query;

    if (!userId) {
      return res.status(400).json({
        success: false,
        message: 'userId es requerido'
      });
    }

    const normalizedUserId = String(userId).replace(/\./g, '').trim();
    if (!normalizedUserId) {
      return res.status(400).json({
        success: false,
        message: 'userId inválido'
      });
    }

    // tbl_acceso: IDAcceso (bigint), IDUsuario (varchar), Payload (json/text). Match creator by normalized RUT.
    const [rows] = await pool.query(
      `SELECT IDAcceso, IDUsuario, Payload FROM tbl_acceso
       WHERE REPLACE(REPLACE(IFNULL(IDUsuario, ''), '.', ''), ' ', '') = ?
       ORDER BY IDAcceso DESC`,
      [normalizedUserId]
    );

    const rawRows = rows || [];
    const formattedInvitations = rawRows
      .map(row => {
        const payload = parsePayload(row.Payload);
        if (!payload || !payload.isInvitation) return null;
    // Ensure IDAcceso is converted to string consistently (handles both VARCHAR and bigint)
    const idAcceso = row.IDAcceso != null ? String(row.IDAcceso).trim() : null;
    if (!idAcceso) return null;
    console.log('[Invitation] Retrieved IDAcceso from DB:', idAcceso, '| Original type:', typeof row.IDAcceso);
    return {
      id: idAcceso,
      idAcceso,
          nombreInvitado: payload.nombreInvitado || '',
          rutInvitado: payload.rutInvitado || '',
          correoInvitado: payload.correoInvitado || '',
          telefonoInvitado: payload.telefonoInvitado || '',
          tipoInvitacion: payload.tipoInvitacion || 'Visitante',
          motivo: payload.motivo || null,
          fechaInicio: payload.fechaInicio || null,
          fechaFin: payload.fechaFin || null,
          idSala: payload.idSala ?? null,
          sala: payload.sala ?? null,
          status: deriveInvitationStatus(payload),
          usageLimit: payload.usageLimit ?? 1,
          usedCount: payload.usedCount ?? 0,
          qrCode: payload.qrCode ?? null,
          fechaCreacion: null,
          cancelledAt: (payload.status === 'CANCELLED' || payload.activo === 0) ? true : null
        };
      })
      .filter(Boolean);

    console.log('[Invitation] Rows from DB:', rawRows.length, '| after parse:', formattedInvitations.length, 'for user', normalizedUserId);

    return res.status(200).json({
      success: true,
      data: formattedInvitations
    });
  } catch (error) {
    console.error('[Invitation] Error listing:', error);
    return res.status(500).json({
      success: false,
      message: error.message || 'Error al listar invitaciones'
    });
  }
};

function deriveInvitationStatus(payload) {
  if (payload.status === 'CANCELLED') return 'CANCELLED';
  if (payload.activo === 0) return 'CANCELLED';
  const now = new Date();
  const fin = payload.fechaFin ? new Date(payload.fechaFin) : null;
  if (fin && fin < now) return 'EXPIRED';
  const used = payload.usedCount ?? 0;
  const limit = payload.usageLimit ?? 1;
  if (limit > 0 && used >= limit) return 'USED';
  return payload.status || 'ACTIVE';
}

/**
 * Get single invitation by id (IDAcceso)
 * GET /invitations/:id
 */
const getInvitation = async (req, res) => {
  const { id } = req.params;
  console.log('[Invitation] Getting invitation:', id);

  try {
    const row = await findOne('call spPRY_Acceso_ObtenerPorAcceso(?);', [id]);
    if (!row || !row.Payload) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada' });
    }
    const payload = parsePayload(row.Payload);
    if (!payload || !payload.isInvitation) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada' });
    }

    const idAcceso = row.IDAcceso != null ? String(row.IDAcceso) : null;
    return res.status(200).json({
      success: true,
      data: {
        id: idAcceso,
        idAcceso,
        nombreInvitado: payload.nombreInvitado || '',
        rutInvitado: payload.rutInvitado || '',
        correoInvitado: payload.correoInvitado || '',
        telefonoInvitado: payload.telefonoInvitado || '',
        tipoInvitacion: payload.tipoInvitacion || 'Visitante',
        motivo: payload.motivo || null,
        fechaInicio: payload.fechaInicio || null,
        fechaFin: payload.fechaFin || null,
        idSala: payload.idSala ?? null,
        sala: payload.sala ?? null,
        status: deriveInvitationStatus(payload),
        usageLimit: payload.usageLimit ?? 1,
        usedCount: payload.usedCount ?? 0,
        qrCode: payload.qrCode ?? null,
        fechaCreacion: null,
        cancelledAt: (payload.status === 'CANCELLED' || payload.activo === 0) ? true : null
      }
    });
  } catch (error) {
    console.error('[Invitation] Error getting:', error);
    return res.status(500).json({ success: false, message: error.message || 'Error al obtener invitación' });
  }
};

/**
 * Cancel an invitation (soft delete: set activo: 0, status: CANCELLED in Payload)
 * POST /invitations/:id/cancel
 */
const cancelInvitation = async (req, res) => {
  const { id } = req.params;
  console.log('[Invitation] Cancelling invitation:', id);

  try {
    const cancelledBy = (req.body && req.body.cancelledBy) ? String(req.body.cancelledBy).trim() : null;

    const row = await findOne('call spPRY_Acceso_ObtenerPorAcceso(?);', [id]);
    if (!row || !row.Payload) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada' });
    }
    const payload = parsePayload(row.Payload);
    if (!payload || !payload.isInvitation) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada' });
    }
    if (payload.status === 'CANCELLED') {
      return res.status(400).json({ success: false, message: 'La invitación ya está cancelada' });
    }

    // Soft delete: update Payload with activo: 0 and status: CANCELLED (keep row in tbl_acceso)
    // Put activo/status first in object so they survive Payload column truncation (VARCHAR(255))
    const base = { activo: 0, status: 'CANCELLED', cancelledBy: cancelledBy || payload.createdBy || null };
    const updatedPayload = { ...base, ...payload, ...base };
    await pool.query('UPDATE tbl_acceso SET Payload = ? WHERE IDAcceso = ?', [JSON.stringify(updatedPayload), String(id)]);
    console.log('[Invitation] Cancelled successfully');
    return res.status(200).json({ success: true, message: 'Invitación cancelada exitosamente' });
  } catch (error) {
    console.error('[Invitation] Error cancelling:', error);
    return res.status(500).json({ success: false, message: error.message || 'Error al cancelar invitación' });
  }
};

/**
 * Remove an invitation from history (delete from tbl_acceso). Works for any status.
 * DELETE /invitations/:id
 */
const deleteInvitation = async (req, res) => {
  const { id } = req.params;
  console.log('[Invitation] Removing invitation:', id);

  try {
    const row = await findOne('call spPRY_Acceso_ObtenerPorAcceso(?);', [id]);
    if (!row || !row.Payload) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada' });
    }
    const payload = parsePayload(row.Payload);
    if (!payload || !payload.isInvitation) {
      return res.status(404).json({ success: false, message: 'No es una invitación' });
    }

    await pool.query('DELETE FROM tbl_acceso WHERE IDAcceso = ?', [String(id)]);
    console.log('[Invitation] Removed successfully');
    return res.status(200).json({ success: true, message: 'Invitación eliminada' });
  } catch (error) {
    console.error('[Invitation] Error removing:', error);
    return res.status(500).json({ success: false, message: error.message || 'Error al eliminar' });
  }
};

/**
 * Link a device (reader) to the same room as an invitation (tbl_acceso payload.idSala).
 * POST /invitations/link-device
 * Body: { idAcceso: "4489168201", sn: "MWA5244600020", puerta: "1" }
 */
const linkDeviceToInvitationRoom = async (req, res) => {
  console.log('[Invitation] Link device to invitation room:', req.body);

  try {
    const { idAcceso, sn, puerta } = req.body;
    if (!idAcceso || !sn) {
      return res.status(400).json({
        success: false,
        message: 'idAcceso y sn son requeridos (puerta por defecto 1)'
      });
    }
    const code = String(idAcceso).trim();
    const deviceSn = String(sn).trim();
    const door = puerta != null ? parseInt(String(puerta), 10) || 1 : 1;

    const row = await findOne('call spPRY_Acceso_ObtenerPorAcceso(?);', [code]);
    if (!row || !row.Payload) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada para ese código' });
    }
    const payload = parsePayload(row.Payload);
    if (!payload || !payload.isInvitation || (payload.idSala != null && payload.idSala === '')) {
      return res.status(404).json({ success: false, message: 'Invitación no encontrada para ese código' });
    }
    const idSala = payload.idSala != null ? payload.idSala : null;
    if (idSala == null) {
      return res.status(400).json({ success: false, message: 'La invitación no tiene sala asignada' });
    }

    await pool.query('call spPRY_Ubicacion_Guardar(?,?,?);', [idSala, deviceSn, door]);

    console.log('[Invitation] Device SN=' + deviceSn + ' puerta=' + door + ' linked to IDSala=' + idSala);
    return res.status(200).json({
      success: true,
      message: 'Dispositivo enlazado a la sala de la invitación.',
      data: { idAcceso: code, idSala, sn: deviceSn, puerta: door }
    });
  } catch (error) {
    console.error('[Invitation] Error linking device:', error);
    return res.status(500).json({
      success: false,
      message: error.message || 'Error al enlazar dispositivo'
    });
  }
};

/**
 * Check if door/device allows access at current time (door schedule).
 * Enforce: only allow access when within door's allowed time window.
 * @returns {Promise<boolean>} true if access is allowed by schedule (or no schedule configured)
 */
const checkDoorSchedule = async (deviceId, puerta) => {
  if (!deviceId && !puerta) return true;
  try {
    // TODO: when PRY_Ubicacion or a schedule table has StartTime/EndTime per door, query and enforce:
    // const now = new Date(); return now >= doorStart && now <= doorEnd;
    const location = deviceId && puerta
      ? await findOne('call spPRY_Ubicacion_ObtenerPorSNPuerta(?,?);', [String(deviceId), String(puerta)])
      : null;
    if (!location) return true;
    // No schedule columns on PRY_Ubicacion yet; allow. Future: check location.HoraInicio, location.HoraFin
    return true;
  } catch (e) {
    console.warn('[Access] checkDoorSchedule error:', e.message);
    return true;
  }
};

/**
 * Validate QR code for access (single tbl_acceso lookup; invitation vs personal from Payload)
 * POST /access/validate-qr
 */
const validateQR = async (req, res) => {
  console.log('[Access] Validating QR...');
  console.log('[Access] Body:', JSON.stringify(req.body));

  try {
    const { qrCode, deviceId, deviceName, puerta } = req.body;

    if (!qrCode) {
      return res.status(400).json({ allowed: false, reason: 'QR code is required' });
    }

    let result = 'DENIED';
    let reason = 'INVALID';
    let allowed = false;
    let userName = null;
    let validUntil = null;
    let qrType = null;

    const accessRow = await findOne('call spPRY_Acceso_ObtenerPorAcceso(?);', [qrCode]);
    if (!accessRow || !accessRow.Payload) {
      reason = 'INVALID_CODE';
      console.log('[Access] QR code not found in tbl_acceso');
      return sendValidateQRResponse(res, result, reason, allowed, qrType, userName, validUntil);
    }

    const payload = parsePayload(accessRow.Payload);
    if (!payload) {
      reason = 'INVALID_PAYLOAD';
      return sendValidateQRResponse(res, result, reason, allowed, qrType, userName, validUntil);
    }

    const now = new Date();

    if (payload.isInvitation) {
      qrType = 'invitation';
      if (payload.status === 'CANCELLED') {
        reason = 'INVITATION_CANCELLED';
      } else if (payload.status === 'USED' || ((payload.usedCount || 0) >= (payload.usageLimit || 1))) {
        reason = 'USAGE_LIMIT_REACHED';
      } else if (payload.fechaFin && now > new Date(payload.fechaFin)) {
        reason = 'INVITATION_EXPIRED';
      } else if (payload.fechaInicio && now < new Date(payload.fechaInicio)) {
        reason = 'NOT_YET_VALID';
      } else {
        const doorAllowed = await checkDoorSchedule(deviceId, puerta);
        if (!doorAllowed) {
          reason = 'DOOR_SCHEDULE_DENIED';
        } else {
          result = 'ALLOWED';
          reason = 'ACCESS_GRANTED';
          allowed = true;
          userName = payload.nombreInvitado;
          validUntil = payload.fechaFin;
          const usedCount = (payload.usedCount || 0) + 1;
          const newStatus = usedCount >= (payload.usageLimit || 1) ? 'USED' : (payload.status || 'ACTIVE');
          const newPayload = { ...payload, usedCount, status: newStatus };
          await pool.query('UPDATE tbl_acceso SET Payload = ? WHERE IDAcceso = ?', [JSON.stringify(newPayload), qrCode]);
          console.log('[Access] Invitation QR validated successfully');
        }
      }
    } else {
      qrType = 'personal';
      const tokenStart = payload.fechaInicio ? new Date(payload.fechaInicio) : null;
      const tokenEnd = payload.fechaFin ? new Date(payload.fechaFin) : null;
      if (!tokenEnd || now > tokenEnd) {
        reason = 'EXPIRED';
      } else if (tokenStart && now < tokenStart) {
        reason = 'NOT_YET_VALID';
      } else {
        const roleId = payload.roleId === 1 || payload.roleId === '1' || payload.roleId === 'ADM' || payload.roleId === 'SAD' ? 1 : 2;
        if (roleId === 2 && payload.leaseStart && payload.leaseEnd) {
          const leaseStart = new Date(payload.leaseStart);
          const leaseEnd = new Date(payload.leaseEnd);
          if (now < leaseStart || now > leaseEnd) {
            reason = 'OUTSIDE_ACCESS_PERIOD';
          } else {
            const doorAllowed = await checkDoorSchedule(deviceId, puerta);
            if (!doorAllowed) reason = 'DOOR_SCHEDULE_DENIED';
            else {
              result = 'ALLOWED';
              reason = 'ACCESS_GRANTED';
              allowed = true;
              userName = accessRow.NombreUsuario || accessRow.IDUsuario;
              validUntil = payload.fechaFin;
            }
          }
        } else {
          const doorAllowed = await checkDoorSchedule(deviceId, puerta);
          if (!doorAllowed) reason = 'DOOR_SCHEDULE_DENIED';
          else {
            result = 'ALLOWED';
            reason = 'ACCESS_GRANTED';
            allowed = true;
            userName = accessRow.NombreUsuario || accessRow.IDUsuario;
            validUntil = payload.fechaFin;
          }
        }
      }
    }

    try {
      await pool.query('call spPRY_AccessEvent_Registrar(?,?,?,?,?,?,?,?);', [
        qrCode, null, deviceId || null, deviceName || null, puerta || null, result, reason, JSON.stringify(req.body)
      ]).catch(() => {});
    } catch (_) {
      // Optional: new DB (zkteco_new) may not have PRY_AccessEvent
    }

    console.log('[Access] Result:', { allowed, reason, qrType, userName });
    return sendValidateQRResponse(res, result, reason, allowed, qrType, userName, validUntil);
  } catch (error) {
    console.error('[Access] Error validating:', error);
    return res.status(500).json({ allowed: false, reason: 'SERVER_ERROR' });
  }
};

function sendValidateQRResponse(res, result, reason, allowed, qrType, userName, validUntil) {
  return res.status(200).json({
    allowed,
    reason,
    action: allowed ? 'OPEN_DOOR' : null,
    qrType: qrType || 'unknown',
    user: allowed ? { nombre: userName, validUntil } : null
  });
}

/**
 * Get access events for an invitation (id = IDAcceso = code scanned at device).
 * Uses device_access_logs (integrated schema): card_no / card_decimal match the invitation code.
 * GET /invitations/:id/events
 */
const getInvitationEvents = async (req, res) => {
  const { id } = req.params;
  console.log('[Invitation] Getting events for:', id);

  try {
    let rows = [];
    const codeStr = String(id);
    const codeDecimal = /^\d+$/.test(codeStr) ? parseInt(codeStr, 10) : null;
    try {
      const [r] = await pool.query(
        `SELECT id, event_time AS ScannedAt, access_result AS Result, denial_reason AS Reason, sn AS DeviceSN, door_no AS Puerta
         FROM device_access_logs
         WHERE card_no = ? OR card_decimal = ?
         ORDER BY event_time DESC LIMIT 100`,
        [codeStr, codeDecimal != null ? codeDecimal : codeStr]
      );
      rows = r || [];
    } catch (_) {
      // device_access_logs may not exist in all environments
    }

    return res.status(200).json({
      success: true,
      data: (rows || []).map(e => ({
        id: e.id,
        scannedAt: e.ScannedAt,
        result: e.Result,
        reason: e.Reason,
        deviceSN: e.DeviceSN,
        deviceName: null,
        puerta: e.Puerta
      }))
    });
  } catch (error) {
    console.error('[Invitation] Error getting events:', error);
    return res.status(500).json({ success: false, message: error.message || 'Error al obtener eventos' });
  }
};

module.exports = {
  createInvitation,
  listInvitations,
  getInvitation,
  cancelInvitation,
  deleteInvitation,
  validateQR,
  getInvitationEvents,
  linkDeviceToInvitationRoom
};
