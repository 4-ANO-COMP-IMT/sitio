const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(bodyParser.json());
app.use(cors());

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}


app.post('/eventos', async (req,res) => {
    const evento = req.body;

    // await sleep(5000);

    // axios.post('http://localhost:4000/eventos', evento);
    axios.post('http://localhost:6000/eventos', evento);


    res.status(200).send({msg:"ok"});

});

app.listen(10000, () =>{
    console.log("Barramento de eventos. Porta 10000.")
})