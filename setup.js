/**
 * Database Setup Script (single entry point for database build)
 *
 * This script does everything needed to build the database:
 * 1. Creates the database and tables
 * 2. Runs migrations (columns, drop Passwd, etc.)
 * 3. Creates all stored procedures
 * 4. Seeds sample data (buildings, floors, rooms)
 * 5. Creates indexes
 * 6. Creates admin user (default: RUT 11111111-1, fullName admin in tbl_usuarios)
 *
 * Usage: node setup.js [options]
 * Options: --admin-user, --admin-name, --admin-email, --admin-phone, --help
 *
 * You do not need to run migrate.js, fix-roles.js, or seed-data.js separately.
 */

require('dotenv').config();
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

// Configuration
const config = {
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS ? atob(process.env.DB_PASS) : '',
  multipleStatements: true
};

const dbName = process.env.DB_DABS || 'zkteco';

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const options = {
    adminUser: '11111111-1',
    adminEmail: 'admin@example.com',
    adminName: 'admin',
    adminPhone: '+56900000000'
  };

  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--admin-user':
        options.adminUser = args[++i];
        break;
      case '--admin-email':
        options.adminEmail = args[++i];
        break;
      case '--admin-name':
        options.adminName = args[++i];
        break;
      case '--admin-phone':
        options.adminPhone = args[++i];
        break;
      case '--help':
        showHelp();
        process.exit(0);
    }
  }

  return options;
}

function showHelp() {
  console.log(`
Database Setup Script for Control de Acceso

Usage: node setup.js [options]

Options:
  --admin-user <rut>       Admin user RUT/ID (default: 11111111-1)
  --admin-email <email>    Admin email (default: admin@example.com)
  --admin-name <name>      Admin full name for login (default: admin)
  --admin-phone <phone>    Admin phone (default: +56900000000)
  --help                   Show this help message

Examples:
  node setup.js
  node setup.js --admin-user "12345678-9" --admin-name "Admin" --admin-email "admin@company.com"
`);
}

// Read SQL file
function readSqlFile(filename) {
  const filePath = path.join(__dirname, 'database', filename);
  if (!fs.existsSync(filePath)) {
    throw new Error(`SQL file not found: ${filePath}`);
  }
  return fs.readFileSync(filePath, 'utf8');
}

async function main() {
  const options = parseArgs();
  let connection;
  
  console.log('\n========================================');
  console.log('  Control de Acceso - Database Setup');
  console.log('========================================\n');

  try {
    // Connect to MySQL (without database)
    console.log(`Connecting to MySQL at ${config.host}:${config.port}...`);
    connection = await mysql.createConnection(config);
    console.log('Connected successfully!\n');

    // Step 1: Create database
    console.log(`Step 1: Creating database "${dbName}"...`);
    await connection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);
    await connection.query(`USE \`${dbName}\``);
    console.log('Database created/selected.\n');

    // Step 2: Create tables directly (more reliable than parsing SQL file)
    console.log('Step 2: Creating tables...');
    
    // Roles Table (RequiereUnidad = 1 for Residente/Tenant)
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_rol (
        IDRol INT AUTO_INCREMENT PRIMARY KEY,
        Descripcion VARCHAR(100) NOT NULL,
        Restriccion INT DEFAULT 0,
        RequiereUnidad TINYINT(1) DEFAULT 0,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - tbl_rol created');

    // Users Table (login with RUT + full name; no password)
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_usuarios (
        IDUsuario VARCHAR(50) PRIMARY KEY,
        NombreUsuario VARCHAR(255) NOT NULL,
        CorreoElectronico VARCHAR(255),
        Telefono VARCHAR(20),
        IDRol INT,
        IDSala INT NULL,
        FechaInicioValidez DATETIME NULL,
        FechaFinValidez DATETIME NULL,
        PassTemp TINYINT(1) DEFAULT 1,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDRol) REFERENCES tbl_rol(IDRol)
      )
    `);
    console.log('  - tbl_usuarios created');

    // Access Control Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_acceso (
        IDAcceso VARCHAR(50) PRIMARY KEY,
        IDUsuario VARCHAR(50),
        Payload JSON,
        Status ENUM('ACTIVE', 'CANCELLED', 'EXPIRED', 'USED') DEFAULT 'ACTIVE',
        UsageLimit INT DEFAULT 1,
        UsedCount INT DEFAULT 0,
        CancelledAt DATETIME NULL,
        CancelledBy VARCHAR(50) NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDUsuario) REFERENCES tbl_usuarios(IDUsuario)
      )
    `);
    console.log('  - tbl_acceso created');

    // Buildings Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_edificio (
        IDEdificio INT AUTO_INCREMENT PRIMARY KEY,
        Edificio VARCHAR(255) NOT NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - tbl_edificio created');

    // Floors Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_piso (
        IDPiso INT AUTO_INCREMENT PRIMARY KEY,
        IDEdificio INT,
        Piso VARCHAR(100) NOT NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDEdificio) REFERENCES tbl_edificio(IDEdificio)
      )
    `);
    console.log('  - tbl_piso created');

    // Rooms Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_sala (
        IDSala INT AUTO_INCREMENT PRIMARY KEY,
        IDPiso INT,
        Sala VARCHAR(255) NOT NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDPiso) REFERENCES tbl_piso(IDPiso)
      )
    `);
    console.log('  - tbl_sala created');

    // Location/Device Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_ubicacion (
        IDUbicacion INT AUTO_INCREMENT PRIMARY KEY,
        IDSala INT,
        SN VARCHAR(100),
        Puerta VARCHAR(100),
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDSala) REFERENCES tbl_sala(IDSala)
      )
    `);
    console.log('  - tbl_ubicacion created');

    // Employees Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_emp (
        IDEmp INT AUTO_INCREMENT PRIMARY KEY,
        IDUsuario VARCHAR(50),
        Nombre VARCHAR(255),
        CardNo VARCHAR(100),
        Fingerprint TEXT,
        Photo TEXT,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - tbl_emp created');

    // Fingerprint Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_huella (
        IDHuella INT AUTO_INCREMENT PRIMARY KEY,
        IDUsuario VARCHAR(50),
        FingerID INT,
        Fingerprint TEXT,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - tbl_huella created');

    // Visits Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_visita (
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
      )
    `);
    console.log('  - tbl_visita created');

    // Log Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_log (
        IDLog INT AUTO_INCREMENT PRIMARY KEY,
        Funcion VARCHAR(255),
        Linea INT,
        Request TEXT,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - tbl_log created');

    // Invitations Table (TipoInvitacion = 'Visitante' | 'Delivery', not system roles)
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_invitacion (
        IDInvitacion INT AUTO_INCREMENT PRIMARY KEY,
        IDAcceso VARCHAR(50),
        CreadoPor VARCHAR(50) NOT NULL,
        NombreInvitado VARCHAR(255),
        RutInvitado VARCHAR(50),
        CorreoInvitado VARCHAR(255),
        TelefonoInvitado VARCHAR(20),
        TipoInvitacion VARCHAR(50) DEFAULT 'Visitante',
        Motivo VARCHAR(500),
        FechaInicio DATETIME NOT NULL,
        FechaFin DATETIME NOT NULL,
        IDSala INT,
        Status ENUM('ACTIVE', 'CANCELLED', 'EXPIRED', 'USED') DEFAULT 'ACTIVE',
        UsageLimit INT DEFAULT 1,
        UsedCount INT DEFAULT 0,
        CancelledAt DATETIME NULL,
        CancelledBy VARCHAR(50) NULL,
        QRCode TEXT,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (CreadoPor) REFERENCES tbl_usuarios(IDUsuario),
        FOREIGN KEY (IDSala) REFERENCES tbl_sala(IDSala)
      )
    `);
    console.log('  - tbl_invitacion created');

    // Access Events Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS tbl_accessevent (
        IDEvent INT AUTO_INCREMENT PRIMARY KEY,
        IDAcceso VARCHAR(50),
        IDInvitacion INT NULL,
        DeviceSN VARCHAR(100),
        DeviceName VARCHAR(255),
        Puerta VARCHAR(100),
        ScannedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        Result ENUM('ALLOWED', 'DENIED') NOT NULL,
        Reason VARCHAR(100),
        RawData TEXT,
        Activo TINYINT(1) DEFAULT 1
      )
    `);
    console.log('  - tbl_accessevent created');

    // Insert default roles: Administrador and Residente only
    await connection.query(`
      INSERT INTO tbl_rol (IDRol, Descripcion, Restriccion) VALUES 
        (1, 'Administrador', 1),
        (2, 'Residente', 2)
      ON DUPLICATE KEY UPDATE Descripcion = VALUES(Descripcion), Restriccion = VALUES(Restriccion)
    `);
    // Migrate existing users: Supervisor (2), old Residente (3), Personal (4) -> Residente (2)
    await connection.query(`
      UPDATE tbl_usuarios SET IDRol = 2 WHERE IDRol IN (2, 3, 4) AND Activo = 1
    `).catch(() => {});
    await connection.query(`
      DELETE FROM tbl_rol WHERE IDRol IN (3, 4)
    `).catch(() => {});
    console.log('  - Default roles: Administrador (1), Residente (2)');

    // Migrations: add new columns to existing tables (no-op if already present)
    try {
      await connection.query('ALTER TABLE tbl_usuarios ADD COLUMN IDSala INT NULL AFTER IDRol');
      console.log('  - tbl_usuarios: added IDSala');
    } catch (e) {
      if (e.code !== 'ER_DUP_FIELDNAME') throw e;
    }
    try {
      await connection.query('ALTER TABLE tbl_usuarios ADD COLUMN FechaInicioValidez DATETIME NULL AFTER IDSala');
      console.log('  - tbl_usuarios: added FechaInicioValidez');
    } catch (e) {
      if (e.code !== 'ER_DUP_FIELDNAME') throw e;
    }
    try {
      await connection.query('ALTER TABLE tbl_usuarios ADD COLUMN FechaFinValidez DATETIME NULL AFTER FechaInicioValidez');
      console.log('  - tbl_usuarios: added FechaFinValidez');
    } catch (e) {
      if (e.code !== 'ER_DUP_FIELDNAME') throw e;
    }
    try {
      await connection.query('ALTER TABLE tbl_rol ADD COLUMN RequiereUnidad TINYINT(1) DEFAULT 0 AFTER Restriccion');
      console.log('  - tbl_rol: added RequiereUnidad');
    } catch (e) {
      if (e.code !== 'ER_DUP_FIELDNAME') throw e;
    }
    try {
      await connection.query('ALTER TABLE tbl_usuarios ADD CONSTRAINT fk_usuarios_sala FOREIGN KEY (IDSala) REFERENCES tbl_sala(IDSala)');
      console.log('  - tbl_usuarios: added FK to tbl_sala');
    } catch (e) {
      if (e.code !== 'ER_DUP_KEY' && e.code !== 'ER_FK_DUP_NAME') throw e;
    }
    await connection.query("UPDATE tbl_rol SET RequiereUnidad = 1 WHERE IDRol = 3");
    console.log('  - tbl_rol: Residente (3) requires unit');
    try {
      await connection.query('ALTER TABLE tbl_invitacion ADD COLUMN TipoInvitacion VARCHAR(50) DEFAULT \'Visitante\' AFTER TelefonoInvitado');
      console.log('  - tbl_invitacion: added TipoInvitacion');
    } catch (e) {
      if (e.code !== 'ER_DUP_FIELDNAME') throw e;
    }
    // Migration: remove Passwd column (login now uses RUT + full name only)
    try {
      await connection.query('ALTER TABLE tbl_usuarios DROP COLUMN Passwd');
      console.log('  - tbl_usuarios: removed Passwd column');
    } catch (e) {
      // Column already dropped or never existed (e.g. fresh install creates table without Passwd)
      console.log('  - tbl_usuarios: Passwd column already absent (skip)');
    }
    // Migration: tbl_acceso extra columns (for older DBs)
    const accesoCols = [
      { sql: "ADD COLUMN Status ENUM('ACTIVE', 'CANCELLED', 'EXPIRED', 'USED') DEFAULT 'ACTIVE'", name: 'Status' },
      { sql: 'ADD COLUMN UsageLimit INT DEFAULT 1', name: 'UsageLimit' },
      { sql: 'ADD COLUMN UsedCount INT DEFAULT 0', name: 'UsedCount' },
      { sql: 'ADD COLUMN CancelledAt DATETIME NULL', name: 'CancelledAt' },
      { sql: 'ADD COLUMN CancelledBy VARCHAR(50) NULL', name: 'CancelledBy' }
    ];
    for (const col of accesoCols) {
      try {
        await connection.query(`ALTER TABLE tbl_acceso ${col.sql}`);
        console.log(`  - tbl_acceso: added ${col.name}`);
      } catch (e) {
        if (e.code !== 'ER_DUP_FIELDNAME') console.warn(`  - tbl_acceso.${col.name}: ${e.message.substring(0, 40)}`);
      }
    }
    console.log('Tables created/updated successfully.\n');

    // Migration: Fix IDAcceso type mismatch (bigint -> VARCHAR)
    try {
      const { runMigration: runIdAccesoMigration } = require('./scripts/migration_fix_idacceso_type');
      await runIdAccesoMigration();
    } catch (migrationError) {
      console.warn('  - IDAcceso migration warning:', migrationError.message);
    }

    // Step 2b: Seed sample data (buildings, floors, rooms) — run early so tables are never empty
    console.log('Step 2b: Seeding sample data (tbl_edificio, tbl_piso, tbl_sala)...');
    try {
      await connection.query(`
        INSERT IGNORE INTO tbl_edificio (IDEdificio, Edificio) VALUES 
        (1, 'Edificio A'),
        (2, 'Edificio B'),
        (3, 'Torre Central')
      `);
      await connection.query(`
        INSERT IGNORE INTO tbl_piso (IDPiso, IDEdificio, Piso) VALUES 
        (1, 1, 'Piso 1'),
        (2, 1, 'Piso 2'),
        (3, 1, 'Piso 3'),
        (4, 2, 'Piso 1'),
        (5, 2, 'Piso 2'),
        (6, 3, 'Piso 1'),
        (7, 3, 'Piso 2')
      `);
      await connection.query(`
        INSERT IGNORE INTO tbl_sala (IDSala, IDPiso, Sala) VALUES 
        (1, 1, '101'),
        (2, 1, '102'),
        (3, 1, '103'),
        (4, 2, '201'),
        (5, 2, '202'),
        (6, 3, '301'),
        (7, 4, '101'),
        (8, 4, '102'),
        (9, 5, '201'),
        (10, 6, '101'),
        (11, 7, '201')
      `);
      console.log('  - tbl_edificio, tbl_piso, tbl_sala seeded.\n');
    } catch (seedErr) {
      console.warn('  - Seed warning:', seedErr.message);
      console.log('');
    }

    // Step 3: Create stored procedures
    console.log('Step 3: Creating stored procedures...');
    
    const procedures = [
      // Get user by ID (for login; no password)
      `CREATE PROCEDURE sptbl_usuarios_ObtenerPorID(IN p_IDUsuario VARCHAR(50))
       BEGIN
         SELECT IDUsuario, NombreUsuario, CorreoElectronico, Telefono, IDRol,
                IDSala, FechaInicioValidez, FechaFinValidez, PassTemp
         FROM tbl_usuarios WHERE IDUsuario = p_IDUsuario AND Activo = 1;
       END`,
      
      // List users
      `CREATE PROCEDURE spPRY_Usuario_Listar()
       BEGIN
         SELECT u.IDUsuario, u.NombreUsuario, u.CorreoElectronico, u.Telefono, u.IDRol,
                u.IDSala, u.FechaInicioValidez, u.FechaFinValidez,
                r.Descripcion AS Rol, a.IDAcceso
         FROM tbl_usuarios u
         LEFT JOIN tbl_rol r ON u.IDRol = r.IDRol
         LEFT JOIN tbl_acceso a ON u.IDUsuario = a.IDUsuario AND a.Activo = 1
         WHERE u.Activo = 1 ORDER BY u.NombreUsuario;
       END`,
      
      // Save user (IDSala, FechaInicioValidez, FechaFinValidez for Residente; no password)
      `CREATE PROCEDURE spPRY_Usuario_Guardar(
         IN p_Rut VARCHAR(50), IN p_Nombre VARCHAR(255),
         IN p_Correo VARCHAR(255), IN p_Telefono VARCHAR(20), IN p_IDRol INT,
         IN p_IDSala INT, IN p_FechaInicioValidez DATETIME, IN p_FechaFinValidez DATETIME
       )
       BEGIN
         INSERT INTO tbl_usuarios (IDUsuario, NombreUsuario, CorreoElectronico, Telefono, IDRol, IDSala, FechaInicioValidez, FechaFinValidez, PassTemp)
         VALUES (p_Rut, p_Nombre, p_Correo, p_Telefono, p_IDRol, p_IDSala, p_FechaInicioValidez, p_FechaFinValidez, 0)
         ON DUPLICATE KEY UPDATE
           NombreUsuario = p_Nombre, CorreoElectronico = p_Correo, Telefono = p_Telefono, IDRol = p_IDRol,
           IDSala = p_IDSala, FechaInicioValidez = p_FechaInicioValidez, FechaFinValidez = p_FechaFinValidez;
       END`,
      
      // Delete user
      `CREATE PROCEDURE spPRY_Usuario_Eliminar(IN p_IDUsuario VARCHAR(50))
       BEGIN
         UPDATE tbl_usuarios SET Activo = 0 WHERE IDUsuario = p_IDUsuario;
         UPDATE tbl_acceso SET Activo = 0 WHERE IDUsuario = p_IDUsuario;
       END`,
      
      // Get user for WebSocket
      `CREATE PROCEDURE spPRY_Usuario_ObtenerWS(IN p_Rut VARCHAR(50))
       BEGIN
         SELECT u.IDUsuario, u.NombreUsuario, a.IDAcceso, a.Payload
         FROM tbl_usuarios u
         LEFT JOIN tbl_acceso a ON u.IDUsuario = a.IDUsuario AND a.Activo = 1
         WHERE u.IDUsuario = p_Rut AND u.Activo = 1;
       END`,
      
      // Get roles for select
      `CREATE PROCEDURE sptbl_rol_Select(IN p_IDUsuario VARCHAR(50))
       BEGIN
         DECLARE userRol INT DEFAULT 1;
         SELECT IDRol INTO userRol FROM tbl_usuarios WHERE IDUsuario = p_IDUsuario;
         SELECT IDRol AS Restriccion, Descripcion FROM tbl_rol WHERE Activo = 1 AND Restriccion >= COALESCE(userRol, 1) ORDER BY Restriccion;
       END`,
      
      // Mobile roles
      `CREATE PROCEDURE spPRY_Mobile_Rol_Select(IN p_IDUsuario VARCHAR(50))
       BEGIN
         DECLARE userRol INT DEFAULT 1;
         SELECT IDRol INTO userRol FROM tbl_usuarios WHERE IDUsuario = p_IDUsuario;
         SELECT IDRol AS value, Descripcion AS label FROM tbl_rol WHERE Activo = 1 AND Restriccion >= COALESCE(userRol, 1) ORDER BY Restriccion;
       END`,
      
      // List access IDs
      `CREATE PROCEDURE spPRY_IDAcceso_Listar()
       BEGIN
         SELECT IDAcceso FROM tbl_acceso WHERE Activo = 1;
       END`,
      
      // Add user access link
      `CREATE PROCEDURE spPRY_Usuario_AgregarEnlace(IN p_IDAcceso VARCHAR(50), IN p_IDUsuario VARCHAR(50), IN p_Payload JSON)
       BEGIN
         INSERT INTO tbl_acceso (IDAcceso, IDUsuario, Payload) VALUES (p_IDAcceso, p_IDUsuario, p_Payload)
         ON DUPLICATE KEY UPDATE Payload = p_Payload, Activo = 1;
       END`,
      
      // Get user access link
      `CREATE PROCEDURE spPRY_Usuario_Enlace_Listar(IN p_IDUsuario VARCHAR(50))
       BEGIN
         SELECT IDAcceso, IDUsuario, Payload FROM tbl_acceso WHERE IDUsuario = p_IDUsuario AND Activo = 1;
       END`,
      
      // Get access by user
      `CREATE PROCEDURE sptbl_acceso_ObtenerPorUsuario(IN p_IDUsuario VARCHAR(50))
       BEGIN
         SELECT IDAcceso, IDUsuario, Payload, Activo, FechaCreacion FROM tbl_acceso WHERE Activo = 1 ORDER BY FechaCreacion DESC;
       END`,
      
      // Get access by access ID
      `CREATE PROCEDURE sptbl_acceso_ObtenerPorAcceso(IN p_IDAcceso VARCHAR(50))
       BEGIN
         SELECT a.IDAcceso, a.IDUsuario, a.Payload, u.NombreUsuario
         FROM tbl_acceso a LEFT JOIN tbl_usuarios u ON a.IDUsuario = u.IDUsuario
         WHERE a.IDAcceso = p_IDAcceso AND a.Activo = 1;
       END`,
      
      // Delete access
      `CREATE PROCEDURE sptbl_acceso_Eliminar(IN p_IDAcceso VARCHAR(50))
       BEGIN
         UPDATE tbl_acceso SET Activo = 0 WHERE IDAcceso = p_IDAcceso;
       END`,
      
      // List buildings
      `CREATE PROCEDURE sptbl_edificio_Listar()
       BEGIN
         SELECT IDEdificio, Edificio FROM tbl_edificio WHERE Activo = 1 ORDER BY Edificio;
       END`,
      
      // Save building
      `CREATE PROCEDURE sptbl_edificio_Guardar(IN p_Edificio VARCHAR(255))
       BEGIN
         INSERT INTO tbl_edificio (Edificio) VALUES (p_Edificio);
       END`,
      
      // Update building
      `CREATE PROCEDURE sptbl_edificio_Actualizar(IN p_IDEdificio INT, IN p_Edificio VARCHAR(255))
       BEGIN
         UPDATE tbl_edificio SET Edificio = p_Edificio WHERE IDEdificio = p_IDEdificio;
       END`,
      
      // Delete building
      `CREATE PROCEDURE sptbl_edificio_Eliminar(IN p_IDEdificio INT)
       BEGIN
         UPDATE tbl_edificio SET Activo = 0 WHERE IDEdificio = p_IDEdificio;
       END`,
      
      // List floors
      `CREATE PROCEDURE sptbl_piso_Listar()
       BEGIN
         SELECT p.IDPiso, p.IDEdificio, e.Edificio, p.Piso
         FROM tbl_piso p JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio
         WHERE p.Activo = 1 AND e.Activo = 1 ORDER BY e.Edificio, p.Piso;
       END`,
      
      // Save floor
      `CREATE PROCEDURE sptbl_piso_Guardar(IN p_IDEdificio INT, IN p_Piso VARCHAR(100))
       BEGIN
         INSERT INTO tbl_piso (IDEdificio, Piso) VALUES (p_IDEdificio, p_Piso);
       END`,
      
      // Update floor
      `CREATE PROCEDURE sptbl_piso_Actualizar(IN p_IDPiso INT, IN p_IDEdificio INT, IN p_Piso VARCHAR(100))
       BEGIN
         UPDATE tbl_piso SET IDEdificio = p_IDEdificio, Piso = p_Piso WHERE IDPiso = p_IDPiso;
       END`,
      
      // Delete floor
      `CREATE PROCEDURE sptbl_piso_Eliminar(IN p_IDPiso INT)
       BEGIN
         UPDATE tbl_piso SET Activo = 0 WHERE IDPiso = p_IDPiso;
       END`,
      
      // List rooms
      `CREATE PROCEDURE sptbl_sala_Listar()
       BEGIN
         SELECT s.IDSala, s.IDPiso, p.Piso, s.Sala, e.IDEdificio, e.Edificio
         FROM tbl_sala s
         JOIN tbl_piso p ON s.IDPiso = p.IDPiso
         JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio
         WHERE s.Activo = 1 AND p.Activo = 1 AND e.Activo = 1
         ORDER BY e.Edificio, p.Piso, s.Sala;
       END`,
      
      // Save room
      `CREATE PROCEDURE sptbl_sala_Guardar(IN p_IDPiso INT, IN p_Sala VARCHAR(255))
       BEGIN
         INSERT INTO tbl_sala (IDPiso, Sala) VALUES (p_IDPiso, p_Sala);
       END`,
      
      // Update room
      `CREATE PROCEDURE sptbl_sala_Actualizar(IN p_IDSala INT, IN p_IDPiso INT, IN p_Sala VARCHAR(255))
       BEGIN
         UPDATE tbl_sala SET IDPiso = p_IDPiso, Sala = p_Sala WHERE IDSala = p_IDSala;
       END`,
      
      // Delete room
      `CREATE PROCEDURE sptbl_sala_Eliminar(IN p_IDSala INT)
       BEGIN
         UPDATE tbl_sala SET Activo = 0 WHERE IDSala = p_IDSala;
       END`,
      
      // List locations
      `CREATE PROCEDURE sptbl_ubicacion_Listar()
       BEGIN
         SELECT u.IDUbicacion, u.IDSala, s.Sala, u.SN, u.Puerta, p.IDPiso, p.Piso, e.IDEdificio, e.Edificio
         FROM tbl_ubicacion u
         JOIN tbl_sala s ON u.IDSala = s.IDSala
         JOIN tbl_piso p ON s.IDPiso = p.IDPiso
         JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio
         WHERE u.Activo = 1 AND s.Activo = 1 AND p.Activo = 1 AND e.Activo = 1
         ORDER BY e.Edificio, p.Piso, s.Sala;
       END`,
      
      // Save location
      `CREATE PROCEDURE sptbl_ubicacion_Guardar(IN p_IDSala INT, IN p_SN VARCHAR(100), IN p_Puerta VARCHAR(100))
       BEGIN
         INSERT INTO tbl_ubicacion (IDSala, SN, Puerta) VALUES (p_IDSala, p_SN, p_Puerta);
       END`,
      
      // Delete location
      `CREATE PROCEDURE sptbl_ubicacion_Eliminar(IN p_IDUbicacion INT)
       BEGIN
         UPDATE tbl_ubicacion SET Activo = 0 WHERE IDUbicacion = p_IDUbicacion;
       END`,
      
      // Get location by SN and door
      `CREATE PROCEDURE sptbl_ubicacion_ObtenerPorSNPuerta(IN p_SN VARCHAR(100), IN p_Puerta VARCHAR(100))
       BEGIN
         SELECT u.IDUbicacion, u.IDSala, s.Sala, u.SN, u.Puerta
         FROM tbl_ubicacion u JOIN tbl_sala s ON u.IDSala = s.IDSala
         WHERE u.SN = p_SN AND u.Puerta = p_Puerta AND u.Activo = 1;
       END`,
      
      // List employees
      `CREATE PROCEDURE sptbl_emp_Listar()
       BEGIN
         SELECT IDEmp, IDUsuario, Nombre, CardNo, Fingerprint, Photo
         FROM tbl_emp WHERE Activo = 1 ORDER BY Nombre;
       END`,
      
      // Save employee
      `CREATE PROCEDURE sptbl_emp_Guardar(IN p_IDUsuario VARCHAR(50), IN p_Nombre VARCHAR(255), IN p_CardNo VARCHAR(100), IN p_Fingerprint TEXT, IN p_Photo TEXT, IN p_Extra1 VARCHAR(255), IN p_Extra2 VARCHAR(255))
       BEGIN
         INSERT INTO tbl_emp (IDUsuario, Nombre, CardNo, Fingerprint, Photo)
         VALUES (p_IDUsuario, p_Nombre, p_CardNo, p_Fingerprint, p_Photo)
         ON DUPLICATE KEY UPDATE Nombre = p_Nombre, CardNo = p_CardNo,
           Fingerprint = COALESCE(p_Fingerprint, Fingerprint), Photo = COALESCE(p_Photo, Photo);
       END`,
      
      // Delete employee
      `CREATE PROCEDURE sptbl_emp_Eliminar(IN p_IDUsuario VARCHAR(50))
       BEGIN
         UPDATE tbl_emp SET Activo = 0 WHERE IDUsuario = p_IDUsuario;
       END`,
      
      // Insert fingerprint
      `CREATE PROCEDURE sptbl_huella_InsertarWS(IN p_IDUsuario VARCHAR(50), IN p_FingerID INT, IN p_Fingerprint TEXT)
       BEGIN
         INSERT INTO tbl_huella (IDUsuario, FingerID, Fingerprint)
         VALUES (p_IDUsuario, p_FingerID, p_Fingerprint)
         ON DUPLICATE KEY UPDATE Fingerprint = p_Fingerprint;
       END`,
      
      // Add visit
      `CREATE PROCEDURE spPRY_Mobile_Visita_Agregar(IN p_IDUsuario VARCHAR(50), IN p_NombreVisitante VARCHAR(255), IN p_RutVisitante VARCHAR(50), IN p_Motivo VARCHAR(500), IN p_FechaInicio DATETIME, IN p_FechaFin DATETIME, IN p_IDSala INT)
       BEGIN
         INSERT INTO tbl_visita (IDUsuario, NombreVisitante, RutVisitante, Motivo, FechaInicio, FechaFin, IDSala)
         VALUES (p_IDUsuario, p_NombreVisitante, p_RutVisitante, p_Motivo, p_FechaInicio, p_FechaFin, p_IDSala);
       END`,
      
      // Update visit
      `CREATE PROCEDURE spPRY_Mobile_Visita_Actualizar(IN p_IDVisita INT, IN p_NombreVisitante VARCHAR(255), IN p_RutVisitante VARCHAR(50), IN p_Motivo VARCHAR(500), IN p_FechaInicio DATETIME, IN p_FechaFin DATETIME, IN p_IDSala INT)
       BEGIN
         UPDATE tbl_visita SET NombreVisitante = p_NombreVisitante, RutVisitante = p_RutVisitante,
           Motivo = p_Motivo, FechaInicio = p_FechaInicio, FechaFin = p_FechaFin, IDSala = p_IDSala
         WHERE IDVisita = p_IDVisita;
       END`,
      
      // Save log
      `CREATE PROCEDURE sptbl_log_Guardar(IN p_Funcion VARCHAR(255), IN p_Linea INT, IN p_Request TEXT)
       BEGIN
         INSERT INTO tbl_log (Funcion, Linea, Request) VALUES (p_Funcion, p_Linea, p_Request);
       END`,
      
      // Create invitation (TipoInvitacion = Visitante | Delivery)
      `CREATE PROCEDURE sptbl_invitacion_Crear(
        IN p_IDAcceso VARCHAR(50),
        IN p_CreadoPor VARCHAR(50),
        IN p_NombreInvitado VARCHAR(255),
        IN p_RutInvitado VARCHAR(50),
        IN p_CorreoInvitado VARCHAR(255),
        IN p_TelefonoInvitado VARCHAR(20),
        IN p_TipoInvitacion VARCHAR(50),
        IN p_Motivo VARCHAR(500),
        IN p_FechaInicio DATETIME,
        IN p_FechaFin DATETIME,
        IN p_IDSala INT,
        IN p_UsageLimit INT,
        IN p_QRCode TEXT
      )
       BEGIN
         INSERT INTO tbl_invitacion (
           IDAcceso, CreadoPor, NombreInvitado, RutInvitado, CorreoInvitado,
           TelefonoInvitado, TipoInvitacion, Motivo, FechaInicio, FechaFin, IDSala, UsageLimit, QRCode
         ) VALUES (
           p_IDAcceso, p_CreadoPor, p_NombreInvitado, p_RutInvitado, p_CorreoInvitado,
           p_TelefonoInvitado, COALESCE(p_TipoInvitacion, 'Visitante'), p_Motivo, p_FechaInicio, p_FechaFin, p_IDSala, p_UsageLimit, p_QRCode
         );
         SELECT LAST_INSERT_ID() AS IDInvitacion;
       END`,
      
      // List invitations by creator
      `CREATE PROCEDURE sptbl_invitacion_Listar(IN p_CreadoPor VARCHAR(50))
       BEGIN
         SELECT 
           i.IDInvitacion,
           i.IDAcceso,
           i.NombreInvitado,
           i.RutInvitado,
           i.CorreoInvitado,
           i.TelefonoInvitado,
           i.TipoInvitacion,
           i.Motivo,
           i.FechaInicio,
           i.FechaFin,
           i.IDSala,
           s.Sala,
           i.Status,
           i.UsageLimit,
           i.UsedCount,
           i.QRCode,
           i.FechaCreacion,
           i.CancelledAt,
           CASE 
             WHEN i.Status = 'CANCELLED' THEN 'CANCELLED'
             WHEN i.Status = 'USED' THEN 'USED'
             WHEN NOW() > i.FechaFin THEN 'EXPIRED'
             WHEN NOW() < i.FechaInicio THEN 'PENDING'
             ELSE 'ACTIVE'
           END AS StatusActual
         FROM tbl_invitacion i
         LEFT JOIN tbl_sala s ON i.IDSala = s.IDSala
         WHERE i.CreadoPor = p_CreadoPor AND i.Activo = 1
         ORDER BY i.FechaCreacion DESC;
       END`,
      
      // Get invitation by ID
      `CREATE PROCEDURE sptbl_invitacion_Obtener(IN p_IDInvitacion INT)
       BEGIN
         SELECT 
           i.*,
           s.Sala,
           CASE 
             WHEN i.Status = 'CANCELLED' THEN 'CANCELLED'
             WHEN i.Status = 'USED' THEN 'USED'
             WHEN NOW() > i.FechaFin THEN 'EXPIRED'
             WHEN NOW() < i.FechaInicio THEN 'PENDING'
             ELSE 'ACTIVE'
           END AS StatusActual
         FROM tbl_invitacion i
         LEFT JOIN tbl_sala s ON i.IDSala = s.IDSala
         WHERE i.IDInvitacion = p_IDInvitacion AND i.Activo = 1;
       END`,
      
      // Cancel invitation
      `CREATE PROCEDURE sptbl_invitacion_Cancelar(IN p_IDInvitacion INT, IN p_CancelledBy VARCHAR(50))
       BEGIN
         DECLARE v_IDAcceso VARCHAR(50);
         SELECT IDAcceso INTO v_IDAcceso FROM tbl_invitacion WHERE IDInvitacion = p_IDInvitacion;
         UPDATE tbl_invitacion 
         SET Status = 'CANCELLED', CancelledAt = NOW(), CancelledBy = p_CancelledBy
         WHERE IDInvitacion = p_IDInvitacion;
         UPDATE tbl_acceso 
         SET Status = 'CANCELLED', Activo = 0, CancelledAt = NOW(), CancelledBy = p_CancelledBy
         WHERE IDAcceso = v_IDAcceso;
         SELECT ROW_COUNT() AS affected;
       END`,
      
      // Mark invitation as used
      `CREATE PROCEDURE sptbl_invitacion_MarcarUsada(IN p_IDAcceso VARCHAR(50))
       BEGIN
         DECLARE v_UsageLimit INT;
         DECLARE v_UsedCount INT;
         SELECT UsageLimit, UsedCount INTO v_UsageLimit, v_UsedCount 
         FROM tbl_invitacion WHERE IDAcceso = p_IDAcceso AND Activo = 1;
         UPDATE tbl_invitacion 
         SET UsedCount = UsedCount + 1,
             Status = CASE WHEN UsedCount + 1 >= UsageLimit THEN 'USED' ELSE Status END
         WHERE IDAcceso = p_IDAcceso AND Activo = 1;
         UPDATE tbl_acceso 
         SET UsedCount = UsedCount + 1,
             Status = CASE WHEN UsedCount + 1 >= UsageLimit THEN 'USED' ELSE Status END
         WHERE IDAcceso = p_IDAcceso;
       END`,
      
      // Validate invitation for access
      `CREATE PROCEDURE sptbl_invitacion_Validar(IN p_IDAcceso VARCHAR(50))
       BEGIN
         SELECT 
           i.IDInvitacion,
           i.IDAcceso,
           i.NombreInvitado,
           i.FechaInicio,
           i.FechaFin,
           i.IDSala,
           i.Status,
           i.UsageLimit,
           i.UsedCount,
           CASE 
             WHEN i.Status = 'CANCELLED' THEN 'CANCELLED'
             WHEN i.Status = 'USED' THEN 'USED'
             WHEN i.UsedCount >= i.UsageLimit THEN 'USED'
             WHEN NOW() > i.FechaFin THEN 'EXPIRED'
             WHEN NOW() < i.FechaInicio THEN 'NOT_YET_VALID'
             ELSE 'VALID'
           END AS ValidationResult
         FROM tbl_invitacion i
         WHERE i.IDAcceso = p_IDAcceso AND i.Activo = 1;
       END`,
      
      // Register access event
      `CREATE PROCEDURE sptbl_accessevent_Registrar(
        IN p_IDAcceso VARCHAR(50),
        IN p_IDInvitacion INT,
        IN p_DeviceSN VARCHAR(100),
        IN p_DeviceName VARCHAR(255),
        IN p_Puerta VARCHAR(100),
        IN p_Result ENUM('ALLOWED', 'DENIED'),
        IN p_Reason VARCHAR(100),
        IN p_RawData TEXT
      )
       BEGIN
         INSERT INTO tbl_accessevent (
           IDAcceso, IDInvitacion, DeviceSN, DeviceName, Puerta, Result, Reason, RawData
         ) VALUES (
           p_IDAcceso, p_IDInvitacion, p_DeviceSN, p_DeviceName, p_Puerta, p_Result, p_Reason, p_RawData
         );
         SELECT LAST_INSERT_ID() AS IDEvent;
       END`,
      
      // List access events for invitation
      `CREATE PROCEDURE sptbl_accessevent_Listar(IN p_IDInvitacion INT)
       BEGIN
         SELECT * FROM tbl_accessevent 
         WHERE IDInvitacion = p_IDInvitacion 
         ORDER BY ScannedAt DESC;
       END`
    ];

    for (const proc of procedures) {
      const procName = proc.match(/PROCEDURE\s+(\w+)/i)?.[1] || 'unknown';
      try {
        await connection.query(`DROP PROCEDURE IF EXISTS ${procName}`);
        await connection.query(proc);
        console.log(`  - ${procName} created`);
      } catch (err) {
        console.warn(`  - Warning: ${procName}: ${err.message.substring(0, 50)}`);
      }
    }
    console.log('Stored procedures created.\n');

    // Step 3b: Create indexes (idempotent)
    console.log('Step 3b: Creating indexes...');
    const indexes = [
      { name: 'idx_invitacion_creador', table: 'tbl_invitacion', column: 'CreadoPor' },
      { name: 'idx_invitacion_status', table: 'tbl_invitacion', column: 'Status' },
      { name: 'idx_invitacion_acceso', table: 'tbl_invitacion', column: 'IDAcceso' },
      { name: 'idx_event_acceso', table: 'tbl_accessevent', column: 'IDAcceso' },
      { name: 'idx_event_fecha', table: 'tbl_accessevent', column: 'ScannedAt' },
      { name: 'idx_event_result', table: 'tbl_accessevent', column: 'Result' },
      { name: 'idx_acceso_status', table: 'tbl_acceso', column: 'Status' }
    ];
    for (const idx of indexes) {
      try {
        await connection.query(`CREATE INDEX ${idx.name} ON ${idx.table}(${idx.column})`);
        console.log(`  - ${idx.name} created`);
      } catch (e) {
        if (e.code === 'ER_DUP_KEYNAME') console.log(`  - ${idx.name} already exists`);
        else console.warn(`  - ${idx.name}: ${e.message.substring(0, 40)}`);
      }
    }
    console.log('');

    // Step 4: Create admin user (default RUT: 11111111-1, fullName: admin)
    console.log('Step 4: Creating admin user...');
    // Check if admin already exists (login uses RUT + full name only, no password)
    const [existingUsers] = await connection.query(
      'SELECT IDUsuario FROM tbl_usuarios WHERE IDUsuario = ?',
      [options.adminUser]
    );

    if (existingUsers.length > 0) {
      console.log(`User "${options.adminUser}" already exists. Updating name...`);
      await connection.query(
        'UPDATE tbl_usuarios SET NombreUsuario = ?, PassTemp = 0 WHERE IDUsuario = ?',
        [options.adminName, options.adminUser]
      );
    } else {
      await connection.query(
        `INSERT INTO tbl_usuarios (IDUsuario, NombreUsuario, CorreoElectronico, Telefono, IDRol, IDSala, FechaInicioValidez, FechaFinValidez, PassTemp) 
         VALUES (?, ?, ?, ?, 1, NULL, NULL, NULL, 0)`,
        [options.adminUser, options.adminName, options.adminEmail, options.adminPhone]
      );
    }
    console.log('Admin user created/updated successfully.\n');

    // Summary
    console.log('========================================');
    console.log('  Setup Complete!');
    console.log('========================================\n');
    console.log('Admin (in tbl_usuarios, login with RUT + full name):');
    console.log(`  RUT:       ${options.adminUser}`);
    console.log(`  Nombre:    ${options.adminName}`);
    console.log(`  Email:     ${options.adminEmail}`);
    console.log(`  Role:      Administrador (ID: 1)`);
    console.log('\nSample data: tbl_edificio, tbl_piso, tbl_sala are seeded with default buildings/floors/rooms.\n');

    console.log('Next Steps:');
    console.log('  1. Start backend:  npm start  (or npm run dev)');
    console.log('  2. Start frontend: cd ../ControlAccess && ionic serve');
    console.log('  3. Login with RUT and full name (e.g. RUT: 11111111-1, Nombre: admin)');
    console.log('\nNote: migrate.js, fix-roles.js, and seed-data.js are no longer required;');
    console.log('      setup.js performs all migrations and seeding.\n');

  } catch (error) {
    console.error('\nError during setup:', error.message);
    console.error('\nTroubleshooting:');
    console.error('  1. Make sure MySQL is running');
    console.error('  2. Check your .env file has correct database credentials');
    console.error('  3. Ensure the database user has CREATE DATABASE privileges');
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
      console.log('Database connection closed.');
    }
  }
}

main();
