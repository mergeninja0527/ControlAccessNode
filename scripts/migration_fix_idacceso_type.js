/**
 * Migration: Fix IDAcceso Type Mismatch
 * 
 * Issue: IDAcceso is bigint but code generates/uses VARCHAR strings
 * Fix: Change IDAcceso to VARCHAR(50) to match code expectations
 * 
 * This migration is idempotent - safe to run multiple times
 */

const { pool } = require('../database/database');

async function checkColumnType() {
  try {
    const [rows] = await pool.query(`
      SELECT COLUMN_TYPE 
      FROM INFORMATION_SCHEMA.COLUMNS 
      WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'tbl_acceso' 
        AND COLUMN_NAME = 'IDAcceso'
    `);
    
    if (rows && rows.length > 0) {
      return rows[0].COLUMN_TYPE;
    }
    return null;
  } catch (error) {
    console.error('[Migration] Error checking column type:', error.message);
    return null;
  }
}

async function runMigration() {
  console.log('\n[Migration] Starting IDAcceso type fix migration...');
  
  try {
    // Check if table exists
    const [tables] = await pool.query(`
      SELECT TABLE_NAME 
      FROM INFORMATION_SCHEMA.TABLES 
      WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'tbl_acceso'
    `);
    
    if (!tables || tables.length === 0) {
      console.log('[Migration] Table tbl_acceso does not exist, skipping migration.');
      return { success: true, skipped: true, reason: 'Table does not exist' };
    }

    // Check current column type
    const currentType = await checkColumnType();
    console.log(`[Migration] Current IDAcceso type: ${currentType || 'NOT FOUND'}`);

    // Activo is stored in Payload JSON (payload.activo), not as a table column.

    // Check if already VARCHAR (but still update stored procedures)
    if (currentType && currentType.toUpperCase().includes('VARCHAR')) {
      console.log('[Migration] IDAcceso is already VARCHAR, skipping type conversion.');
      // Don't return early - we still need to update stored procedures
    } else if (currentType && currentType.toUpperCase().includes('BIGINT')) {
      // Check if column is bigint (needs migration)
      console.log('[Migration] IDAcceso is bigint, converting to VARCHAR(50)...');
      
      // Change column type to VARCHAR(50)
      await pool.query(`
        ALTER TABLE tbl_acceso 
        MODIFY COLUMN IDAcceso VARCHAR(50) NOT NULL
      `);
      
      console.log('[Migration] ✓ Column type changed to VARCHAR(50)');
    } else if (!currentType) {
      console.log('[Migration] IDAcceso column not found, skipping.');
      return { success: true, skipped: true, reason: 'Column not found' };
    } else {
      console.log(`[Migration] IDAcceso type is ${currentType}, no type conversion needed.`);
      // Still update stored procedures
    }

    // Update stored procedures: filter by Payload.activo (JSON), not table column.
    // Treat missing activo in Payload as active (1) for backward compatibility.
    console.log('[Migration] Updating stored procedures (activo from Payload JSON)...');

    const activoFromPayload = `(JSON_EXTRACT(Payload, '$.activo') IS NULL OR JSON_EXTRACT(Payload, '$.activo') = 1)`;

    try {
      await pool.query(`DROP PROCEDURE IF EXISTS spPRY_IDAcceso_Listar`);
      await pool.query(`
        CREATE PROCEDURE spPRY_IDAcceso_Listar()
        BEGIN
          SELECT CAST(IDAcceso AS CHAR(50)) AS IDAcceso
          FROM tbl_acceso
          WHERE ${activoFromPayload};
        END
      `);
      console.log('[Migration] ✓ Updated spPRY_IDAcceso_Listar');
    } catch (procError) {
      console.warn('[Migration] Warning updating spPRY_IDAcceso_Listar:', procError.message);
    }

    try {
      await pool.query(`DROP PROCEDURE IF EXISTS spPRY_Acceso_ObtenerPorAcceso`);
      await pool.query(`
        CREATE PROCEDURE spPRY_Acceso_ObtenerPorAcceso(IN p_IDAcceso VARCHAR(50))
        BEGIN
          SELECT
            a.IDAcceso,
            a.IDUsuario,
            a.Payload,
            u.NombreUsuario
          FROM tbl_acceso a
          LEFT JOIN tbl_usuarios u ON a.IDUsuario = u.IDUsuario
          WHERE a.IDAcceso = p_IDAcceso AND ${activoFromPayload};
        END
      `);
      console.log('[Migration] ✓ Updated spPRY_Acceso_ObtenerPorAcceso');
    } catch (procError) {
      console.warn('[Migration] Warning updating spPRY_Acceso_ObtenerPorAcceso:', procError.message);
    }

    // Verify the change
    const newType = await checkColumnType();
    console.log(`[Migration] Verification - New IDAcceso type: ${newType || 'NOT FOUND'}`);

    if (newType && newType.toUpperCase().includes('VARCHAR')) {
      console.log('[Migration] ✓ Migration completed successfully!\n');
      return { success: true, skipped: false, newType };
    } else {
      console.error('[Migration] ✗ Migration may have failed - column type is:', newType);
      return { success: false, skipped: false, error: 'Type verification failed' };
    }

  } catch (error) {
    const msg = error.message || '';
    const code = error.code || error.errno || '';
    console.error('[Migration] ✗ Migration failed:', msg);
    if (code) console.error('[Migration] Code:', code);
    if (error.sqlMessage) console.error('[Migration] SQL:', error.sqlMessage);
    if (code === 'EACCES' || code === 'ECONNREFUSED') {
      console.error('[Migration] Tip: Check DB credentials in .env and that MySQL is running.');
    }
    return { success: false, skipped: false, error: msg };
  }
}

// If run directly (node migration_fix_idacceso_type.js), execute migration
if (require.main === module) {
  runMigration()
    .then(result => {
      if (result.success) {
        process.exit(0);
      } else {
        process.exit(1);
      }
    })
    .catch(error => {
      console.error('[Migration] Fatal error:', error);
      process.exit(1);
    });
}

module.exports = { runMigration, checkColumnType };
