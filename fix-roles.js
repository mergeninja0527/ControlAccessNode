require('dotenv').config();
const mysql = require('mysql2/promise');

async function fixRoles() {
  let conn;
  try {
    conn = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASS ? (() => { try { return atob(process.env.DB_PASS); } catch { return process.env.DB_PASS || ''; } })() : '',
      database: process.env.DB_DABS || 'zkteco'
    });

    console.log('Migrating to 2-role schema (Administrador, Residente)...');

    // Migrate existing users: Supervisor (2), Residente (3), Personal (4) -> Residente (2)
    const [userResult] = await conn.query(`
      UPDATE PRY_Usuarios SET IDRol = 2 WHERE IDRol IN (2, 3, 4) AND Activo = 1
    `);
    console.log(`  - Migrated ${userResult.affectedRows} users to Residente`);

    // Update role 2 to Residente, ensure role 1 is Administrador
    await conn.query(`
      INSERT INTO PRY_Rol (IDRol, Descripcion, Restriccion) VALUES 
        (1, 'Administrador', 1),
        (2, 'Residente', 2)
      ON DUPLICATE KEY UPDATE Descripcion = VALUES(Descripcion), Restriccion = VALUES(Restriccion)
    `);

    // Remove old roles 3 and 4
    await conn.query(`DELETE FROM PRY_Rol WHERE IDRol IN (3, 4)`).catch(() => {});

    // Verify roles
    const [rows] = await conn.query('SELECT * FROM PRY_Rol WHERE Activo = 1 ORDER BY IDRol');
    console.log('\nRoles in database:');
    console.table(rows);

    console.log('\n✅ Roles migrated successfully!');
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  } finally {
    if (conn) await conn.end();
  }
}

fixRoles();
