const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const filePath = path.join(__dirname, '..', 'baseReservas.json'); // Caminho para o arquivo de reservas
let baseConsulta = {};

// Carregar os dados de reservas do arquivo JSON ao iniciar o servidor
function carregarBaseReservas() {
    try {
        const data = fs.readFileSync(filePath, 'utf8');
        baseConsulta = JSON.parse(data);
        console.log('Base de reservas carregada com sucesso.', baseConsulta);
    } catch (error) {
        console.error('Erro ao carregar a base de reservas:', error.message);
    }
}

// Atualiza a base de dados com o conteúdo atualizado em `baseConsulta`
function atualizarBaseReservas() {
    try {
        fs.writeFileSync(filePath, JSON.stringify(baseConsulta, null, 2));
        console.log('Dados atualizados e salvos com sucesso!');
    } catch (error) {
        console.error('Erro ao salvar dados no arquivo:', error.message);
    }
}

// Funções para manipulação dos eventos
const funcoes = {
    ReservaCriada: (dadosReserva) => {
        baseConsulta[Object.keys(baseConsulta).length] = dadosReserva;
        atualizarBaseReservas();
    },
    ConsultaReservas: () => baseConsulta, // Retorna todas as reservas
    ConsultaUserReservas: (dados) => {
        const email = dados.email;
        return Object.values(baseConsulta).filter((reserva) => reserva.email === email);
    }
};

// Rota para visualizar a base de reservas (para verificação)
app.get("/controleBase", (req, res) => {
    res.status(200).send(baseConsulta);
});

// Rota para lidar com eventos recebidos do barramento
app.post("/eventos", (req, res) => {
    const tipo = req.body.tipo;
    const dados = req.body.dados;

    if (funcoes[tipo]) {
        const resultado = funcoes[tipo](dados); // Executa a função correspondente ao tipo de evento

        // Se o tipo for ConsultaReservas ou ConsultaUserReservas, retorna os dados diretamente
        if (tipo === "ConsultaReservas" || tipo === "ConsultaUserReservas") {
            res.status(200).send(resultado); // Retorna o JSON com as reservas filtradas ou todas as reservas
        } else {
            res.status(200).send({ mensagem: "Evento processado com sucesso" });
        }
    } else {
        res.status(400).send({ erro: "Tipo de evento não suportado" });
    }
});

// Carrega as reservas do arquivo JSON ao iniciar o servidor
carregarBaseReservas();

app.listen(7001, () => console.log("Consultas Reservas. Porta 7001"));
