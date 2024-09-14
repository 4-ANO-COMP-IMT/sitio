import React from 'react';
import RegistroReserva from './RegistroReserva'; 
import ControlaBase from './ControlaBase'; 
import GradeHorarios from './GradeHorarios'; 
import './Home.css'; 

const Home = () => {
    return (
        <div className="page-container">
            <div className="left-panel">
                <RegistroReserva />
            </div>
            <div className="right-panel">
                {/* <ControlaBase /> */}
                <GradeHorarios /> 
            </div>
        </div>
    );
};

export default Home;
