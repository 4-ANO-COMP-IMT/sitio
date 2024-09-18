import React, { useState, useEffect } from 'react';
import './GradeHorarios.css'; 

const GradeHorarios = () => {
  const [horariosReservados, setHorariosReservados] = useState([]);
  const [horariosDisponiveis, setHorariosDisponiveis] = useState([]);

  
  const formatDateTime = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`; 
  };

  
  const generateAvailableTimes = () => {
    const times = [];
    const today = new Date();
    const startHour = 6; 
    const endHour = 22; 
    const step = 30; 

    for (let day = 0; day <= 2; day++) {
      const date = new Date(today);
      date.setDate(today.getDate() + day);

      for (let hour = startHour; hour < endHour; hour++) {
        for (let minute = 0; minute < 60; minute += step) {
          const availableTime = new Date(date.setHours(hour, minute));
          times.push(formatDateTime(availableTime)); 
        }
      }
    }

    setHorariosDisponiveis(times);
  };

  
  const fetchHorariosReservados = async () => {
    try {
      const response = await fetch('http://localhost:6001/controleBase');
      const data = await response.json();
      const horarios = Object.values(data).map((reserva) => reserva.horario); 
      setHorariosReservados(horarios);
    } catch (error) {
      console.error('Erro ao buscar horários reservados:', error);
    }
  };

  
  useEffect(() => {
    generateAvailableTimes(); 
    fetchHorariosReservados(); 

    const interval = setInterval(() => {
      fetchHorariosReservados(); 
    }, 5000); 

    return () => clearInterval(interval); 
  }, []);

  
  const isReserved = (time) => {
    return horariosReservados.includes(time);
  };

  return (
    <div className="grade-container">
      <h2 className="grade-title">Grade de Horários Disponíveis</h2>
      <div className="grade-horarios">
        {horariosDisponiveis.map((time, index) => (
          <div
            key={index}
            className={`horario-cell ${isReserved(time) ? 'reservado' : 'disponivel'}`}
          >
            {new Date(time).toLocaleString('pt-BR', {
              day: '2-digit',
              month: '2-digit',
              hour: '2-digit',
              minute: '2-digit'
            })}
          </div>
        ))}
      </div>
    </div>
  );
};

export default GradeHorarios;
