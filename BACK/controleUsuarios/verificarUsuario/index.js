const express = require ('express');

const axios = require('axios');
const bodyParser = require('body-parser');
const app = express();
const cors = require('cors');


app.use(bodyParser.json());
app.use(cors());
contador = 0;


let baseLocal = {};

// Endpoint para criar usuário
app.put("/SolicitacaoLogin", async (req, res) => {
    contador++;
    const {email, senha } = req.body;

    // Salva os dados localmente
    baseLocal[contador] = {
        email,
        senha
    };

    // Evento de criação de usuário para um barramento de eventos
    const evento = {
        tipo: "SolicitacaoLogin",
        dados: {
            email: email,
            senha: senha
        }
    };

    // ++ Tratativa para erros no envio do barramento
    try {
        // Envia o evento para o barramento (caso o barramento esteja ativo)
        await axios.post('http://localhost:10000/eventos', evento);
        res.status(201).send({ msg: "Solicitação de Login.", usuario: baseLocal[contador] });
    } catch (error) {
        console.error("Erro ao enviar Solicitação de Login para o barramento:", error);
        res.status(500).send({ msg: "Erro ao enviar Solicitação de Login para o barramento" });
    }
});

// app.post("/eventos", (req,res) => {
//     console.log(req.body);
//     res.status(200).send({msg:"ok"});
// })

app.listen(5000, () => {
    console.log('Microserviço de criação de usuários, porta 5000.')
})