import React, { useState, useEffect } from 'react';
import './ControlaBase.css';

const ControlaBase = () => {
    const [jsonObject, setJsonObject] = useState({});

    const handleSearch = async () => {
        try {
            const response = await fetch('http://localhost:6001/controleBase');
            const data = await response.json();
            setJsonObject(data);
        } catch (error) {
            console.error('Erro:', error);
        }
    };

    // Atualização automática a cada 5 segundos (5000ms)
    useEffect(() => {
        handleSearch(); // Faz a busca inicial
        const interval = setInterval(handleSearch, 5000); // Atualiza os dados a cada 5 segundos

        
        return () => clearInterval(interval);
    }, []);

    return (
        <div className="main-container">
            <header className="App-header">
                <h1>Controle de Base</h1>
            </header>
            <div className="data-container">
                {Object.keys(jsonObject).map((key) => (
                    <div className='cell' key={key}>
                        <p><strong>Nome:</strong> {jsonObject[key]['nome']}</p>
                        <p><strong>Email:</strong> {jsonObject[key]['email']}</p>
                        <p><strong>Celular:</strong> {jsonObject[key]['celular']}</p>
                        <p><strong>Horário:</strong> {jsonObject[key]['horario']}</p>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default ControlaBase;
