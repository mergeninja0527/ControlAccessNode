const { findOne } = require('../database/database.js')

const login = async (req, res) => {
  const { username: rawUsername, fullName } = req.body
  const username = rawUsername ? String(rawUsername).replace(/\./g, '').trim() : ''
  const fullNameVal = (fullName || '').trim()

  try {
    if (!username)
      throw new Error("username (RUT) es requerido.")
    if (!fullNameVal)
      throw new Error("fullName es requerido.")

    const user = await findOne("call spPRY_Usuarios_ObtenerPorID(?)", [username])
    if (!user)
      throw new Error("Usuario inválido.")

    const nameMatch = fullNameVal.toLowerCase() === (user.NombreUsuario || '').toLowerCase()
    if (!nameMatch)
      throw new Error("Nombre completo no coincide.")

    const passTemp = user.PassTemp && user.PassTemp[0] !== undefined ? user.PassTemp[0] : 0
    return res.json({ username: user.NombreUsuario, user: username, userrol: user.IDRol, passTemp })
  } catch (err) {
    const { message } = err
    return res.status(403).json({ message })
  }
}

module.exports = {
  login
}