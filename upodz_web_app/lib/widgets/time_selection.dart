import 'package:flutter/material.dart';

class TimeSelection extends StatelessWidget {
  final List<String> timeSlots = [
    "10:00", "10:30", "11:00", "11:30", "12:00",
    "12:30", "13:00", "13:30", "14:00", "14:30",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: timeSlots.map((time) {
        return ListTile(
          title: Text(time),
          onTap: () {
            print('Horário selecionado: $time');
          },
        );
      }).toList(),
    );
  }
}
