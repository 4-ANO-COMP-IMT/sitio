import React, { useState } from 'react';
import './index.css';

// import { getJsonObject } from './api'; // assuming you have an api module to fetch the json object


const ControlaBase = () => {
    const [jsonObject, setJsonObject] = useState({});
    const [clicked, setclicked] = useState(true);

    const handleSearch = async () => {
        try {
            const response = await fetch('http://localhost:6001/controleBase');
            const data = await response.json();
            setJsonObject(data);
            setclicked(false);
        } catch (error) {
            console.error('Erro:', error);
        }
    };

    const handleBack = () => {
        setclicked(true);
    };

    return (
        <div className="main-container">
            <div className='container'>
                <header className="App-header">
                    <h1>Controle de Base</h1>
                </header>
                {clicked && (
                    <button onClick={handleSearch} className='button' >Vizualizar Base</button>
                )}
                {!clicked && (Object.keys(jsonObject).map((key) => (
                    <div className='userInfo' key={key}>
                        <p>Nome: {JSON.stringify(jsonObject[key]['nome'])}</p>
                        <p>Email: {JSON.stringify(jsonObject[key]['email'])}</p>
                        <p>Celular: {JSON.stringify(jsonObject[key]['celular'])}</p>
                        <p>horario: {JSON.stringify(jsonObject[key]['horario'])}</p>
                    </div>
                )))}
                {!clicked && (
                    <div className='clickedButtons'>
                        <button onClick={handleSearch} className='controlButton' >Atualizar</button>
                        <button onClick={handleBack} className='controlButton' >Voltar</button>
                    </div>
                )}
            </div>
        </div>
    );
};

export default ControlaBase;