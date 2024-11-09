const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

app.put('/consultaUserReservas', async (req, res) => {
    try {
        // Captura o e-mail do usuário do corpo da requisição
        const emailUsuario = req.body.email;
        if (!emailUsuario) {
            console.log("❄️ E-mail do usuário não fornecido na requisição ❄️");
            return res.status(400).send({ msg: "E-mail do usuário é obrigatório para consulta de reservas." });
        }

        console.log("❄️ Enviando consulta ao barramento com e-mail:", emailUsuario);
        
        // Cria o evento com o tipo e o e-mail do usuário
        const evento = { tipo: "ConsultaUserReservas", dados: { email: emailUsuario } };

        // Envia o evento para o barramento
        const resposta = await axios.post('http://localhost:10000/eventos', evento);

        // Log do conteúdo do evento recebido
        console.log("❄️ Resposta do barramento recebida:", resposta.data);

        // Envia a resposta ao cliente (JSON das reservas)
        res.status(200).send(resposta.data);
    } catch (error) {
        console.error("❄️ Erro ao consultar reservas:", error);
        res.status(500).send({ msg: "Erro ao consultar reservas" });
    }
});

app.listen(7003, () => {
    console.log("❄️ Microserviço de consulta de reservas do usuário. Porta 7003 ❄️");
});
