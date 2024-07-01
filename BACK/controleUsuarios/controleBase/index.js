const express = require('express');

const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());


let baseConsulta = {}

// function cloneBaseUsuarios() {
//     let baseConsulta = {}
//     try {
//         const data = fs.readFileSync(filePath, 'utf8');
//         baseConsulta = JSON.parse(data);
//         return baseConsulta
//     } catch (error) {
//         console.error('Erro ao carregar dados do arquivo:', error.message);
//         return {}
//     }
// }
function atualizarBaseUsuarios() {
    try {
        // Replace existing data with the contents of baseConsulta
        fs.writeFileSync(filePath, JSON.stringify(baseConsulta, null, 2));
        console.log('Dados atualizados e salvos com sucesso!');
    } catch (error) {
        console.error('Erro ao salvar dados no arquivo:', error.message);
    }
}

const filePath = path.join(__dirname, '..', 'baseUsuarios.json'); // Caminho para o arquivo


const funcoes = {

    UsuarioCriado: (dataUsuario) => {
        // let baseConsulta = cloneBaseUsuarios()
        baseConsulta[Object.keys(baseConsulta).length] = dataUsuario;
        atualizarBaseUsuarios()
    },
    ObservacaoCriada: (observacao) => {
        const observacoes = baseConsulta[observacao.lembreteId]["observacoes"] || [];
        observacoes.push(observacao);
        baseConsulta[observacao.lembreteId]["observacoes"] = observacoes;
    }
    
}

app.get("/controleBase", (req, res) => {
    res.status(200).send(baseConsulta);
});

app.post("/eventos", (req, res) => {
    
    funcoes[req.body.tipo](req.body.dados);
    res.status(200).send(baseConsulta)
    console.log(baseConsulta)

});

app.listen(6000, () => console.log("Consultas. Porta 6000"))