const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(express.json());
app.use(cors());

const filePath = path.join(__dirname, '..', 'baseUsuarios.json'); // Caminho para o arquivo de usuários
let baseConsulta = {};

// Carregar os dados de usuários do arquivo JSON ao iniciar o servidor
function carregarBaseUsuarios() {
    try {
        const data = fs.readFileSync(filePath, 'utf8');
        baseConsulta = JSON.parse(data);
        console.log('Base de usuários carregada com sucesso.');
    } catch (error) {
        console.error('Erro ao carregar a base de usuários:', error.message);
    }
}

// Atualiza a base de dados com o conteúdo atualizado em `baseConsulta`
function atualizarBaseUsuarios() {
    try {
        fs.writeFileSync(filePath, JSON.stringify(baseConsulta, null, 2));
        console.log('Dados atualizados e salvos com sucesso!');
    } catch (error) {
        console.error('Erro ao salvar dados no arquivo:', error.message);
    }
}

// Funções para manipulação dos eventos
const funcoes = {
    UsuarioCriado: (dataUsuario) => {
        baseConsulta[Object.keys(baseConsulta).length] = dataUsuario;
        atualizarBaseUsuarios();
    },

    SolicitacaoLogin: async (dataUsuario) => {
        const { email, senha, contador } = dataUsuario;
        const usuario = Object.values(baseConsulta).find((u) => u.email === email && u.senha === senha);

        const resultadoEvento = {
            tipo: "ResultadoLogin",
            dados: {
                contador,
                status: usuario ? "sucesso" : "falha",
                mensagem: usuario ? "Login bem-sucedido" : "Email ou senha incorretos"
            }
        };

        await axios.post('http://localhost:10000/eventos', resultadoEvento);
    },
};

// Rota para visualizar a base de usuários (para verificação)
app.get("/controleBase", (req, res) => {
    res.status(200).send(baseConsulta);
});

// Rota para lidar com eventos recebidos do barramento
app.post("/eventos", (req, res) => {
    const tipo = req.body.tipo;
    const dados = req.body.dados;

    if (funcoes[tipo]) {
        funcoes[tipo](dados);
        res.status(200).send({ msg: "Evento processado com sucesso" });
    } else {
        res.status(400).send({ erro: "Tipo de evento não suportado" });
    }
});

// Carrega os usuários do arquivo JSON ao iniciar o servidor
carregarBaseUsuarios();

app.listen(6001, () => console.log("Consultas. Porta 6001"));
