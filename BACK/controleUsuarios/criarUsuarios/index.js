const express = require ('express');

const axios = require('axios');
const bodyParser = require('body-parser');
const app = express();
const cors = require('cors');


app.use(bodyParser.json());
app.use(cors());
contador = 0;


let baseLocal = {};


app.get('/criarReservas', (req,res) => {
    res.send(baseLocal)
});

app.put("/criarReservas", async (req, res) => {
    // const baseLocal = {}

    contador ++;
    const { celular } = req.body;
    const { nome } = req.body;
    const { email } = req.body;
    const { horario } = req.body;


    //save local
    baseLocal[contador] = {
        celular,
        nome,
        email,
        horario
    };

    
    //POST mudanca na base de usuarios
    //==========================================================
    await axios.post("http://localhost:10000/eventos", {
        tipo: "ReservaCriada",
        dados: {
            celular,
            nome,
            email,
            horario
        },
    });
    //==========================================================

    res.status(201).send(baseLocal[contador]);
})

// app.post("/eventos", (req,res) => {
//     console.log(req.body);
//     res.status(200).send({msg:"ok"});
// })

app.listen(4000, () => {
    console.log('atualizarBaseReserva. Porta 4000')
})