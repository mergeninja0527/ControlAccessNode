const { findMany, pool, exists } = require("../database/database")

const getData = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Sala_Listar();', [])
    const salas = salamapping(data);
    return res.status(200).json(salas)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const postData = async (req, res) => {
  try {
    const { idPiso, sala } = req.body

    await pool.query('call spPRY_Sala_Guardar(?,?);', [idPiso, sala]);

    const data = await findMany('call spPRY_Sala_Listar();', [])
    const salas = salamapping(data);

    return res.status(200).json({ message: "Sala guardado correctamente.", data: salas })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const patchData = async (req, res) => {
  try {
    const { idSala } = req.params
    const { idPiso, sala } = req.body

    await pool.query('call spPRY_Sala_Actualizar(?,?,?);', [idSala, idPiso, sala]);

    const data = await findMany('call spPRY_Sala_Listar();', [])
    const salas = salamapping(data);

    return res.status(200).json({ message: "Sala actualizado correctamente.", data: salas })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const deleteData = async (req, res) => {
  try {
    const { idSala } = req.params

    const existe = await exists('tbl_sala_puerta', `IDSala = ${idSala}`)

    if (existe)
      throw new Error("Sala se encuentra en uso.")

    await pool.query('call spPRY_Sala_Eliminar(?);', [idSala]);

    const data = await findMany('call spPRY_Sala_Listar();', [])
    const salas = salamapping(data);

    return res.status(200).json({ message: "Sala eliminado correctamente.", data: salas })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const salaSelect = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Sala_Listar();', []);
    const salas = data.map(({ IDSala, IDPiso, Sala }) => ({
      idPiso: IDPiso,
      value: IDSala,
      label: Sala
    }))

    return res.status(200).json(salas)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const salaFullSelect = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Sala_Listar();', []);
    const salas = data.map(({ IDSala, Edificio, Piso, Sala }) => ({
      value: IDSala,
      label: `${Edificio}-${Piso}${Sala}`
    }))

    return res.status(200).json(salas)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const salamapping = (datalist) => {
  return datalist.map(({ IDEdificio, Edificio, IDPiso, Piso, IDSala, Sala }) => ({
    idEdificio: IDEdificio,
    edificio: Edificio,
    idPiso: IDPiso,
    piso: Piso,
    idSala: IDSala,
    sala: Sala
  }))
}

module.exports = {
  getData,
  postData,
  patchData,
  deleteData,
  salaSelect,
  salaFullSelect
}