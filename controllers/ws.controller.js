const { findOne, pool, exists } = require("../database/database")

const findByRut = async (req, res) => {
  try {
    const { rut } = req.params;
    const data = await findOne('call spPRY_Usuario_ObtenerWS(?);', [rut])
    if (!data)
      return res.status(404).json({ message: "Usuario no encontrado" })

    const existe = await exists("tbl_huella", `IDUsuario = ${rut}`)

    if (existe) {
      return res.status(404).json({ message: "Usuario ya registrado." })
    }

    const usuario = {
      idUsuario: data.IDUsuario,
      nombre: data.NombreUsuario.split(" ")[0],
      apellido: data.NombreUsuario.split(" ")[1] ?? ""
    }
    return res.status(200).json(usuario)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const saveFingerprint = async (req, res) => {
  try {
    const { user_id, finger_id, fingerprint } = req.body;
    await pool.query('call spPRY_Huella_InsertarWS(?);', [user_id, finger_id, fingerprint])
    return res.status(200).json({ message: "Huella guardada correctamente.", ret: 1 })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

module.exports = {
  findByRut,
  saveFingerprint
}