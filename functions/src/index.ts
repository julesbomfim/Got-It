/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import axios from 'axios';

admin.initializeApp();

const ACCESS_TOKEN = 'TEST-393368402860510-072715-9e3e5831d8429e0ffd8f026fe8d4d394-593363354'; // Substitua pelo seu Access Token do Mercado Pago

export const createPayment = functions.https.onRequest(async (req, res) => {
  const { transaction_amount, description, email } = req.body;

  try {
    const response = await axios.post('https://api.mercadopago.com/v1/payments', {
      transaction_amount: transaction_amount,
      description: description,
      payment_method_id: 'pix',
      payer: {
        email: email,
      },
    }, {
      headers: {
        Authorization: `Bearer ${ACCESS_TOKEN}`,
        'Content-Type': 'application/json',
      },
    });

    res.status(200).send(response.data);
  } catch (error: any) {
    console.error('Erro ao criar pagamento:', error);
    res.status(500).send(error.response ? error.response.data : error.message);
  }
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
