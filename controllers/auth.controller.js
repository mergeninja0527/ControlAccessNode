const { findOne, pool } = require('../database/database.js')
const Cryptojs = require("crypto-js")

const login = async (req, res) => {
  const { username, password } = req.body
  console.log(username, password)
  try {
    const user = await findOne("call spPRY_Usuarios_ObtenerPorID(?)", [username])
    if (!user)
      throw new Error("Usuario inválido.")
    const isMatch = String(Cryptojs.MD5(password)) === user.Passwd
    if (!isMatch)
      throw new Error("Contraseña inválida.")

    return res.json({ username: user.NombreUsuario, user: username, userrol: user.IDRol, passTemp: user.PassTemp[0] })
  } catch (err) {
    const { message } = err
    return res.status(403).json({ message })
  }
}

const password = async (req, res) => {
  const { username, password } = req.body
  try {
    const user = await findOne("call spPRY_Usuarios_ObtenerPorID(?)", [username])

    if (!user)
      throw new Error("Usuario no existe")

    const isMatch = String(Cryptojs.MD5(password)) === user.Passwd
    if (isMatch)
      throw new Error("Contraseña no puede ser igual a la anterior.")

    await pool.query("call spPRY_Usuarios_CambiarPass(?,?)", [username, password])

    return res.json({ username: user.NombreUsuario, userrol: user.IDRol, passTemp: user.PassTemp })
  } catch (err) {
    const { message } = err
    return res.status(403).json({ message })
  }
}

module.exports = {
  login,
  password
}