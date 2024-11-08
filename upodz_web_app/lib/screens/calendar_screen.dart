import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Limit the calendar to the next 7 days
  DateTime get _lastDay => DateTime.now().add(const Duration(days: 7));

  // Generate time slots in 30-minute intervals
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

  @override
  Widget build(BuildContext context) {
    List<String> timeSlots = _generateTimeSlots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF033F58), // Cor da AppBar
        actions: [
          IconButton(
          icon: const Icon(Icons.logout),
          color: const Color(0xFFEBFFFF), // Cor do ícone de logout
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Navega para a tela de login
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            color: const Color(0xFFEBFFFF), // Cor do ícone de cadastro
            onPressed: () {
              Navigator.pushNamed(context, '/calendar'); // Navega para a tela de cadastro
            },
          ),
          IconButton(
          icon: const Icon(Icons.bookmark),
          color: const Color(0xFFEBFFFF), // Cor do ícone de logout
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Navega para a tela de login
        },
        ),
        ],
      ),
      body: Row(
        children: [
          // Calendar on the left side
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
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
                  ),
                ),
              ),
            ),
          ),
          // Schedule table on the right side
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Horários disponíveis para ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          children: [
                            for (int i = 0; i < timeSlots.length; i += 4)
                              TableRow(
                                children: [
                                  _buildTimeSlotCell(timeSlots[i]),
                                  if (i + 1 < timeSlots.length)
                                    _buildTimeSlotCell(timeSlots[i + 1])
                                  else
                                    Container(), // Empty cell if no slot available
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

  // Function to build each time slot cell
  Widget _buildTimeSlotCell(String time) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Horário Selecionado'),
              content: Text('Reserva efetuada para às $time no dia ${_selectedDay.day}/${_selectedDay.month}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            time,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
