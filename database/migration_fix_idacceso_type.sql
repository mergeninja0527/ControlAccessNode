-- =====================================================
-- Migration: Fix IDAcceso Type Mismatch
-- Issue: IDAcceso is bigint but code generates/uses VARCHAR strings
-- Fix: Change IDAcceso to VARCHAR(50) to match code expectations
-- =====================================================

USE zkteco;

-- =====================================================
-- 1. Change tbl_acceso.IDAcceso from bigint to VARCHAR(50)
-- =====================================================

-- Check current column type first (for reference)
-- SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
-- WHERE TABLE_SCHEMA = 'zkteco' AND TABLE_NAME = 'tbl_acceso' AND COLUMN_NAME = 'IDAcceso';

-- Drop foreign key constraints that reference IDAcceso (if any)
-- Note: Check your actual foreign key names
-- ALTER TABLE PRY_AccessEvent DROP FOREIGN KEY fk_accessevent_acceso;
-- ALTER TABLE PRY_Invitacion DROP FOREIGN KEY fk_invitacion_acceso;

-- Change column type to VARCHAR(50)
ALTER TABLE tbl_acceso 
MODIFY COLUMN IDAcceso VARCHAR(50) NOT NULL;

-- Re-add foreign keys if they were dropped (adjust names as needed)
-- ALTER TABLE PRY_AccessEvent 
-- ADD CONSTRAINT fk_accessevent_acceso FOREIGN KEY (IDAcceso) REFERENCES tbl_acceso(IDAcceso);
-- ALTER TABLE PRY_Invitacion 
-- ADD CONSTRAINT fk_invitacion_acceso FOREIGN KEY (IDAcceso) REFERENCES tbl_acceso(IDAcceso);

-- =====================================================
-- 2. Update stored procedures that use IDAcceso
-- =====================================================

DELIMITER //

-- Update spPRY_IDAcceso_Listar (should already return VARCHAR)
DROP PROCEDURE IF EXISTS spPRY_IDAcceso_Listar //
CREATE PROCEDURE spPRY_IDAcceso_Listar()
BEGIN
    SELECT CAST(IDAcceso AS CHAR(50)) AS IDAcceso FROM tbl_acceso WHERE Activo = 1;
END //

-- Update spPRY_Acceso_ObtenerPorAcceso
DROP PROCEDURE IF EXISTS spPRY_Acceso_ObtenerPorAcceso //
CREATE PROCEDURE spPRY_Acceso_ObtenerPorAcceso(IN p_IDAcceso VARCHAR(50))
BEGIN
    SELECT 
        a.IDAcceso, 
        a.IDUsuario, 
        a.Payload, 
        u.NombreUsuario
    FROM tbl_acceso a
    LEFT JOIN PRY_Usuarios u ON a.IDUsuario = u.IDUsuario
    WHERE a.IDAcceso = p_IDAcceso AND a.Activo = 1;
END //

DELIMITER ;

-- =====================================================
-- 3. Verify the change
-- =====================================================

-- Check column type after migration
SELECT 
    COLUMN_NAME, 
    COLUMN_TYPE, 
    IS_NULLABLE, 
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'zkteco' 
  AND TABLE_NAME = 'tbl_acceso' 
  AND COLUMN_NAME = 'IDAcceso';

-- =====================================================
-- Notes:
-- 1. This migration changes IDAcceso from bigint to VARCHAR(50)
-- 2. Existing numeric values will be converted to strings automatically
-- 3. All future inserts should use VARCHAR strings (which the code already does)
-- 4. QR codes will now match database values exactly
-- =====================================================
