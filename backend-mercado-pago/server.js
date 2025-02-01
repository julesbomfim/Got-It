const express = require('express');
const bodyParser = require('body-parser');
const mercadopago = require('mercadopago');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Configurar o access token do Mercado Pago vindo das variáveis de ambiente
mercadopago.configurations.setAccessToken(process.env.MP_ACCESS_TOKEN);

app.use(bodyParser.json());

// Endpoint para receber notificações do webhook
app.post('/webhook', (req, res) => {
    console.log('Webhook received:', req.body);

    if (!req.body || Object.keys(req.body).length === 0) {
        return res.status(400).send('Bad Request: Body is empty');
    }

    // Processar os dados do webhook aqui

    res.status(200).send('Webhook received');
});

// Endpoint para criar uma preferência de pagamento
app.post('/create_preference', async (req, res) => {
    const preference = {
        items: [
            {
                title: 'Test Item',
                unit_price: Number(req.body.price),
                quantity: 1,
            },
        ],
        back_urls: {
            success: "https://ingles-ac531.web.app/#/register",
            failure: "https://ingles-ac531.web.app/#/register",
            pending: "https://ingles-ac531.web.app/#/register",
        },
        auto_return: "approved",
        notification_url: "https://seu-domínio.com/webhook", // Substitua com o seu domínio correto
    };

    try {
        const response = await mercadopago.preferences.create(preference);
        res.json({ id: response.body.id });
    } catch (error) {
        console.error('Error creating preference:', error);
        res.status(500).send('Internal Server Error');
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
