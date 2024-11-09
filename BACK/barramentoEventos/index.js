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
        console.log("Tipo de evento recebido:", evento.tipo);

        switch (evento.tipo) {
            case 'UsuarioCriado':
                await axios.post('http://localhost:6001/eventos', evento); // Serviço de usuários
                break;

            case 'SolicitacaoLogin':
                await axios.post('http://localhost:6001/eventos', evento); // Serviço de pedidos
                break;

            case 'ResultadoLogin':
                await axios.post('http://localhost:5000/eventos', evento);
                break;

            case 'ReservaCriada':
                await axios.post('http://localhost:7001/eventos', evento); // Serviço de reservas
                break;

            case 'ConsultaReservas':
                const respostaConsulta = await axios.post('http://localhost:7001/eventos', evento);
                // console.log("Resposta do operador para ConsultaReservas:", respostaConsulta.data);
                res.status(200).send(respostaConsulta.data); // Retorna a resposta ao cliente
                return; // Termina para não responder duas vezes

            case 'ConsultaUserReservas': // Adiciona o caso para 'ConsultaUserReservas'
                const respostaUserReservas = await axios.post('http://localhost:7001/eventos', evento);
                // console.log("Resposta do operador para ConsultaUserReservas:", respostaUserReservas.data);
                res.status(200).send(respostaUserReservas.data); // Retorna a resposta ao cliente
                return;
                
            case 'ReservaCancelada':
                // Corrigido para passar `evento` em vez de `tipo` e `dados` separadamente
                const respostaCancelamento = await axios.post('http://localhost:7001/eventos', evento);
                console.log("Resposta do operador para ReservaCancelada:", respostaCancelamento.data);
                res.status(200).send(respostaCancelamento.data);
                return;

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
