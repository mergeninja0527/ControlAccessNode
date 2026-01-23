const { findMany, pool, exists } = require("../database/database")

const getData = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Piso_Listar();', [])
    const pisos = pisomapping(data);
    return res.status(200).json(pisos)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const postData = async (req, res) => {
  try {
    const { idEdificio, piso } = req.body

    await pool.query('call spPRY_Piso_Guardar(?,?);', [idEdificio, piso]);

    const data = await findMany('call spPRY_Piso_Listar();', [])
    const pisos = pisomapping(data);

    return res.status(200).json({ message: "Piso guardado correctamente.", data: pisos })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const patchData = async (req, res) => {
  try {
    const { idPiso } = req.params
    const { idEdificio, piso } = req.body

    await pool.query('call spPRY_Piso_Actualizar(?,?,?);', [idPiso, idEdificio, piso]);

    const data = await findMany('call spPRY_Piso_Listar();', [])
    const pisos = pisomapping(data);

    return res.status(200).json({ message: "Piso actualizado correctamente.", data: pisos })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const deleteData = async (req, res) => {
  try {
    const { idPiso } = req.params

    const existe = await exists('tbl_sala', `IDPiso = ${idPiso}`)

    if (existe)
      throw new Error("Piso se encuentra en uso.")

    await pool.query('call spPRY_Piso_Eliminar(?);', [idPiso]);

    const data = await findMany('call spPRY_Piso_Listar();', [])
    const pisos = pisomapping(data);

    return res.status(200).json({ message: "Piso eliminado correctamente.", data: pisos })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const pisoSelect = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Piso_Listar();', []);
    const pisos = data.map(({ IDPiso, IDEdificio, Piso }) => ({
      idEdificio: IDEdificio,
      value: IDPiso,
      label: Piso
    }))
    return res.status(200).json(pisos)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const pisomapping = (datalist) => {
  return datalist.map(({ IDPiso, IDEdificio, Edificio, Piso }) => ({
    idPiso: IDPiso,
    idEdificio: IDEdificio,
    edificio: Edificio,
    piso: Piso
  }))
}

module.exports = {
  getData,
  postData,
  patchData,
  deleteData,
  pisoSelect
}