# Device connection guide – ZKTeco to this server

This guide explains how to connect a ZKTeco device (e.g. 260pro / inBio-260 Pro) to the ControlAccessNode server so that QR scans are validated and the door opens when access is granted.

---

## 1. What you need

| Item | Description |
|------|--------------|
| **Server** | ControlAccessNode running (e.g. `npm start`), reachable from the device network |
| **Device** | ZKTeco 260pro or compatible (supports iClock/PUSH over HTTP) |
| **Network** | Device and server can reach each other (same LAN or port forwarded / VPN) |
| **Database** | MySQL with project schema; device will be registered in `PRY_Ubicacion` |

---

## 2. Server-side preparation

### 2.1 Start the server

```bash
cd ControlAccessNode
npm install
npm start
```

Default port is **3000**. The server must be reachable at a URL the device can use (see next section).

### 2.2 Know your server URL

The device will call this server over HTTP (or HTTPS if you configure it).

- **Same LAN:** use the machine’s IP, e.g. `http://192.168.1.100:3000`
- **Different network:** use a public hostname/IP and ensure port 3000 (or your port) is open to the device
- **HTTPS:** use `https://your-domain.com` and ensure the device trusts the certificate

Base URL examples:

- `http://192.168.1.100:3000`
- `https://your-server.com`

You will use this **base URL** when configuring the device (step 3).

---

## 3. Device configuration (on the 260pro)

Configure the device so it talks to your server. Use either:

- The device **web interface** (browser: `http://<device-IP>`), or  
- **ZKBioSecurity** (or the manufacturer’s desktop tool) if you use it.

### 3.1 Communication settings

| Setting | Value / recommendation |
|--------|--------------------------|
| **Protocol** | HTTP (or HTTPS if your server uses it) |
| **Server URL** | `http://YOUR_SERVER_IP_OR_HOST:3000/iclock/cdata` |
| **Poll interval** | 3–5 seconds (typical) |
| **Realtime** | Enabled (so events are sent promptly) |

Replace `YOUR_SERVER_IP_OR_HOST` and the port if different. Examples:

- `http://192.168.1.100:3000/iclock/cdata`
- `https://your-server.com/iclock/cdata`

The device uses:

- **POST/GET** to `/iclock/cdata` for connection check and for sending events (e.g. QR scan as `table=rtlog`).
- **GET** to `/iclock/getrequest?SN=<serial>` to fetch commands (e.g. open door). The backend serves this on the same host/port; usually you only configure the cdata URL and the device derives getrequest from it or uses the same base URL.

### 3.2 Save and let the device connect

After saving, the device will:

1. Call the server (e.g. `GET /iclock/cdata?SN=...` or similar).  
2. Appear in **server logs** with its **SN** (serial number).  
3. Use the same base URL to send scan events and to poll for commands.

**Important:** Note the device **serial number (SN)** from the server logs on first connection (e.g. `MWA5244600020`). You need it for the next step.

---

## 4. Register the device in the database

The server only grants access if the device is linked to a **room** (`PRY_Ubicacion`). That link is by **SN** and **door number (puerta)**.

### 4.1 Get the device SN

- Check **server logs** when the device connects (e.g. `[Request] GET /iclock/cdata?SN=MWA5244600020`).  
- Or use the device label / web interface / ZKBioSecurity to see the serial number.

### 4.2 Choose a room (IDSala)

Rooms come from `PRY_Sala` (e.g. from seed data). Pick the `IDSala` that represents the door/unit this reader controls (e.g. `1`, `2`, …).

### 4.3 Add the link (API or SQL)

**Option A – API (recommended)**

```bash
curl -X POST "http://localhost:3000/ubicacion" \
  -H "Content-Type: application/json" \
  -d '{"idSala": 1, "sn": "MWA5244600020", "puerta": "1"}'
```

- `idSala`: room ID from `PRY_Sala`.  
- `sn`: device serial number (exactly as in logs).  
- `puerta`: door number on the device (usually `"1"` or `"2"`).

**Option B – SQL**

```sql
INSERT INTO PRY_Ubicacion (IDSala, SN, Puerta)
VALUES (1, 'MWA5244600020', '1');
```

Use your actual `IDSala`, `SN`, and `Puerta`.

### 4.4 If you use invitation QRs

Invitation QRs are valid only for a specific room (`IDSala`). The reader must be linked to **that same room**. You can:

- Register the device for that room (step 4.3 with the invitation’s `idSala`), or  
- Use the **link-device** API so this reader is linked to the invitation’s room:

```bash
curl -X POST "http://localhost:3000/invitations/link-device" \
  -H "Content-Type: application/json" \
  -d '{"idAcceso": "4503628435", "sn": "MWA5244600020", "puerta": "1"}'
```

Replace `idAcceso` with the invitation QR code (10 digits) and `sn`/`puerta` with your device.

---

## 5. Flow after setup

1. User scans a **personal QR** (app QR screen) or **invitation QR** (app Invitar) at the device.  
2. Device sends the scan to the server: `POST /iclock/cdata?SN=...&table=rtlog` with `cardno=<QR code>`, etc.  
3. Server validates the code (personal → `PRY_Acceso`, invitation → `PRY_Invitacion`) and checks that the device’s room matches.  
4. If access is allowed, the server queues an **open-door** command for that SN.  
5. Device polls `GET /iclock/getrequest?SN=...`, receives the command, and opens the door.

No extra device setup is needed for “asking for instructions”: the device is designed to poll getrequest; the server only responds with a command when a scan was granted.

---

## 6. Optional: manual open-door command (testing)

You can queue an open-door command for a device without a scan (e.g. for testing):

```bash
curl -X POST "http://localhost:3000/door/open" \
  -H "Content-Type: application/json" \
  -d '{"sn": "MWA5244600020", "puerta": "1"}'
```

The device will receive this on its next getrequest poll.

---

## 7. Testing without hardware (simulator)

From the server machine:

```bash
cd ControlAccessNode

# 1. Only “connect” (optional)
node scripts/simulate-device.js http://localhost:3000

# 2. Simulate a QR scan (use a valid 10-digit code from app or DB)
node scripts/simulate-device.js http://localhost:3000 4503628435 MWA5244600020
```

Use a valid `idAcceso`/QR code and the same SN you registered in `PRY_Ubicacion`. If the invitation’s room matches the device’s room, step 3 in the script output should show a command (not just “OK”).

---

## 8. Troubleshooting

| Symptom | What to check |
|--------|----------------|
| Device never appears in logs | Server URL and port on the device; firewall; device can ping the server. |
| Device connects but scans do nothing | Confirm `PRY_Ubicacion` has a row for this SN and the correct IDSala and Puerta. |
| “No command (OK)” after scan | Server denied access: check **server logs at the time of the scan** (e.g. invitation USED/EXPIRED, or “device not linked to invitation room”). Fix with reset-usage or link-device (see section 4.4). |
| Wrong door opens | Puerta in `PRY_Ubicacion` and in door commands (e.g. `/door/open`) must match the physical door/relay (1 or 2). |
| Invitation “active” but denied | Either usage limit reached (use POST `/invitations/reset-usage` with `idAcceso`) or device not linked to invitation’s room (use POST `/invitations/link-device`). |

**Useful server logs**

- First connection: request to `/iclock/cdata` with `SN=...`.  
- On each scan: rtlog handling and either “[IClock] Invitation … denied …” or open-door command queued.  
- When device polls: “device say: give me instructions” for getrequest; if a command was queued, the response will be the command, not “OK”.

---

## 9. Checklist

- [ ] Server is running and reachable from the device network.  
- [ ] Device is configured with **Server URL** = `http(s)://YOUR_HOST:PORT/iclock/cdata`.  
- [ ] Device has connected at least once (server logs show its **SN**).  
- [ ] `PRY_Ubicacion` has a row for this **SN** and the correct **IDSala** and **Puerta**.  
- [ ] For invitation QRs: invitation’s room = device’s room (same IDSala), or use **link-device** API.  
- [ ] Test with simulator or real QR; check server logs if access is denied.

---

**Summary:** Set the device’s server URL to your backend’s `/iclock/cdata`, register the device in `PRY_Ubicacion` (and optionally use `link-device` for invitations), then scans will be validated and the device will receive open-door commands via getrequest.
