const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(bodyParser.json());
app.use(cors());

app.post('/eventos', async (req, res) => {
    const evento = req.body;

    try {
        // Determina o tipo de evento e envia para endpoints específicos
        switch (evento.tipo) {
            case 'UsuarioCriado':
                await axios.post('http://localhost:6001/eventos', evento); // Serviço de usuários
                break;

            case 'SolicitacaoLogin':
                await axios.post('http://localhost:6001/eventos', evento); // Serviço de pedidos
                break;

            // case 'PagamentoProcessado':
            //     await axios.post('http://localhost:6001/eventos', evento); // Serviço de pagamentos
            //     break;

            default:
                console.log("Tipo de evento desconhecido:", evento.tipo);
        }

        res.status(200).send({ msg: "Evento processado com sucesso" });
    } catch (error) {
        console.error("Erro ao processar evento:", error);
        res.status(500).send({ msg: "Erro ao processar evento" });
    }
});

app.listen(10000, () => {
    console.log("Barramento de eventos. Porta 10000.");
});
