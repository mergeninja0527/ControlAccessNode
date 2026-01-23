const nodemailer = require("nodemailer");

// const mailOptions = {
//   from: `"Contacto Siga Systems" <${process.env.EMAIL_USER}>`,
//   to: `${process.env.EMAIL_USER}`,
//   subject: `${asunto}`,
//   html: `
//       <h3>Nueva Información de Contacto</h3>
//       <p><strong>Nombre:</strong> ${nombre}</p>
//       <p><strong>Mail:</strong> ${mail}</p>
//       <p><strong>Mensaje:</strong></p>
//       <p>${mensaje}</p>
//   `
// };

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_APP_PASSWORD,
  }
})

const sendMail = async (mailOptions) => {
  await transporter.sendMail(mailOptions)
}

module.exports = { sendMail }