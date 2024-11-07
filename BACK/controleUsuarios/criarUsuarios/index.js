const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const app = express();
const cors = require('cors');

app.use(bodyParser.json());
app.use(cors());
contador = 0;

let baseLocal = {};

// Endpoint para criar usuário
app.put("/criarUsuario", async (req, res) => {
    contador++;
    const { nome, celular, email, senha } = req.body;

    // Salva os dados localmente
    baseLocal[contador] = {
        id: contador,
        nome,
        celular,
        email,
        senha
    };

    // Evento de criação de usuário para um barramento de eventos
    const evento = {
        tipo: "UsuarioCriado",
        dados: {
            id: contador,
            nome: nome,
            celular: celular,
            email: email,
            senha: senha
        }
    };

    // ++ Tratativa para erros no envio do barramento
    // try {
        // Envia o evento para o barramento (caso o barramento esteja ativo)
        await axios.post('http://localhost:10000/eventos', evento);
        res.status(201).send({ msg: "Usuário criado e evento enviado ao barramento", usuario: baseLocal[contador] });
    // } catch (error) {
    //     console.error("Erro ao enviar evento para o barramento:", error);
    //     res.status(500).send({ msg: "Erro ao enviar evento para o barramento" });
    // }
});

app.listen(4000, () => {
    console.log('Servidor de criação de usuários rodando na porta 4000');
});
