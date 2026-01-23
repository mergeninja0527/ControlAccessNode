const mysql = require('mysql2')

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: atob(process.env.DB_PASS),
  database: process.env.DB_DABS,
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
  const [results] = await pool.query(sql, values)
  const result = results[0]
  return result
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