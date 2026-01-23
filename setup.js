/**
 * Database Setup Script
 * 
 * This script:
 * 1. Creates the database and tables
 * 2. Creates all stored procedures
 * 3. Creates an admin user with credentials
 * 
 * Usage: node setup.js [--admin-user <rut>] [--admin-pass <password>] [--admin-email <email>]
 */

require('dotenv').config();
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const Cryptojs = require('crypto-js');

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
    adminPass: 'admin123',
    adminEmail: 'admin@example.com',
    adminName: 'Administrador',
    adminPhone: '+56900000000'
  };

  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--admin-user':
        options.adminUser = args[++i];
        break;
      case '--admin-pass':
        options.adminPass = args[++i];
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
  --admin-pass <password>  Admin password (default: admin123)
  --admin-email <email>    Admin email (default: admin@example.com)
  --admin-name <name>      Admin name (default: Administrador)
  --admin-phone <phone>    Admin phone (default: +56900000000)
  --help                   Show this help message

Examples:
  node setup.js
  node setup.js --admin-user "12345678-9" --admin-pass "mypassword" --admin-email "admin@company.com"
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
    
    // Roles Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Rol (
        IDRol INT AUTO_INCREMENT PRIMARY KEY,
        Descripcion VARCHAR(100) NOT NULL,
        Restriccion INT DEFAULT 0,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - PRY_Rol created');

    // Users Table
    await connection.query(`
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
      )
    `);
    console.log('  - PRY_Usuarios created');

    // Access Control Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Acceso (
        IDAcceso VARCHAR(50) PRIMARY KEY,
        IDUsuario VARCHAR(50),
        Payload JSON,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDUsuario) REFERENCES PRY_Usuarios(IDUsuario)
      )
    `);
    console.log('  - PRY_Acceso created');

    // Buildings Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Edificio (
        IDEdificio INT AUTO_INCREMENT PRIMARY KEY,
        Edificio VARCHAR(255) NOT NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - PRY_Edificio created');

    // Floors Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Piso (
        IDPiso INT AUTO_INCREMENT PRIMARY KEY,
        IDEdificio INT,
        Piso VARCHAR(100) NOT NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDEdificio) REFERENCES PRY_Edificio(IDEdificio)
      )
    `);
    console.log('  - PRY_Piso created');

    // Rooms Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Sala (
        IDSala INT AUTO_INCREMENT PRIMARY KEY,
        IDPiso INT,
        Sala VARCHAR(255) NOT NULL,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDPiso) REFERENCES PRY_Piso(IDPiso)
      )
    `);
    console.log('  - PRY_Sala created');

    // Location/Device Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Ubicacion (
        IDUbicacion INT AUTO_INCREMENT PRIMARY KEY,
        IDSala INT,
        SN VARCHAR(100),
        Puerta VARCHAR(100),
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (IDSala) REFERENCES PRY_Sala(IDSala)
      )
    `);
    console.log('  - PRY_Ubicacion created');

    // Employees Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Emp (
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
    console.log('  - PRY_Emp created');

    // Fingerprint Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Huella (
        IDHuella INT AUTO_INCREMENT PRIMARY KEY,
        IDUsuario VARCHAR(50),
        FingerID INT,
        Fingerprint TEXT,
        Activo TINYINT(1) DEFAULT 1,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - PRY_Huella created');

    // Visits Table
    await connection.query(`
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
      )
    `);
    console.log('  - PRY_Visita created');

    // Log Table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS PRY_Log (
        IDLog INT AUTO_INCREMENT PRIMARY KEY,
        Funcion VARCHAR(255),
        Linea INT,
        Request TEXT,
        FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('  - PRY_Log created');

    // Insert default roles
    await connection.query(`
      INSERT IGNORE INTO PRY_Rol (IDRol, Descripcion, Restriccion) VALUES 
        (1, 'Administrador', 1),
        (2, 'Supervisor', 2),
        (3, 'Usuario', 3),
        (4, 'Visitante', 4)
    `);
    console.log('  - Default roles inserted');
    console.log('Tables created successfully.\n');

    // Step 3: Create stored procedures
    console.log('Step 3: Creating stored procedures...');
    
    const procedures = [
      // Get user by ID (for login)
      `CREATE PROCEDURE spPRY_Usuarios_ObtenerPorID(IN p_IDUsuario VARCHAR(50))
       BEGIN
         SELECT IDUsuario, NombreUsuario, Passwd, CorreoElectronico, Telefono, IDRol, PassTemp
         FROM PRY_Usuarios WHERE IDUsuario = p_IDUsuario AND Activo = 1;
       END`,
      
      // Change password
      `CREATE PROCEDURE spPRY_Usuarios_CambiarPass(IN p_IDUsuario VARCHAR(50), IN p_Password VARCHAR(255))
       BEGIN
         UPDATE PRY_Usuarios SET Passwd = MD5(p_Password), PassTemp = 0 WHERE IDUsuario = p_IDUsuario;
       END`,
      
      // List users
      `CREATE PROCEDURE spPRY_Usuario_Listar()
       BEGIN
         SELECT u.IDUsuario, u.NombreUsuario, u.CorreoElectronico, u.Telefono, u.IDRol,
                r.Descripcion AS Rol, a.IDAcceso
         FROM PRY_Usuarios u
         LEFT JOIN PRY_Rol r ON u.IDRol = r.IDRol
         LEFT JOIN PRY_Acceso a ON u.IDUsuario = a.IDUsuario AND a.Activo = 1
         WHERE u.Activo = 1 ORDER BY u.NombreUsuario;
       END`,
      
      // Save user
      `CREATE PROCEDURE spPRY_Usuario_Guardar(IN p_Rut VARCHAR(50), IN p_Nombre VARCHAR(255), IN p_Passwd VARCHAR(255), IN p_Correo VARCHAR(255), IN p_Telefono VARCHAR(20), IN p_IDRol INT)
       BEGIN
         INSERT INTO PRY_Usuarios (IDUsuario, NombreUsuario, Passwd, CorreoElectronico, Telefono, IDRol, PassTemp)
         VALUES (p_Rut, p_Nombre, MD5(p_Passwd), p_Correo, p_Telefono, p_IDRol, 1)
         ON DUPLICATE KEY UPDATE NombreUsuario = p_Nombre, CorreoElectronico = p_Correo, Telefono = p_Telefono, IDRol = p_IDRol;
       END`,
      
      // Delete user
      `CREATE PROCEDURE spPRY_Usuario_Eliminar(IN p_IDUsuario VARCHAR(50))
       BEGIN
         UPDATE PRY_Usuarios SET Activo = 0 WHERE IDUsuario = p_IDUsuario;
         UPDATE PRY_Acceso SET Activo = 0 WHERE IDUsuario = p_IDUsuario;
       END`,
      
      // Get user for WebSocket
      `CREATE PROCEDURE spPRY_Usuario_ObtenerWS(IN p_Rut VARCHAR(50))
       BEGIN
         SELECT u.IDUsuario, u.NombreUsuario, a.IDAcceso, a.Payload
         FROM PRY_Usuarios u
         LEFT JOIN PRY_Acceso a ON u.IDUsuario = a.IDUsuario AND a.Activo = 1
         WHERE u.IDUsuario = p_Rut AND u.Activo = 1;
       END`,
      
      // Get roles for select
      `CREATE PROCEDURE spPRY_Rol_Select(IN p_IDUsuario VARCHAR(50))
       BEGIN
         DECLARE userRol INT DEFAULT 1;
         SELECT IDRol INTO userRol FROM PRY_Usuarios WHERE IDUsuario = p_IDUsuario;
         SELECT IDRol AS Restriccion, Descripcion FROM PRY_Rol WHERE Activo = 1 AND Restriccion >= COALESCE(userRol, 1) ORDER BY Restriccion;
       END`,
      
      // Mobile roles
      `CREATE PROCEDURE spPRY_Mobile_Rol_Select(IN p_IDUsuario VARCHAR(50))
       BEGIN
         DECLARE userRol INT DEFAULT 1;
         SELECT IDRol INTO userRol FROM PRY_Usuarios WHERE IDUsuario = p_IDUsuario;
         SELECT IDRol AS value, Descripcion AS label FROM PRY_Rol WHERE Activo = 1 AND Restriccion >= COALESCE(userRol, 1) ORDER BY Restriccion;
       END`,
      
      // List access IDs
      `CREATE PROCEDURE spPRY_IDAcceso_Listar()
       BEGIN
         SELECT IDAcceso FROM PRY_Acceso WHERE Activo = 1;
       END`,
      
      // Add user access link
      `CREATE PROCEDURE spPRY_Usuario_AgregarEnlace(IN p_IDAcceso VARCHAR(50), IN p_IDUsuario VARCHAR(50), IN p_Payload JSON)
       BEGIN
         INSERT INTO PRY_Acceso (IDAcceso, IDUsuario, Payload) VALUES (p_IDAcceso, p_IDUsuario, p_Payload)
         ON DUPLICATE KEY UPDATE Payload = p_Payload, Activo = 1;
       END`,
      
      // Get user access link
      `CREATE PROCEDURE spPRY_Usuario_Enlace_Listar(IN p_IDUsuario VARCHAR(50))
       BEGIN
         SELECT IDAcceso, IDUsuario, Payload FROM PRY_Acceso WHERE IDUsuario = p_IDUsuario AND Activo = 1;
       END`,
      
      // Get access by user
      `CREATE PROCEDURE spPRY_Acceso_ObtenerPorUsuario(IN p_IDUsuario VARCHAR(50))
       BEGIN
         SELECT IDAcceso, IDUsuario, Payload FROM PRY_Acceso WHERE IDUsuario = p_IDUsuario AND Activo = 1;
       END`,
      
      // Get access by access ID
      `CREATE PROCEDURE spPRY_Acceso_ObtenerPorAcceso(IN p_IDAcceso VARCHAR(50))
       BEGIN
         SELECT a.IDAcceso, a.IDUsuario, a.Payload, u.NombreUsuario
         FROM PRY_Acceso a LEFT JOIN PRY_Usuarios u ON a.IDUsuario = u.IDUsuario
         WHERE a.IDAcceso = p_IDAcceso AND a.Activo = 1;
       END`,
      
      // Delete access
      `CREATE PROCEDURE spPRY_Acceso_Eliminar(IN p_IDAcceso VARCHAR(50))
       BEGIN
         UPDATE PRY_Acceso SET Activo = 0 WHERE IDAcceso = p_IDAcceso;
       END`,
      
      // List buildings
      `CREATE PROCEDURE spPRY_Edificio_Listar()
       BEGIN
         SELECT IDEdificio, Edificio FROM PRY_Edificio WHERE Activo = 1 ORDER BY Edificio;
       END`,
      
      // Save building
      `CREATE PROCEDURE spPRY_Edificio_Guardar(IN p_Edificio VARCHAR(255))
       BEGIN
         INSERT INTO PRY_Edificio (Edificio) VALUES (p_Edificio);
       END`,
      
      // Update building
      `CREATE PROCEDURE spPRY_Edificio_Actualizar(IN p_IDEdificio INT, IN p_Edificio VARCHAR(255))
       BEGIN
         UPDATE PRY_Edificio SET Edificio = p_Edificio WHERE IDEdificio = p_IDEdificio;
       END`,
      
      // Delete building
      `CREATE PROCEDURE spPRY_Edificio_Eliminar(IN p_IDEdificio INT)
       BEGIN
         UPDATE PRY_Edificio SET Activo = 0 WHERE IDEdificio = p_IDEdificio;
       END`,
      
      // List floors
      `CREATE PROCEDURE spPRY_Piso_Listar()
       BEGIN
         SELECT p.IDPiso, p.IDEdificio, e.Edificio, p.Piso
         FROM PRY_Piso p JOIN PRY_Edificio e ON p.IDEdificio = e.IDEdificio
         WHERE p.Activo = 1 AND e.Activo = 1 ORDER BY e.Edificio, p.Piso;
       END`,
      
      // Save floor
      `CREATE PROCEDURE spPRY_Piso_Guardar(IN p_IDEdificio INT, IN p_Piso VARCHAR(100))
       BEGIN
         INSERT INTO PRY_Piso (IDEdificio, Piso) VALUES (p_IDEdificio, p_Piso);
       END`,
      
      // Update floor
      `CREATE PROCEDURE spPRY_Piso_Actualizar(IN p_IDPiso INT, IN p_IDEdificio INT, IN p_Piso VARCHAR(100))
       BEGIN
         UPDATE PRY_Piso SET IDEdificio = p_IDEdificio, Piso = p_Piso WHERE IDPiso = p_IDPiso;
       END`,
      
      // Delete floor
      `CREATE PROCEDURE spPRY_Piso_Eliminar(IN p_IDPiso INT)
       BEGIN
         UPDATE PRY_Piso SET Activo = 0 WHERE IDPiso = p_IDPiso;
       END`,
      
      // List rooms
      `CREATE PROCEDURE spPRY_Sala_Listar()
       BEGIN
         SELECT s.IDSala, s.IDPiso, p.Piso, s.Sala, e.IDEdificio, e.Edificio
         FROM PRY_Sala s
         JOIN PRY_Piso p ON s.IDPiso = p.IDPiso
         JOIN PRY_Edificio e ON p.IDEdificio = e.IDEdificio
         WHERE s.Activo = 1 AND p.Activo = 1 AND e.Activo = 1
         ORDER BY e.Edificio, p.Piso, s.Sala;
       END`,
      
      // Save room
      `CREATE PROCEDURE spPRY_Sala_Guardar(IN p_IDPiso INT, IN p_Sala VARCHAR(255))
       BEGIN
         INSERT INTO PRY_Sala (IDPiso, Sala) VALUES (p_IDPiso, p_Sala);
       END`,
      
      // Update room
      `CREATE PROCEDURE spPRY_Sala_Actualizar(IN p_IDSala INT, IN p_IDPiso INT, IN p_Sala VARCHAR(255))
       BEGIN
         UPDATE PRY_Sala SET IDPiso = p_IDPiso, Sala = p_Sala WHERE IDSala = p_IDSala;
       END`,
      
      // Delete room
      `CREATE PROCEDURE spPRY_Sala_Eliminar(IN p_IDSala INT)
       BEGIN
         UPDATE PRY_Sala SET Activo = 0 WHERE IDSala = p_IDSala;
       END`,
      
      // List locations
      `CREATE PROCEDURE spPRY_Ubicacion_Listar()
       BEGIN
         SELECT u.IDUbicacion, u.IDSala, s.Sala, u.SN, u.Puerta, p.IDPiso, p.Piso, e.IDEdificio, e.Edificio
         FROM PRY_Ubicacion u
         JOIN PRY_Sala s ON u.IDSala = s.IDSala
         JOIN PRY_Piso p ON s.IDPiso = p.IDPiso
         JOIN PRY_Edificio e ON p.IDEdificio = e.IDEdificio
         WHERE u.Activo = 1 AND s.Activo = 1 AND p.Activo = 1 AND e.Activo = 1
         ORDER BY e.Edificio, p.Piso, s.Sala;
       END`,
      
      // Save location
      `CREATE PROCEDURE spPRY_Ubicacion_Guardar(IN p_IDSala INT, IN p_SN VARCHAR(100), IN p_Puerta VARCHAR(100))
       BEGIN
         INSERT INTO PRY_Ubicacion (IDSala, SN, Puerta) VALUES (p_IDSala, p_SN, p_Puerta);
       END`,
      
      // Delete location
      `CREATE PROCEDURE spPRY_Ubicacion_Eliminar(IN p_IDUbicacion INT)
       BEGIN
         UPDATE PRY_Ubicacion SET Activo = 0 WHERE IDUbicacion = p_IDUbicacion;
       END`,
      
      // Get location by SN and door
      `CREATE PROCEDURE spPRY_Ubicacion_ObtenerPorSNPuerta(IN p_SN VARCHAR(100), IN p_Puerta VARCHAR(100))
       BEGIN
         SELECT u.IDUbicacion, u.IDSala, s.Sala, u.SN, u.Puerta
         FROM PRY_Ubicacion u JOIN PRY_Sala s ON u.IDSala = s.IDSala
         WHERE u.SN = p_SN AND u.Puerta = p_Puerta AND u.Activo = 1;
       END`,
      
      // List employees
      `CREATE PROCEDURE spPRY_Emp_Listar()
       BEGIN
         SELECT IDEmp, IDUsuario, Nombre, CardNo, Fingerprint, Photo
         FROM PRY_Emp WHERE Activo = 1 ORDER BY Nombre;
       END`,
      
      // Save employee
      `CREATE PROCEDURE spPRY_Emp_Guardar(IN p_IDUsuario VARCHAR(50), IN p_Nombre VARCHAR(255), IN p_CardNo VARCHAR(100), IN p_Fingerprint TEXT, IN p_Photo TEXT, IN p_Extra1 VARCHAR(255), IN p_Extra2 VARCHAR(255))
       BEGIN
         INSERT INTO PRY_Emp (IDUsuario, Nombre, CardNo, Fingerprint, Photo)
         VALUES (p_IDUsuario, p_Nombre, p_CardNo, p_Fingerprint, p_Photo)
         ON DUPLICATE KEY UPDATE Nombre = p_Nombre, CardNo = p_CardNo,
           Fingerprint = COALESCE(p_Fingerprint, Fingerprint), Photo = COALESCE(p_Photo, Photo);
       END`,
      
      // Delete employee
      `CREATE PROCEDURE spPRY_Emp_Eliminar(IN p_IDUsuario VARCHAR(50))
       BEGIN
         UPDATE PRY_Emp SET Activo = 0 WHERE IDUsuario = p_IDUsuario;
       END`,
      
      // Insert fingerprint
      `CREATE PROCEDURE spPRY_Huella_InsertarWS(IN p_IDUsuario VARCHAR(50), IN p_FingerID INT, IN p_Fingerprint TEXT)
       BEGIN
         INSERT INTO PRY_Huella (IDUsuario, FingerID, Fingerprint)
         VALUES (p_IDUsuario, p_FingerID, p_Fingerprint)
         ON DUPLICATE KEY UPDATE Fingerprint = p_Fingerprint;
       END`,
      
      // Add visit
      `CREATE PROCEDURE spPRY_Mobile_Visita_Agregar(IN p_IDUsuario VARCHAR(50), IN p_NombreVisitante VARCHAR(255), IN p_RutVisitante VARCHAR(50), IN p_Motivo VARCHAR(500), IN p_FechaInicio DATETIME, IN p_FechaFin DATETIME, IN p_IDSala INT)
       BEGIN
         INSERT INTO PRY_Visita (IDUsuario, NombreVisitante, RutVisitante, Motivo, FechaInicio, FechaFin, IDSala)
         VALUES (p_IDUsuario, p_NombreVisitante, p_RutVisitante, p_Motivo, p_FechaInicio, p_FechaFin, p_IDSala);
       END`,
      
      // Update visit
      `CREATE PROCEDURE spPRY_Mobile_Visita_Actualizar(IN p_IDVisita INT, IN p_NombreVisitante VARCHAR(255), IN p_RutVisitante VARCHAR(50), IN p_Motivo VARCHAR(500), IN p_FechaInicio DATETIME, IN p_FechaFin DATETIME, IN p_IDSala INT)
       BEGIN
         UPDATE PRY_Visita SET NombreVisitante = p_NombreVisitante, RutVisitante = p_RutVisitante,
           Motivo = p_Motivo, FechaInicio = p_FechaInicio, FechaFin = p_FechaFin, IDSala = p_IDSala
         WHERE IDVisita = p_IDVisita;
       END`,
      
      // Save log
      `CREATE PROCEDURE spPRY_Log_Guardar(IN p_Funcion VARCHAR(255), IN p_Linea INT, IN p_Request TEXT)
       BEGIN
         INSERT INTO PRY_Log (Funcion, Linea, Request) VALUES (p_Funcion, p_Linea, p_Request);
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

    // Step 4: Create admin user
    console.log('Step 4: Creating admin user...');
    const hashedPassword = String(Cryptojs.MD5(options.adminPass));
    
    // Check if admin already exists
    const [existingUsers] = await connection.query(
      'SELECT IDUsuario FROM PRY_Usuarios WHERE IDUsuario = ?',
      [options.adminUser]
    );

    if (existingUsers.length > 0) {
      console.log(`User "${options.adminUser}" already exists. Updating password...`);
      await connection.query(
        'UPDATE PRY_Usuarios SET Passwd = ?, PassTemp = 1 WHERE IDUsuario = ?',
        [hashedPassword, options.adminUser]
      );
    } else {
      await connection.query(
        `INSERT INTO PRY_Usuarios (IDUsuario, NombreUsuario, Passwd, CorreoElectronico, Telefono, IDRol, PassTemp) 
         VALUES (?, ?, ?, ?, ?, 1, 1)`,
        [options.adminUser, options.adminName, hashedPassword, options.adminEmail, options.adminPhone]
      );
    }
    console.log('Admin user created/updated successfully.\n');

    // Summary
    console.log('========================================');
    console.log('  Setup Complete!');
    console.log('========================================\n');
    console.log('Admin Credentials:');
    console.log(`  User:     ${options.adminUser}`);
    console.log(`  Password: ${options.adminPass}`);
    console.log(`  Email:    ${options.adminEmail}`);
    console.log(`  Role:     Administrador (ID: 1)\n`);
    console.log('Note: Password is temporary - user will be prompted to change on first login.\n');

    console.log('Next Steps:');
    console.log('  1. Start backend:  npm run dev');
    console.log('  2. Start frontend: cd ../ControlAccess && npm run dev');
    console.log('  3. Login with admin credentials\n');

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
