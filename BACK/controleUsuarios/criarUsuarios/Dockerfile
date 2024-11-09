# Usar a imagem base do Node.js
FROM node:18

# Criar o diretório de trabalho
WORKDIR /app

# Copiar os arquivos de dependências para instalar os pacotes
COPY package*.json ./

# Instalar as dependências
RUN npm install
RUN npm install express
RUN npm install cors
RUN npm install axios

# Copiar o restante do código
COPY . .

# Expor a porta em que o microsserviço roda
EXPOSE 4000

# Comando para iniciar o serviço
CMD ["npm", "start"]
