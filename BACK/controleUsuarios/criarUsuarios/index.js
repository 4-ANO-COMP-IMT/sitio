const express = require ('express');

const axios = require('axios');
const bodyParser = require('body-parser');
const app = express();
const cors = require('cors');


app.use(bodyParser.json());
app.use(cors());
contador = 0;


let baseLocal = {};


app.get('/criarUsuarios', (req,res) => {
    res.send(baseLocal)
});

app.put("/criarUsuarios", async (req, res) => {
    // const baseLocal = {}

    contador ++;
    const { id } = req.body;
    const { nome } = req.body;
    const { email } = req.body;
    const { senha } = req.body;


    //save local
    baseLocal[contador] = {
        id,
        nome,
        email,
        senha
    };

    
    //POST mudanca na base de usuarios
    //==========================================================
    await axios.post("http://localhost:10000/eventos", {
        tipo: "UsuarioCriado",
        dados: {
            id,
            nome,
            email,
            senha
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
    console.log('atualizarBaseUsuarios. Porta 4000')
})