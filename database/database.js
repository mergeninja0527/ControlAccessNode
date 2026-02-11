const mysql = require('mysql2')

function getDbPassword() {
  const raw = process.env.DB_PASS
  if (!raw) return ''
  try {
    return atob(raw.trim())
  } catch {
    return raw // Plain text password if not valid base64
  }
}

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: getDbPassword(),
  database: process.env.DB_DABS || 'zkteco',
  // multipleStatements:true
}).promise()

const exists = async (table, comparisson) => {
  const [[{ existe }]] = await pool.query(`SELECT COUNT(*) AS existe FROM ${table} WHERE ${comparisson};`)

  return existe === 0 ? false : true
}

/**
 * 
 * @param {string} sql - consulta
 * @param {array} values - parametros de búsqueda
 * @returns {object} objeto con los datos de la consulta
 */
const findOne = async (sql, values) => {
  const [results] = await pool.query(sql, values)
  const result = results[0][0]
  return result
}

const findMany = async (sql, values) => {
  const [raw] = await pool.query(sql, values)
  // For CALL, mysql2 may return [ rowsArray, fieldsOrOkPacket ]; unwrap so we return the actual rows
  let rows = raw
  if (Array.isArray(raw) && raw.length > 0) {
    const first = raw[0]
    if (Array.isArray(first) && first.length > 0 && typeof first[0] === 'object' && first[0] !== null && !Array.isArray(first[0])) {
      rows = first
    }
  }
  return Array.isArray(rows) ? rows : (rows ? [rows] : [])
}

const executeSql = async (sql) => {
  const [results] = await pool.query(sql)
  const result = results[0]
  return result
}

const addReqToLog = async (funcion, linea, req) => {
  await pool.query('call spPRY_Log_Guardar(?,?,?); ', [funcion, linea, req])
}

module.exports = {
  pool,
  exists,
  findOne,
  findMany,
  executeSql,
  addReqToLog
}