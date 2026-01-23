const { findMany, pool } = require("../database/database")

const getData = async (_, res) => {
  try {
    const data = await findMany('call spPRY_Ubicacion_Listar();', [])
    const ubicaciones = ubicacionmapping(data);
    return res.status(200).json(ubicaciones)
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const postData = async (req, res) => {
  try {
    const { idSala, sn, puerta } = req.body;

    await pool.query('call spPRY_Ubicacion_Guardar(?,?,?);', [idSala, sn, puerta]);

    const data = await findMany('call spPRY_Ubicacion_Listar();', [])
    const ubicaciones = ubicacionmapping(data);

    return res.status(200).json({ message: "Sala enlazada correctamente.", data: ubicaciones })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const deleteData = async (req, res) => {
  try {
    const { idPiso } = req.params

    await pool.query('call spPRY_Ubicacion_Eliminar(?);', [idPiso]);

    const data = await findMany('call spPRY_Ubicacion_Listar();', [])
    const ubicaciones = ubicacionmapping(data);

    return res.status(200).json({ message: "Ubicación eliminada correctamente.", data: ubicaciones })
  } catch ({ message }) {
    return res.status(403).json({ message })
  }
}

const ubicacionmapping = (datalist) => {
  return datalist.map(({ IDUbicacion, IDEdificio, Edificio, IDPiso, Piso,
    IDSala, Sala, SN, Puerta
  }) => ({
    idUbicacion: IDUbicacion,
    idEdificio: IDEdificio,
    edificio: Edificio,
    idPiso: IDPiso,
    piso: Piso,
    idSala: IDSala,
    sala: Sala,
    sn: SN,
    puerta: Puerta
  }))
}

module.exports = {
  getData,
  postData,
  deleteData
}