-- =====================================================
-- Migration V3: Simplify to 2 roles (Administrador, Residente)
-- Run this to migrate existing database from 4 roles to 2
-- =====================================================

USE zkteco;

-- 1. Migrate existing users: Supervisor (2), Residente (3), Personal (4) -> Residente (2)
UPDATE PRY_Usuarios SET IDRol = 2 WHERE IDRol IN (2, 3, 4) AND Activo = 1;

-- 2. Ensure roles 1 and 2 exist with correct descriptions
INSERT INTO PRY_Rol (IDRol, Descripcion, Restriccion) VALUES 
  (1, 'Administrador', 1),
  (2, 'Residente', 2)
ON DUPLICATE KEY UPDATE Descripcion = VALUES(Descripcion), Restriccion = VALUES(Restriccion);

-- 3. Remove old roles 3 and 4
DELETE FROM PRY_Rol WHERE IDRol IN (3, 4);
