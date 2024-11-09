// loginService.js
const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();

app.use(bodyParser.json());
app.use(cors());
contador = 0;

let baseLocal = {};
let respostaLogin = {}; // Armazena a resposta para cada solicitação de login

// Endpoint para Solicitação de Login
app.put("/SolicitacaoLogin", async (req, res) => {
    contador++;
    const { email, senha } = req.body;

    // Salva os dados da solicitação localmente
    baseLocal[contador] = { email, senha };

    // Cria um evento para solicitação de login
    const evento = {
        tipo: "SolicitacaoLogin",
        dados: { email, senha, contador }
    };

    try {
        await axios.post('http://localhost:10000/eventos', evento);
        console.log(`Solicitação de Login enviada para o barramento. Usuário: ${email}`);

        // Escuta para a resposta do microserviço de base de dados
        respostaLogin[contador] = res;
    } catch (error) {
        console.error("Erro ao enviar Solicitação de Login para o barramento:", error.message);
        res.status(500).send({ msg: "Erro ao enviar Solicitação de Login" });
    }
});

// Recebe a resposta do microserviço de base de dados
app.post("/eventos", (req, res) => {
    const { tipo, dados } = req.body;

    if (tipo === "ResultadoLogin") {
        const { contador, status, mensagem } = dados;

        if (respostaLogin[contador]) {
            respostaLogin[contador].status(status === "sucesso" ? 200 : 401).send({ mensagem });
            delete respostaLogin[contador]; // Remove a referência após enviar a resposta
        }
    }

    res.status(200).send({ msg: "Evento processado com sucesso" });
});

app.listen(5000, () => {
    console.log('Microserviço de login rodando na porta 5000.');
});
