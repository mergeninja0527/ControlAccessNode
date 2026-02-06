-- =====================================================
-- Control de Acceso - Database Schema
-- =====================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS zkteco;
USE zkteco;

-- =====================================================
-- TABLES
-- =====================================================

-- Roles Table
CREATE TABLE IF NOT EXISTS PRY_Rol (
    IDRol INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    Restriccion INT DEFAULT 0,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Users Table (for login authentication)
CREATE TABLE IF NOT EXISTS PRY_Usuarios (
    IDUsuario VARCHAR(50) PRIMARY KEY,
    NombreUsuario VARCHAR(255) NOT NULL,
    Passwd VARCHAR(255) NOT NULL,
    CorreoElectronico VARCHAR(255),
    Telefono VARCHAR(20),
    IDRol INT,
    PassTemp TINYINT(1) DEFAULT 1,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IDRol) REFERENCES PRY_Rol(IDRol)
);

-- Access Control Table
CREATE TABLE IF NOT EXISTS PRY_Acceso (
    IDAcceso VARCHAR(50) PRIMARY KEY,
    IDUsuario VARCHAR(50),
    Payload JSON,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IDUsuario) REFERENCES PRY_Usuarios(IDUsuario)
);

-- Buildings Table
CREATE TABLE IF NOT EXISTS PRY_Edificio (
    IDEdificio INT AUTO_INCREMENT PRIMARY KEY,
    Edificio VARCHAR(255) NOT NULL,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Floors Table
CREATE TABLE IF NOT EXISTS PRY_Piso (
    IDPiso INT AUTO_INCREMENT PRIMARY KEY,
    IDEdificio INT,
    Piso VARCHAR(100) NOT NULL,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IDEdificio) REFERENCES PRY_Edificio(IDEdificio)
);

-- Rooms Table
CREATE TABLE IF NOT EXISTS PRY_Sala (
    IDSala INT AUTO_INCREMENT PRIMARY KEY,
    IDPiso INT,
    Sala VARCHAR(255) NOT NULL,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IDPiso) REFERENCES PRY_Piso(IDPiso)
);

-- Location/Device Table
CREATE TABLE IF NOT EXISTS PRY_Ubicacion (
    IDUbicacion INT AUTO_INCREMENT PRIMARY KEY,
    IDSala INT,
    SN VARCHAR(100),
    Puerta VARCHAR(100),
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IDSala) REFERENCES PRY_Sala(IDSala)
);

-- Employees Table (for ZKTeco devices)
CREATE TABLE IF NOT EXISTS PRY_Emp (
    IDEmp INT AUTO_INCREMENT PRIMARY KEY,
    IDUsuario VARCHAR(50),
    Nombre VARCHAR(255),
    CardNo VARCHAR(100),
    Fingerprint TEXT,
    Photo TEXT,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Fingerprint Table
CREATE TABLE IF NOT EXISTS PRY_Huella (
    IDHuella INT AUTO_INCREMENT PRIMARY KEY,
    IDUsuario VARCHAR(50),
    FingerID INT,
    Fingerprint TEXT,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Visits Table
CREATE TABLE IF NOT EXISTS PRY_Visita (
    IDVisita INT AUTO_INCREMENT PRIMARY KEY,
    IDUsuario VARCHAR(50),
    NombreVisitante VARCHAR(255),
    RutVisitante VARCHAR(50),
    Motivo VARCHAR(500),
    FechaInicio DATETIME,
    FechaFin DATETIME,
    IDSala INT,
    Activo TINYINT(1) DEFAULT 1,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log Table
CREATE TABLE IF NOT EXISTS PRY_Log (
    IDLog INT AUTO_INCREMENT PRIMARY KEY,
    Funcion VARCHAR(255),
    Linea INT,
    Request TEXT,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- INSERT DEFAULT DATA
-- =====================================================

-- Insert default roles (Administrador and Residente only)
INSERT INTO PRY_Rol (IDRol, Descripcion, Restriccion) VALUES 
    (1, 'Administrador', 1),
    (2, 'Residente', 2)
ON DUPLICATE KEY UPDATE Descripcion = VALUES(Descripcion), Restriccion = VALUES(Restriccion);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_usuarios_rol ON PRY_Usuarios(IDRol);
CREATE INDEX idx_acceso_usuario ON PRY_Acceso(IDUsuario);
CREATE INDEX idx_piso_edificio ON PRY_Piso(IDEdificio);
CREATE INDEX idx_sala_piso ON PRY_Sala(IDPiso);
CREATE INDEX idx_ubicacion_sala ON PRY_Ubicacion(IDSala);
CREATE INDEX idx_emp_usuario ON PRY_Emp(IDUsuario);
