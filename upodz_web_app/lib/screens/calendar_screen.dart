import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upodz_web_app/widgets/my_appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<String> horariosOcupados = [];
  bool isLoading = false; // Adiciona o controle de estado de carregamento

  @override
  void initState() {
    super.initState();
    carregarReservas();
  }

  // Limita o calendário para os próximos 7 dias
  DateTime get _lastDay => DateTime.now().add(const Duration(days: 7));

  // Gera slots de horário em intervalos de 30 minutos
  List<String> _generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String hourStr = hour.toString().padLeft(2, '0');
        String minuteStr = minute.toString().padLeft(2, '0');
        slots.add('$hourStr:$minuteStr');
      }
    }
    return slots;
  }

  // Verifica se o horário está disponível (não passou no dia atual e não está reservado)
 bool _isTimeSlotAvailable(String time) {
    if (horariosOcupados.contains(time)) {
      return false;
    }
    if (_selectedDay.day == DateTime.now().day &&
        _selectedDay.month == DateTime.now().month &&
        _selectedDay.year == DateTime.now().year) {
      final now = DateTime.now();
      final selectedTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        int.parse(time.split(':')[0]),
        int.parse(time.split(':')[1]),
      );
      return selectedTime.isAfter(now);
    }
    return true;
  }

    Future<void> criarReserva(String email, String capsula, String data, String horario) async {
      final url = Uri.parse('http://localhost:7000/criarReserva'); // Endpoint do backend

      try {
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email,
            "capsula": capsula,
            "data": data,
            "horario": horario,
          }),
        );

        if (response.statusCode == 201) {
          print("Reserva criada com sucesso: ${response.body}");

          // Após criar a reserva, chamar carregarReservas para atualizar a lista de horários ocupados
          await carregarReservas();

          // Atualiza a interface do usuário após a atualização
          setState(() {});
        } else {
          print("Erro ao criar reserva: ${response.statusCode} - ${response.body}");
        }
      } catch (e) {
        print("Erro ao se comunicar com o backend: $e");
      }
    }


    Future<void> carregarReservas() async {
    print("Iniciando carregarReservas"); // Confirma se o método está sendo chamado

    final url = Uri.parse('http://localhost:7002/consultaTodasReservas');

    try {
      final response = await http.get(url);
      print("Status da resposta: ${response.statusCode}"); // Verifica o status da resposta
      print("Corpo da resposta: ${response.body}"); // Verifica o corpo da resposta

      if (response.statusCode == 200) {
        final reservas = jsonDecode(response.body) as Map<String, dynamic>;
        print("Reservas recebidas do backend: $reservas"); // Print para depuração
        
        setState(() {
          horariosOcupados = reservas.values
              .where((reserva) =>
                  reserva['data'] ==
                  "${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}")
              .map<String>((reserva) => reserva['horario'])
              .toList();
        });
        
        print("Horários ocupados para o dia selecionado ($_selectedDay): $horariosOcupados"); // Print para verificar os horários ocupados para a data selecionada
      } else {
        print("Erro ao carregar reservas: Status ${response.statusCode}"); // Imprime o status de erro se não for 200
      }
    } catch (e) {
      print("Erro ao carregar reservas: $e"); // Print de erro para exceções
    }
  }




    @override
  Widget build(BuildContext context) {
    List<String> timeSlots = _generateTimeSlots();

    return Scaffold(
      backgroundColor: const Color(0xFFEBFFFF), // Cor de fundo
      appBar: const MyAppbar(),
      body: isLoading // Verifica o estado de carregamento
          ? Center(child: CircularProgressIndicator()) // Mostra o indicador de carregamento
          : Row(
              children: [
                // Calendário no lado esquerdo
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: const Color.fromARGB(255, 245, 255, 255), // Fundo do card
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Color(0xFF033F58), width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: TableCalendar(
                              firstDay: DateTime.now(),
                              lastDay: _lastDay,
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                              enabledDayPredicate: (day) {
                                // Desabilita os domingos
                                return day.weekday != DateTime.sunday;
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                if (!isSameDay(_selectedDay, selectedDay)) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                  print("Data selecionada: $_selectedDay"); // Print para depuração da data selecionada
                                  carregarReservas(); // Carrega as reservas ao selecionar um novo dia
                                }
                              },

                              calendarStyle: CalendarStyle(
                                selectedDecoration: const BoxDecoration(
                                  color: Color(0xFF033F58),
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                weekendTextStyle: const TextStyle(color: Color(0xFF033F58)),
                                defaultTextStyle: const TextStyle(color: Color(0xFF033F58)),
                              ),
                              daysOfWeekStyle: const DaysOfWeekStyle(
                                weekdayStyle: TextStyle(color: Color(0xFF033F58)),
                                weekendStyle: TextStyle(color: Color(0xFF033F58)),
                              ),
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: Color(0xFF033F58),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF033F58)),
                                rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF033F58)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tabela de horários no lado direito
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: const Color.fromARGB(255, 245, 255, 255),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Color(0xFF033F58), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Horários disponíveis para ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF033F58),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Table(
                                children: [
                                  for (int i = 0; i < timeSlots.length; i += 4)
                                    TableRow(
                                      children: [
                                        _buildTimeSlotCell(timeSlots[i]),
                                        if (i + 1 < timeSlots.length)
                                          _buildTimeSlotCell(timeSlots[i + 1])
                                        else
                                          Container(),
                                        if (i + 2 < timeSlots.length)
                                          _buildTimeSlotCell(timeSlots[i + 2])
                                        else
                                          Container(),
                                        if (i + 3 < timeSlots.length)
                                          _buildTimeSlotCell(timeSlots[i + 3])
                                        else
                                          Container(),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }


  // Função para construir cada célula de horário
  Widget _buildTimeSlotCell(String time) {
    final isAvailable = _isTimeSlotAvailable(time);

    return InkWell(
      onTap: isAvailable
          ? () {
              criarReserva("email_exemplo@dominio.com", "1", "${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}", time);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Horário Selecionado'),
                    content: Text(
                      'Reserva efetuada para às $time no dia ${_selectedDay.day}/${_selectedDay.month}',
                      style: const TextStyle(color: Color(0xFF033F58)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                                                    'OK',
                          style: TextStyle(color: Color(0xFF033F58)),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: isAvailable ? const Color(0xFF033F58) : Colors.grey,
              width: 1.5,
            ),
            color: isAvailable ? Colors.transparent : Colors.grey[200],
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 16,
                color: isAvailable ? const Color(0xFF033F58) : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

