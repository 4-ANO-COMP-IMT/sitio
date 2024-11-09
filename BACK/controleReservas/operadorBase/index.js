const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const filePath = path.join(__dirname, '..', 'baseReservas.json'); // Caminho para o arquivo de usuários
let baseConsulta = {};

// Carregar os dados de usuários do arquivo JSON ao iniciar o servidor
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
    ConsultaReservas: () => baseConsulta // Retorna todas as reservas

    // SolicitacaoLogin: (dataUsuario) => {
    //     const { email, senha } = dataUsuario;
    //     console.log(`Original: ${email}, ${senha}`);
    //     const usuario = Object.values(baseConsulta).find((u) => {
    //         // Log para verificar cada usuário na base
    //         console.log(`Comparando com: ${u.email}, ${u.senha}`);
    //         return u.email === email && u.senha === senha;
    //     });

    //     if (usuario) {
    //         console.log("Login bem-sucedido:", usuario);
    //         return { status: "sucesso", mensagem: "Login bem-sucedido", usuario: usuario };
    //     } else {
    //         console.log("Falha no login: usuário não encontrado.");
    //         return { status: "falha", mensagem: "Email ou senha incorretos" };
    //     }
    // },
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
        const resultado = funcoes[tipo](dados); // Executa a função correspondente ao tipo de evento
        res.status(200).send(resultado);
    } else {
        res.status(400).send({ erro: "Tipo de evento não suportado" });
    }
});

// Carrega os usuários do arquivo JSON ao iniciar o servidor
carregarBaseReservas();

app.listen(7001, () => console.log("Consultas Reservas. Porta 7001"));
