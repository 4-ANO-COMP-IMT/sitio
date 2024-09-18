import React, { useState, useEffect } from 'react';
import './RegistroReserva.css'; 
import logo from './assets/UPodzz.png'; 

const RegistroReserva = () => {
  const [formData, setFormData] = useState({
    celular: '',
    nome: '',
    email: '',
    horario: ''
  });

  const [horariosReservados, setHorariosReservados] = useState([]);
  const [minDate, setMinDate] = useState('');
  const [maxDate, setMaxDate] = useState('');


  useEffect(() => {
    const today = new Date();
    const twoDaysLater = new Date();
    twoDaysLater.setDate(today.getDate() + 2);

    const formatDate = (date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0'); //
      const day = String(date.getDate()).padStart(2, '0');
      const hours = '06'; 
      const minutes = '00'; 

      return `${year}-${month}-${day}T${hours}:${minutes}`;
    };

    const formatMaxDate = (date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = '22'; 
      const minutes = '00';

      return `${year}-${month}-${day}T${hours}:${minutes}`;
    };

    setMinDate(formatDate(today)); 
    setMaxDate(formatMaxDate(twoDaysLater)); 
  }, []);


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
    fetchHorariosReservados(); // 
  }, []);

  
  const normalizeHorario = (horario) => {
    return horario.slice(0, 16); 
  };


  const isHorarioReservado = (horarioSelecionado) => {
    const horarioNormalizado = normalizeHorario(horarioSelecionado);
    return horariosReservados.some((horario) => normalizeHorario(horario) === horarioNormalizado);
  };

 
  const validateStep = (dateTime) => {
    const date = new Date(dateTime);
    const minutes = date.getMinutes();

  
    return minutes % 30 === 0;
  };

  const handleChange = (e) => {
    const { name, value } = e.target;

    if (name === 'horario' && value) {
    
      if (!validateStep(value)) {
        alert('Selecione um horário com intervalos de 30 minutos.');
        return;
      }
    }

    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

   
    if (!formData.nome || !formData.email || !formData.celular || !formData.horario) {
      alert('Por favor, preencha todos os campos antes de reservar.');
      return; 
    }

    
    if (isHorarioReservado(formData.horario)) {
      alert('Este horário já está reservado. Por favor, selecione outro horário.');
      return;
    }

    
    alert('Reserva realizada com sucesso!');
    try {
      const response = await fetch('http://localhost:4000/criarReservas', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData),
      });
      const data = await response.json();
      console.log('Resposta do servidor:', data);

 
      await sendEmail(formData.email);

    } catch (error) {
      console.error('Error:', error);
    }

    // Resetando o formulário após o envio
    setFormData({
      celular: '',
      nome: '',
      email: '',
      horario: ''
    });
  };

  const sendEmail = async (email) => {
    const subject = 'Confirmação de Reserva';
    const body = `Olá, ${formData.nome}, sua reserva para o horário ${formData.horario} foi confirmada.`;
    
    try {
      const response = await fetch(
        'https://prod-21.brazilsouth.logic.azure.com:443/workflows/127ab0a5da73415a9f50fff81022dd73/triggers/When_a_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0&sig=bdk-m3_zlPPQrIctYB8s3W5mYrGO0SGQTmt217Ou-N4',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            to: email,
            subject: subject,
            body: body
          })
        }
      );
      const result = await response.json();
      console.log('Email enviado:', result);
    } catch (error) {
      console.error('Erro ao enviar email:', error);
    }
  };
  
  return (
    <div className="main-container">
      <img src={logo} alt="UPodzz Logo" className="logo" />
      <header className="App-header">
        <h1>Reservar Sleeping Pod</h1>
      </header>
      <form onSubmit={handleSubmit} className="form-group">
        <div className="container">
          <input
            className="input"
            type="text"
            name="nome"
            placeholder="Nome"
            value={formData.nome}
            onChange={handleChange}
            required 
          />
        </div>
        <div className="container">
          <input
            className="input"
            type="email"
            name="email"
            placeholder="Email"
            value={formData.email}
            onChange={handleChange}
            required 
          />
        </div>
        <div className="container">
          <input
            className="input"
            type="text"
            name="celular"
            placeholder="Celular"
            value={formData.celular}
            onChange={handleChange}
            required 
          />
        </div>
        <div className="container">
          <label htmlFor="horario">Selecione o Horário</label>
          <input
            className="input"
            type="datetime-local"
            name="horario"
            value={formData.horario}
            onChange={handleChange}
            min={minDate} 
            max={maxDate} 
            step="1800" 
            required 
          />
        </div>
        <div className="container">
          <button type="submit" className="button">Reservar</button>
        </div>
      </form>
    </div>
  );
};

export default RegistroReserva;
