# ZKTeco 260pro / inBio-260 Pro – Backend Integration Guide

## Overview

The backend already supports ZKTeco devices via the **ZKTeco PUSH protocol** (iClock). The 260pro sends scan events to the server, which validates them and returns an open-door command.

**Device info (from client):**
- Model: 260pro (inBio-260 Pro)
- Serial numbers: MWA5244600020, AJYX233160037

---

## 1. Configure the Device

On the 260pro (via its web interface or ZKBioSecurity):

1. **Communication protocol:** HTTP
2. **Server URL:** `http://YOUR_BACKEND_IP:3000/iclock/cdata`  
   - Replace with your backend host (e.g. `https://your-domain.com` if using HTTPS)
3. **Poll interval:** 3–5 seconds (typical)
4. **Realtime:** Enabled

---

## 2. Register the Device in the Database

The backend maps device serial number (SN) to rooms via `PRY_Ubicacion`.

### Option A: Via API (if available)

```http
POST /ubicacion
Content-Type: application/json

{
  "idSala": 1,
  "sn": "MWA5244600020",
  "puerta": "1"
}
```

### Option B: Via SQL

```sql
INSERT INTO PRY_Ubicacion (IDSala, SN, Puerta) 
VALUES (1, 'MWA5244600020', '1');
```

- **IDSala:** Room/unit ID from `PRY_Sala` (e.g. from seed-data)
- **SN:** Device serial number (MWA5244600020 or AJYX233160037)
- **Puerta:** Door number (1 or 2 for the 260pro)

**To get the correct SN:** After configuring the device, check server logs when it connects. The SN appears in the request to `/iclock/cdata`.

---

## 3. Network / Firewall

- The 260pro must reach your backend on the port (e.g. 3000).
- Allow inbound traffic from the device LAN.
- If the device uses HTTPS, configure a valid certificate on the server.

---

## 4. Supported QR Types

| Type | Source | Validated via |
|------|--------|---------------|
| Personal QR | App (QR screen) | PRY_Acceso |
| Invitation QR | App (Invitar) | PRY_Invitacion |

Both work on the 260pro when the backend receives the scan via `/iclock/cdata`.

---

## 5. Validation Flow

1. User scans QR at the 260pro.
2. Device sends event to `POST /iclock/cdata` with `cardno` (QR content), `SN`, etc.
3. Backend checks PRY_Acceso (personal QR) then PRY_Invitacion (invitation QR).
4. If valid and within time window, backend queues open-door command.
5. Device polls `GET /iclock/getrequest`, receives command, and opens the door.

---

## 6. Simulate Without Device

Run the device simulator script (no hardware needed):

```bash
cd ControlAccessNode

# 1. Connect (registers device)
node scripts/simulate-device.js http://localhost:3000

# 2. Simulate QR scan – use a valid 10‑digit code from app/DB
node scripts/simulate-device.js http://localhost:3000 1234567890 MWA5244600020
```

**Get a valid `cardno` (QR content):**
- From DB: `SELECT IDAcceso FROM PRY_Acceso WHERE Activo=1` or `SELECT IDAcceso FROM PRY_Invitacion WHERE Status='ACTIVE'`
- From app: create an invitation or open the QR screen, then inspect the QR value (or check the API response)

**curl equivalent (QR scan):**
```bash
curl -X POST "http://localhost:3000/iclock/cdata?SN=MWA5244600020&table=rtlog" \
  -H "Content-Type: text/plain" \
  -d "cardno=1234567890,eventaddr=1,inoutstatus=0,time=2025-01-31 12:00:00,sn=MWA5244600020"
```

---

## 7. Troubleshooting

| Symptom | Check |
|--------|--------|
| Device not connecting | Server URL, port, firewall, network |
| Access denied (event 29) | PRY_Ubicacion record (SN + IDSala + Puerta) |
| Wrong door opens | Puerta value and IDSala mapping |
| Invitation QR rejected | Invitation validity (dates, usage limit) |

**Logs:** Backend logs each scan in the format `(event) {...}`. Use these to debug SN and validation.

---

**Note:** Ensure `PRY_Ubicacion` has a row linking the device SN to the correct room (IDSala) before testing.
