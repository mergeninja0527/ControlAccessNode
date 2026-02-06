#!/usr/bin/env node
/**
 * Register a ZKTeco device in PRY_Ubicacion (link device to a room).
 * Run: node scripts/register-device.js [IDSala] [SN] [Puerta]
 * Example: node scripts/register-device.js 1 MWA5244600020 1
 */
require('dotenv').config();
const mysql = require('mysql2/promise');

const idSala = process.argv[2] || 1;
const sn = process.argv[3] || 'MWA5244600020';
const puerta = process.argv[4] || '1';

async function registerDevice() {
  let conn;
  try {
    conn = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: (() => { const r = process.env.DB_PASS; if (!r) return ''; try { return Buffer.from(r.trim(), 'base64').toString('utf8'); } catch { return r; } })(),
      database: process.env.DB_DABS || 'zkteco',
    });

    const [result] = await conn.query(
      'INSERT INTO PRY_Ubicacion (IDSala, SN, Puerta) VALUES (?, ?, ?)',
      [idSala, sn, puerta]
    );

    console.log('Device registered successfully:');
    console.log('  IDSala:', idSala);
    console.log('  SN:', sn);
    console.log('  Puerta:', puerta);
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      console.log('Device already registered (same SN + room). To change, delete and re-add.');
    } else {
      console.error('Error:', error.message);
    }
    process.exit(1);
  } finally {
    if (conn) await conn.end();
  }
}

registerDevice();
