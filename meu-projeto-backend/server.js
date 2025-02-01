// const express = require('express');
// const bodyParser = require('body-parser');
// const mercadopago = require('mercadopago');
// require('dotenv').config();

// const app = express();
// const PORT = process.env.PORT || 3001;

// // Configurar o access token do Mercado Pago vindo das variáveis de ambiente
// try {
//     mercadopago.configurations.configure({
//         access_token: process.env.MP_ACCESS_TOKEN
//     });
// } catch (error) {
//     console.error('Error setting Mercado Pago access token:', error);
//     process.exit(1); // Encerra o processo se não conseguir configurar o access token
// }

// app.use(bodyParser.json());

// // Endpoint para receber notificações do webhook
// app.post('/webhook', (req, res) => {
//     console.log('Webhook received:', req.body);

//     if (!req.body || Object.keys(req.body).length === 0) {
//         return res.status(400).send('Bad Request: Body is empty');
//     }

//     // Processar os dados do webhook aqui

//     res.status(200).send('Webhook received');
// });

// // Endpoint para criar uma preferência de pagamento
// app.post('/create_preference', async (req, res) => {
//     const preference = {
//         items: [
//             {
//                 title: 'Test Item',
//                 unit_price: Number(req.body.price),
//                 quantity: 1,
//             },
//         ],
//         back_urls: {
//             success: "https://ingles-ac531.web.app/#/register",
//             failure: "https://ingles-ac531.web.app/#/register",
//             pending: "https://ingles-ac531.web.app/#/register",
//         },
//         auto_return: "approved",
//         notification_url: "https://seu-domínio.com/webhook", // Substitua com o seu domínio correto
//     };

//     try {
//         const response = await mercadopago.preferences.create(preference);
//         res.json({ id: response.body.id });
//     } catch (error) {
//         console.error('Error creating preference:', error);
//         res.status(500).send('Internal Server Error');
//     }
// });

// app.listen(PORT, () => {
//     console.log(`Server is running on port ${PORT}`);
// });

// const express = require('express');
// const cors = require('cors');
// const mercadopago = require('mercadopago');
// const fetch = require('node-fetch'); // Ensure you have 'node-fetch' installed


// const client = new mercadopago.MercadoPagoConfig({
//     accessToken: 'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354',
// })

// const app = express();

// app.use(cors());
// app.use(express.json());

// app.get("/", (req, res) => {
//     res.send("Soy el server :)");
// });

// app.post("/create_preference", async (req, res) => {
//     try {
//         const body = {
//             items: [
//                 {
//                     title: req.body.title,
//                     quantity: Number(req.body.quantity),
//                     unit_price: Number(req.body.price),
//                     currency_id: "ARS",
//                 },
//             ],
//             back_urls: {
//                 success: "https://ingles-ac531.web.app/#/register",
//                 failure: "https://ingles-ac531.web.app/#/register",
//                 pending: "https://ingles-ac531.web.app/#/register",
//             },
//             auto_return: "approved",
//             notification_url: 'https://9cd4-2804-4364-ced4-3000-109c-71ef-a022-dc85.ngrok-free.app/webhook'
//         };

//         const preference = new Preference(client);
//         const result = await preference.create({ body });
//         res.json({
//             id: result.id,
//         });
//     } catch (error) {
//         console.error(error);
//         res.status(500).send("Server error");
//     }
// });

// // Code from the image
// app.post("/webhook", async function (req, res) {
//     const paymentId = req.query.id;

//     try {
//         const response = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
//             method: 'GET',
//             headers: {
//                 'Authorization': `Bearer ${client.accessToken}`
//             }
//         });

//         if (response.ok) {
//             const data = await response.json();
//             console.log(data);
//         }

//         res.sendStatus(200);
//     } catch (error) {
//         console.error('Error:', error);
//         res.sendStatus(500);
//     }
// });

// app.listen(3001, () => {
//     console.log("Server is running on port 3001");
// });


// const express = require('express');
// const cors = require('cors');
// const mercadopago = require('mercadopago');
// const fetch = require('node-fetch'); // Ensure you have 'node-fetch' installed


// const client = new mercadopago.MercadoPagoConfig({
//     accessToken: 'APP_USR-a99fcfec-7105-4fbc-a552-06d0b12efa80',
// })

// const app = express();

// app.use(cors());
// app.use(express.json());

// app.get("/", (req, res) => {
//     res.send("Soy el server :)");
// });

// app.post("/create_preference", async (req, res) => {
//     try {
//         const body = {
//             items: [
//                 {
//                     title: req.body.title,
//                     quantity: Number(req.body.quantity),
//                     unit_price: Number(req.body.price),
//                     currency_id: "ARS",
//                 },
//             ],
//             back_urls: {
//                 success: "https://ingles-ac531.web.app/redirect.html",
//                 failure: "https://ingles-ac531.web.app/redirect.html",
//                 pending: "https://ingles-ac531.web.app/redirect.html",
//             },
//             auto_return: "approved",
//             notification_url: 'https://9cd4-2804-4364-ced4-3000-109c-71ef-a022-dc85.ngrok-free.app/webhook'
//         };

//         const preference = new Preference(client);
//         const result = await preference.create({ body });
//         res.json({
//             id: result.id,
//         });
//     } catch (error) {
//         console.error(error);
//         res.status(500).send("Server error");
//     }
// });

// // Code from the image
// app.post("/webhook", async function (req, res) {
//     const paymentId = req.query.id;

//     try {
//         const response = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
//             method: 'GET',
//             headers: {
//                 'Authorization': `Bearer ${client.accessToken}`
//             }
//         });

//         if (response.ok) {
//             const data = await response.json();
//             console.log(data);

//             if (data.status === 'approved') {
                
//                  res.redirect('https://ingles-ac531.web.app/register');
//             } else {
//                 res.sendStatus(200);
//             }
//         } else {
//             res.sendStatus(500);
//         }
//     } catch (error) {
//         console.error('Error:', error);
//         res.sendStatus(500);
//     }
// });

// app.listen(3001, () => {
//     console.log("Server is running on port 3001");
// });


const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');

const app = express();
app.use(bodyParser.json());

app.post('/notificacoes', (req, res) => {
  const paymentInfo = req.body;

  // Verifique e processe a notificação de pagamento
  if (paymentInfo.type === 'payment') {
    const paymentId = paymentInfo.data.id;

    // Buscar detalhes do pagamento (opcional)
    // Enviar email personalizado ao comprador
    enviarEmail(paymentId);
  }

  res.sendStatus(200);
});

function enviarEmail(paymentId) {
  // Configurar transporte de email
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'julessbomfim@gmail.com',
      pass: 'Bomfimuni1'
    }
  });

  const mailOptions = {
    from: 'seuemail@gmail.com',
    to: 'emaildocomprador@example.com',
    subject: 'Confirmação de Pagamento',
    text: `Seu pagamento foi confirmado! Detalhes do pagamento: ${paymentId}. Informações adicionais...`
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      return console.log(error);
    }
    console.log('Email enviado: ' + info.response);
  });
}

app.listen(3000, () => {
  console.log('Servidor rodando na porta 3000');
});
