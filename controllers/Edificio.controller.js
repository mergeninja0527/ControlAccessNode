const { findMany, pool, exists } = require("../database/database")

const getData = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Edificio_Listar();', [])
    const edificios = edificiomapping(data);
    return res.status(200).json(edificios)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const postData = async (req, res) => {
  try {
    const { edificio } = req.body

    await pool.query('call spPRY_Edificio_Guardar(?);', [edificio]);

    const data = await findMany('call spPRY_Edificio_Listar();', [])
    const edificios = edificiomapping(data);

    return res.status(200).json({ message: "Edificio guardado correctamente.", data: edificios })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const patchData = async (req, res) => {
  try {
    const { idEdificio } = req.params
    const { edificio } = req.body

    await pool.query('call spPRY_Edificio_Actualizar(?,?);', [idEdificio, edificio]);

    const data = await findMany('call spPRY_Edificio_Listar();', [])
    const edificios = edificiomapping(data);

    return res.status(200).json({ message: "Edificio actualizado correctamente.", data: edificios })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const deleteData = async (req, res) => {
  try {
    const { idEdificio } = req.params

    const existe = await exists('tbl_piso', `IDEdificio = ${idEdificio}`)

    if(existe)
      throw new Error("Edificio se encuentra en uso.")

    await pool.query('call spPRY_Edificio_Eliminar(?);', [idEdificio]);

    const data = await findMany('call spPRY_Edificio_Listar();', [])
    const edificios = edificiomapping(data);

    return res.status(200).json({ message: "Edificio eliminado correctamente.", data: edificios })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const edificioSelect = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Edificio_Listar();', [])
    const edificios = data.map(({ IDEdificio, Edificio }) => ({
      value: IDEdificio,
      label: Edificio
    }))
    return res.status(200).json(edificios)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const edificiomapping = (datalist) => {
  return datalist.map(({ IDEdificio, Edificio }) => ({
    idEdificio: IDEdificio,
    edificio: Edificio
  }))
}

module.exports = {
  getData,
  postData,
  patchData,
  deleteData,
  edificioSelect,
}