const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const app = express();
const cors = require('cors');

app.use(bodyParser.json());
app.use(cors());
contador = 0;

let baseLocal = {};

// Endpoint para Solicitação de Login
app.put("/SolicitacaoLogin", async (req, res) => {
    contador++;
    const { email, senha } = req.body;

    // Salva os dados da solicitação localmente
    baseLocal[contador] = {
        email,
        senha
    };

    // Evento de Solicitação de Login para o barramento de eventos
    const evento = {
        tipo: "SolicitacaoLogin",
        dados: {
            email: email,
            senha: senha
        }
    };

    try {
        // Envia o evento para o barramento (caso o barramento esteja ativo)
        await axios.post('http://localhost:10000/eventos', evento);
        console.log(`Solicitação de Login enviada com sucesso para o barramento. Usuário: ${email}`);
        res.status(201).send({ msg: "Solicitação de Login enviada.", usuario: baseLocal[contador] });
    } catch (error) {
        console.error("Erro ao enviar Solicitação de Login para o barramento:", error.message);
        res.status(500).send({ msg: "Erro ao enviar Solicitação de Login para o barramento" });
    }
});

// Endpoint para receber eventos (se necessário)
app.post("/eventos", (req, res) => {
    console.log("Evento recebido:", req.body);
    res.status(200).send({ msg: "Evento processado com sucesso" });
});

app.listen(5000, () => {
    console.log('Microserviço de criação de usuários rodando na porta 5000.');
});
