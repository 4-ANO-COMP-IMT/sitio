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
        console.log("", evento.tipo);
        // Determina o tipo de evento e envia para endpoints específicos
        switch (evento.tipo) {
            case 'UsuarioCriado':
                await axios.post('http://localhost:6001/eventos', evento); // Serviço de usuários

                break;

            case 'SolicitacaoLogin':
                await axios.post('http://localhost:6001/eventos', evento); // Serviço de pedidos
                break;

            case 'ResultadoLogin':
                // Redireciona o resultado do login para o microserviço de login
                await axios.post('http://localhost:5000/eventos', evento);
                break;

            case 'ReservaCriada':
                await axios.post('http://localhost:7001/eventos', evento); // Serviço de pedidos
                break;
            
            // Caso de consulta de reservas
            case 'ConsultaReservas':
                const resposta = await axios.post('http://localhost:7001/eventos', evento);
                console.log("Resposta do OperadorBase para ConsultaReservas:", resposta.data);
                res.status(200).send(resposta.data); // Retorna a resposta ao consultaTodasReservas
                return; // Finaliza o processamento para não enviar outra resposta
                        

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