/**
 * Seed sample data for buildings, floors, and rooms
 */
require('dotenv').config();
const mysql = require('mysql2/promise');

async function seedData() {
  let conn;
  
  try {
    conn = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASS ? atob(process.env.DB_PASS) : '',
      database: process.env.DB_DABS
    });
    
    console.log('Creating sample data...\n');
    
    // Create buildings
    await conn.query(`
      INSERT IGNORE INTO PRY_Edificio (IDEdificio, Edificio) VALUES 
      (1, 'Edificio A'),
      (2, 'Edificio B'),
      (3, 'Torre Central')
    `);
    console.log('- Buildings created');
    
    // Create floors
    await conn.query(`
      INSERT IGNORE INTO PRY_Piso (IDPiso, IDEdificio, Piso) VALUES 
      (1, 1, 'Piso 1'),
      (2, 1, 'Piso 2'),
      (3, 1, 'Piso 3'),
      (4, 2, 'Piso 1'),
      (5, 2, 'Piso 2'),
      (6, 3, 'Piso 1'),
      (7, 3, 'Piso 2')
    `);
    console.log('- Floors created');
    
    // Create rooms/units
    await conn.query(`
      INSERT IGNORE INTO PRY_Sala (IDSala, IDPiso, Sala) VALUES 
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
    console.log('- Rooms/Units created');
    
    // Verify data
    const [salas] = await conn.query(`
      SELECT s.IDSala, e.Edificio, p.Piso, s.Sala 
      FROM PRY_Sala s 
      JOIN PRY_Piso p ON s.IDPiso = p.IDPiso 
      JOIN PRY_Edificio e ON p.IDEdificio = e.IDEdificio 
      WHERE s.Activo = 1
      ORDER BY e.Edificio, p.Piso, s.Sala
    `);
    
    console.log('\nAvailable units:');
    console.table(salas);
    
    console.log('\nSample data created successfully!');
    console.log('Please log out and log in again to see the units in the dropdown.');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    if (conn) await conn.end();
  }
}

seedData();
