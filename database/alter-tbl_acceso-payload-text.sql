-- tbl_acceso.Payload is VARCHAR(255) in the base schema; invitation payloads
-- (with qrCode base64) exceed 255 chars and get truncated. This breaks JSON
-- and hides invitations from the list. Run this to fix:
--
--   mysql -u user -p your_database < database/alter-tbl_acceso-payload-text.sql
--
ALTER TABLE tbl_acceso MODIFY COLUMN Payload TEXT;
