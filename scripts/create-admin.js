/**
 * Create or update admin user with password 123456.
 * Uses tbl_usuarios (integrated schema). Passwd is stored as MD5(plain).
 *
 * Usage: node scripts/create-admin.js
 * Optional env: ADMIN_RUT (default 11111111-1), ADMIN_NAME (default admin), ADMIN_PASS (default 123456)
 */
require('dotenv').config();
const { pool } = require('../database/database');
const { hashPasswordMD5 } = require('../utils/Functions');

const ADMIN_RUT = process.env.ADMIN_RUT || '11111111-1';
const ADMIN_NAME = process.env.ADMIN_NAME || 'admin';
const ADMIN_PASS = process.env.ADMIN_PASS || '123456';

async function createAdmin() {
  const passwdHash = hashPasswordMD5(ADMIN_PASS);

  const sql = `
    INSERT INTO tbl_usuarios (IDUsuario, NombreUsuario, CorreoElectronico, Passwd, IDRol, PassTemp, Telefono)
    VALUES (?, ?, ?, ?, 'ADM', 0, NULL)
    ON DUPLICATE KEY UPDATE
      NombreUsuario = VALUES(NombreUsuario),
      Passwd = VALUES(Passwd),
      IDRol = 'ADM',
      PassTemp = 0
  `;

  try {
    await pool.query(sql, [ADMIN_RUT, ADMIN_NAME, null, passwdHash]);
    console.log('Admin user created/updated successfully.');
    console.log('  RUT:     ', ADMIN_RUT);
    console.log('  Name:    ', ADMIN_NAME);
    console.log('  Password: (set to', ADMIN_PASS === '123456' ? '123456' : '***', ')');
    console.log('  Role:    ADM');
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

createAdmin();
