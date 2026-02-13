const { findMany, pool, findOne } = require("../database/database")
const { getRandomNumericString } = require("../utils/Functions")
const { sendMail } = require("./mail.controller")

const getUsers = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Usuario_Listar();', [])
    const usuarios = data.map(({ IDUsuario, NombreUsuario, CorreoElectronico, Telefono, IDRol, Rol, IDAcceso }) => ({
      idUsuario: IDUsuario,
      nombreUsuario: NombreUsuario,
      correoElectronico: CorreoElectronico,
      telefono: Telefono,
      idRol: IDRol,
      rol: Rol,
      idAcceso: IDAcceso
    }))
    return res.status(200).json(usuarios)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const getRolesSelect = async (req, res) => {
  try {
    const { idUsuario } = req.params
    const data = await findMany('call spPRY_Rol_Select(?);', [idUsuario])
    const usuarios = data.map(({ Restriccion, Descripcion }) => ({
      value: Restriccion,
      label: Descripcion
    }))
    return res.status(200).json(usuarios)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

// Map role to tbl_usuarios IDRol (varchar 3: SAD, ADM, PRO, ENC, OFC, RES, VIS)
const mapRoleToCode = (idRolOrRol) => {
  if (idRolOrRol == null || idRolOrRol === '') return 'RES'
  const s = String(idRolOrRol).toUpperCase()
  if (['SAD', 'ADM', 'PRO', 'ENC', 'OFC', 'RES', 'VIS'].includes(s)) return s
  if (s === '1') return 'ADM'
  if (s === '2') return 'RES'
  return 'RES'
}

const postData = async (req, res) => {
  try {
    const { rut, nombre, correo, telefono, idRol, rol, password: bodyPassword } = req.body

    // tbl_usuarios: spPRY_Usuario_Guardar(prut, pname, ppass, pemail, ptelefono, prol) - 6 params
    let password = bodyPassword && String(bodyPassword).trim() !== '' ? String(bodyPassword).trim() : null
    if (!password) {
      const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ'
      const lower = 'abcdefghjkmnpqrstuvwxyz'
      const digits = '23456789'
      const symbols = '!@#$%&*'
      const all = upper + lower + digits + symbols
      let gen = ''
      gen += upper[Math.floor(Math.random() * upper.length)]
      gen += lower[Math.floor(Math.random() * lower.length)]
      gen += digits[Math.floor(Math.random() * digits.length)]
      gen += symbols[Math.floor(Math.random() * symbols.length)]
      for (let i = 0; i < 10; i++) gen += all[Math.floor(Math.random() * all.length)]
      password = gen.split('').sort(() => Math.random() - 0.5).join('')
    }
    const rolCode = mapRoleToCode(rol != null ? rol : idRol)
    const telefonoInt = parseInt(telefono, 10) || 0

    await pool.query('call spPRY_Usuario_Guardar(?,?,?,?,?,?);', [rut, nombre, password, correo, telefonoInt, rolCode])

    const mailOptions = {
      from: `"Control De Acceso" <${process.env.EMAIL_USER}>`,
      to: `${correo}`,
      subject: `Registro en aplicación - Credenciales de acceso`,
      html: `
        <h3>Credenciales de acceso</h3>
        <p><strong>Usuario (RUT):</strong> ${rut}</p>
        <p><strong>Nombre:</strong> ${nombre}</p>
        <p><strong>Contraseña:</strong> ${password}</p>
        <p>Guarde esta contraseña en un lugar seguro. Inicie sesión con su RUT y esta contraseña.</p>
      `
    };

    await sendMail(mailOptions);

    const data = await findMany('call spPRY_Usuario_Listar();', [])
    const usuarios = data.map(({ IDUsuario, NombreUsuario, CorreoElectronico, Telefono, IDRol, Rol, IDAcceso }) => ({
      idUsuario: IDUsuario,
      nombreUsuario: NombreUsuario,
      correoElectronico: CorreoElectronico,
      telefono: Telefono,
      idRol: IDRol,
      rol: Rol,
      idAcceso: IDAcceso
    }))
    return res.status(200).json({ message: "Usuario agregado exitosamente.", data: usuarios })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const postEnlace = async (req, res) => {
  try {
    const { rut, fechaInicio, fechaFin, sala } = req.body
    let { codigo } = req.body

    const ids = await findMany("call spPRY_IDAcceso_Listar();", []);
    if (!codigo || codigo === "") {
      do {
        codigo = getRandomNumericString(10)
      } while (ids.some(item => item["IDAcceso"] === codigo));
    }

    const payload = {
      codigo,
      fechaInicio,
      fechaFin,
      sala,
      isCard: true
    }

    await pool.query('call spPRY_Usuario_AgregarEnlace(?,?,?);', [codigo, rut, JSON.stringify(payload)])

    return res.status(200).json({ message: "Usuario enlazado exitosamente." })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const getEnlace = async (req, res) => {
  try {
    const { idUsuario } = req.params
    const data = await findOne('call spPRY_Usuario_Enlace_Listar(?);', [idUsuario])
    const payload = JSON.parse(data.Payload)
    const acceso = {
      idAcceso: data.IDAcceso,
      idUsuario: data.IDUsuario,
      fechaInicio: payload.fechaInicio,
      fechaFin: payload.fechaFin,
      idSala: payload.sala,
    }
    return res.status(200).json(acceso)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}


const deleteData = async (req, res) => {
  try {
    const { idUsuario } = req.params

    await pool.query('call spPRY_Usuario_Eliminar(?);', [idUsuario])

    const data = await findMany('call spPRY_Usuario_Listar();', [])
    const usuarios = data.map(({ IDUsuario, NombreUsuario, CorreoElectronico, Telefono, IDRol, Rol, IDAcceso }) => ({
      idUsuario: IDUsuario,
      nombreUsuario: NombreUsuario,
      correoElectronico: CorreoElectronico,
      telefono: Telefono,
      idRol: IDRol,
      rol: Rol,
      idAcceso: IDAcceso
    }))
    return res.status(200).json({ message: "Usuario eliminado exitosamente.", data: usuarios })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

module.exports = {
  getUsers,
  getRolesSelect,
  deleteData,
  postData,
  postEnlace,
  getEnlace
}