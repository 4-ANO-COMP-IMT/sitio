const express = require('express');
const bodyParser = require('body-parser')
const app = express();
app.use(bodyParser.json())

reservas = {}
contador = 0

app.get('/reservas', (req,res) => {
    res.send(reservas)
});

app.put('/reservas', (req, res) => {
    contador++
    const{ texto } = req.body
    reservas[contador] = {
        contador,texto
    }
    res.status(201).send(reservas[contador])
});

app.listen(4000, () => {
    console.log('reservas. Porta 4000');
})



