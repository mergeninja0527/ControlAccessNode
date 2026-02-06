-- =====================================================
-- Register ZKTeco 260pro device for access control
-- Device: inBio-260 Pro (or 260pro)
-- Serial numbers from client: MWA5244600020, AJYX233160037
--
-- Run this after: buildings, floors, rooms (PRY_Sala) exist
-- Replace <IDSala> with the actual room/unit ID from PRY_Sala
-- Replace <SN> with the device serial (see server logs when device connects)
-- Replace <Puerta> with door number (1 or 2 for 2-door controller)
-- =====================================================

USE zkteco;

-- Example: Link device MWA5244600020 to room 1, door 1
-- INSERT INTO PRY_Ubicacion (IDSala, SN, Puerta) VALUES (1, 'MWA5244600020', '1');

-- Example: Link device AJYX233160037 to room 1, door 2 (if second reader)
-- INSERT INTO PRY_Ubicacion (IDSala, SN, Puerta) VALUES (1, 'AJYX233160037', '2');

-- To find your IDSala values: SELECT IDSala, Sala, IDPiso FROM PRY_Sala WHERE Activo = 1;
