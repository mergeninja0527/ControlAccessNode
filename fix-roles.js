require('dotenv').config();
const mysql = require('mysql2/promise');

async function fixRoles() {
  let conn;
  try {
    conn = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'zkteco'
    });

    console.log('Inserting missing roles...');
    
    // Insert missing roles
    await conn.query(`
      INSERT INTO PRY_Rol (IDRol, Descripcion, Restriccion, Activo) 
      VALUES 
        (2, 'Supervisor', 2, 1),
        (3, 'Usuario', 3, 1),
        (4, 'Visitante', 4, 1)
      ON DUPLICATE KEY UPDATE 
        Descripcion = VALUES(Descripcion),
        Restriccion = VALUES(Restriccion),
        Activo = 1
    `);

    // Verify roles
    const [rows] = await conn.query('SELECT * FROM PRY_Rol WHERE Activo = 1 ORDER BY IDRol');
    console.log('\nRoles in database:');
    console.table(rows);
    
    console.log('\n✅ Roles fixed successfully!');
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  } finally {
    if (conn) await conn.end();
  }
}

fixRoles();