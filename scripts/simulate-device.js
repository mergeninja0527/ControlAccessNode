#!/usr/bin/env node
/**
 * Simulate ZKTeco 260pro device without hardware
 * Run: node scripts/simulate-device.js [BASE_URL] [CARDNO] [SN]
 *
 * Prerequisites:
 * 1. Backend running (npm start)
 * 2. PRY_Ubicacion has device SN linked to a room
 * 3. Valid QR code: get one from the app (QR screen or create invitation)
 */

const BASE_URL = process.argv[2] || 'http://localhost:3000';
const CARDNO = process.argv[3] || '';  // QR code content (10-digit from app)
const SN = process.argv[4] || 'MWA5244600020';

async function run() {
  console.log('=== ZKTeco Device Simulator ===');
  console.log('Base URL:', BASE_URL);
  console.log('Device SN:', SN);
  console.log('');

  // Step 1: Device connect (optional, registers device)
  console.log('1. Sending isConnect...');
  const connectRes = await fetch(`${BASE_URL}/iclock/cdata?SN=${SN}`);
  const connectText = await connectRes.text();
  console.log('   Response:', connectText.substring(0, 80) + (connectText.length > 80 ? '...' : ''));
  console.log('');

  // Step 2: Simulate QR scan (rtlog) - REQUIRES valid CARDNO
  if (!CARDNO) {
    console.log('2. QR Scan simulation: SKIPPED (no CARDNO provided)');
    console.log('');
    console.log('   To test QR validation, run:');
    console.log(`   node scripts/simulate-device.js ${BASE_URL} <YOUR_QR_CODE> ${SN}`);
    console.log('');
    console.log('   Get a valid QR code from:');
    console.log('   - App QR screen (obtainQR) -> use the 10-digit code in the QR');
    console.log('   - App Invitar -> create invitation -> QR contains the code');
    return;
  }

  console.log('2. Simulating QR scan (cardno=' + CARDNO + ')...');
  const timeStr = new Date().toISOString().slice(0, 19).replace('T', ' ');
  const rtlogBody = `cardno=${CARDNO}&eventaddr=1&inoutstatus=0&time=${encodeURIComponent(timeStr)}&sn=${SN}`;

  const scanRes = await fetch(`${BASE_URL}/iclock/cdata?SN=${SN}&table=rtlog`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: rtlogBody,
  });
  const scanText = await scanRes.text();
  console.log('   Response:', scanText);
  console.log('');

  // Step 3: Poll for open-door command (what device would do next)
  console.log('3. Polling getrequest (open-door command)...');
  const cmdRes = await fetch(`${BASE_URL}/iclock/getrequest?SN=${SN}`);
  const cmdText = await cmdRes.text();
  console.log('   Response:', cmdText);
  if (cmdText && cmdText !== 'OK') {
    console.log('   Command received:', cmdText);
    console.log('   (Device would open the door)');
  } else {
    console.log('   No command (OK) - access may have been denied or already consumed');
  }
}

run().catch(err => {
  console.error('Error:', err.message);
  process.exit(1);
});
