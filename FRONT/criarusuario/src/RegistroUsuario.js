import React, { useState } from 'react';
import './index.css';


const RegistroUsuario = () => {
  const [formData, setFormData] = useState({
    id: '',
    nome: '',
    email: '',
    senha: ''
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

const handleSubmit = (e) => {
    e.preventDefault();
    setFormData({
        id: '',
        nome: '',
        email: '',
        senha: ''
    });
    alert('Cadastro realizado com sucesso!');
    fetch('http://localhost:4000/criarUsuarios', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData),
    })
        .then(response => response.json())
        .then(data => {
            console.log('Resposta do servidor:', data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
};

return (
    
    <div className="main-container">
        <header className="App-header">
            <h1>Formulário de Cadastro</h1>
        </header>
        <form onSubmit={handleSubmit} className='form-group'>
            <div className='container'>
                <input
                className="input"
                    type="text"
                    name="id"
                    placeholder="ID"
                    value={formData.id}
                    onChange={handleChange}
                />
            </div>
            <div className='container'>
                <input
                className="input"
                    type="text"
                    name="nome"
                    placeholder="Nome"
                    value={formData.nome}
                    onChange={handleChange}
                />
            </div>
            <div className='container'>
                <input
                className="input"
                    type="email"
                    name="email"
                    placeholder="Email"
                    value={formData.email}
                    onChange={handleChange}
                />
            </div>
            <div className='container'>
                <input
                className="input"
                    type="password"
                    name="senha"
                    placeholder="Senha"
                    value={formData.senha}
                    onChange={handleChange}
                />
            </div>
            <div className='container'>
                <button type="submit" className='button'>Cadastrar</button>
            </div>
        </form>
    </div>
);
};

export default RegistroUsuario;