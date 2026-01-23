// const { Client, LocalAuth } = require("whatsapp-web.js")
// const { image: imageQR } = require("qr-image")
// const fs = require("fs")

// const client = new Client({
//   authStrategy: new LocalAuth({
//     clientID: 'client-one',
//     dataPath: './bot_sessions'
//   }),
//   puppeteer: {
//     headless: true,
//     args: ['--no-sandbox', '--disable-setuid-sandbox'],
//   }
// })

// client.on('qr', (qr) => {
//   if (qr.startsWith("undefined")) return
//   imageQR(qr).pipe(fs.createWriteStream('./images/qr.png'))
//   console.log("QR Generado")
// })

// client.on('ready', () => {
//   console.log("Cliente Listo")
// })

// client.on('message', msg => {
//   if (msg.body === "!ping") {
//     msg.reply("pong")
//   }
// })

// client.on("auth_failure", msg => {
//   console.log("Autentificación Fallida: ", msg);
// })

// module.exports = { client }