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
app.put("/criarReserva", async (req, res) => {
    contador++;
    const { email, capsula, data, horario} = req.body;

    // Salva os dados localmente
    baseLocal[contador] = {
        id: contador,
        email,
        capsula,
        data,
        horario,

    };

    // Evento de criação de usuário para um barramento de eventos
    const evento = {
        tipo: "ReservaCriada",
        dados: {
            id: contador,
            email: email,
            capsula: capsula,
            data: data,
            horario: horario,
        }
    };

    // ++ Tratativa para erros no envio do barramento
    try {
        // Envia o evento para o barramento (caso o barramento esteja ativo)
        await axios.post('http://localhost:10000/eventos', evento);
        res.status(201).send({ msg: "Reserva processada localmente, enviado ao barramento", usuario: baseLocal[contador] });
    } catch (error) {
        console.error("Erro ao enviar Reserva para o barramento:", error);
        res.status(500).send({ msg: "Erro ao enviar Reserva para o barramento" });
    }
});

app.listen(7000, () => {
    console.log('Microserviço de criação de reservas, porta 7000.');
});



// // Trecho de codigo para usar no front

// final url = Uri.parse('http://localhost:7000/criarReserva'); // Endpoint do backend

// try {
//   final response = await http.put(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       "email": "zezinho",
//       "capsula": "1",
//       "data": "12/12/24",
//       "horario": "12:30",
//     }),
//   );