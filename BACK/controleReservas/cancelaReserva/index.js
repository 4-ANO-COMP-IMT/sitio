const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

app.post('/cancelarReserva', async (req, res) => {
    const { id } = req.body;

    if (!id) {
        return res.status(400).send({ msg: "ID da reserva é obrigatório para cancelamento." });
    }

    try {
        // Envia o evento de cancelamento para o barramento
        const evento = { tipo: "ReservaCancelada", dados: { id } };
        await axios.post('http://localhost:10000/eventos', evento);
        console.log(`❄️ Evento de cancelamento enviado para o barramento com ID ${id} ❄️`);
        console.log("❄️ Retorno do barramento:", respostaBarramento.data); // Print do retorno do barramento


        res.status(200).send({ msg: `Pedido de cancelamento enviado para o barramento para a reserva ${id}.` });
    } catch (error) {
        console.error("Erro ao enviar evento de cancelamento ao barramento:", error.message);
        res.status(500).send({ msg: "Erro ao processar o cancelamento da reserva." });
    }
});

app.listen(7004, () => console.log("Serviço de cancelamento de reservas. Porta 7004 ❄️"));
