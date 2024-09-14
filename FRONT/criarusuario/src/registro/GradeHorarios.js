import React, { useState, useEffect } from 'react';
import './GradeHorarios.css'; // Certifique-se de que o CSS foi importado corretamente

const GradeHorarios = () => {
  const [horariosReservados, setHorariosReservados] = useState([]);
  const [horariosDisponiveis, setHorariosDisponiveis] = useState([]);

  // Função que formata a data/hora para o formato correto (YYYY-MM-DDTHH:MM)
  const formatDateTime = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`; // Formato YYYY-MM-DDTHH:MM
  };

  // Função para gerar os horários disponíveis
  const generateAvailableTimes = () => {
    const times = [];
    const today = new Date();
    const startHour = 6; // Horário de início: 6:00
    const endHour = 22; // Horário de fim: 22:00
    const step = 30; // Step de 30 minutos

    for (let day = 0; day <= 2; day++) {
      const date = new Date(today);
      date.setDate(today.getDate() + day);

      for (let hour = startHour; hour < endHour; hour++) {
        for (let minute = 0; minute < 60; minute += step) {
          const availableTime = new Date(date.setHours(hour, minute));
          times.push(formatDateTime(availableTime)); // Usa o formato YYYY-MM-DDTHH:MM
        }
      }
    }

    setHorariosDisponiveis(times);
  };

  // Função para buscar os horários reservados
  const fetchHorariosReservados = async () => {
    try {
      const response = await fetch('http://localhost:6001/controleBase');
      const data = await response.json();
      const horarios = Object.values(data).map((reserva) => reserva.horario); // Assume que o formato é YYYY-MM-DDTHH:MM
      setHorariosReservados(horarios);
    } catch (error) {
      console.error('Erro ao buscar horários reservados:', error);
    }
  };

  // Atualiza os horários reservados a cada 5 segundos
  useEffect(() => {
    generateAvailableTimes(); // Gera os horários disponíveis
    fetchHorariosReservados(); // Busca os horários reservados

    const interval = setInterval(() => {
      fetchHorariosReservados(); // Atualiza a cada 5 segundos
    }, 5000); // 5000ms = 5 segundos

    return () => clearInterval(interval); 
  }, []);

  // Função que verifica se o horário está reservado
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
