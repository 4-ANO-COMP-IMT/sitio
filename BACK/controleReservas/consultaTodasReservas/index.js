const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

app.put('/consultaTodasReservas', async (req, res) => {
    try {
        // Envia um evento de consulta para o barramento
        const evento = { tipo: "ConsultaReservas", dados: {} };
        const resposta = await axios.post('http://localhost:10000/eventos', evento);
        console.log("Enviada consulta para Barramento");

        // Log do conteúdo do evento recebido
        console.log("Evento recebido do barramento:", resposta.data);

        // Envia a resposta ao cliente (JSON das reservas)
        res.status(200).send(resposta.data);
    } catch (error) {
        console.error("Erro ao consultar reservas:", error);
        res.status(500).send({ msg: "Erro ao consultar reservas" });
    }
});



app.listen(7002, () => {
    console.log("Microserviço de consulta de todas as reservas. Porta 7002.");
});
