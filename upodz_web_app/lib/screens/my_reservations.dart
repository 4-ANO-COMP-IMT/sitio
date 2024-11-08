import 'package:flutter/material.dart';
import 'package:upodz_web_app/widgets/my_appbar.dart';
import 'package:upodz_web_app/widgets/reservation_card.dart';

class MyReservations extends StatelessWidget {
  MyReservations({super.key});

  final List<Map<String, String>> reservations = [
    {
      "data": "10-11-24",
      "horario": "14:00 - 14:30",
    },
    {
      "data": "11-11-24",
      "horario": "10:00 - 10:30",
    },
    {
      "data": "12-11-24",
      "horario": "16:00 - 16:30",
    },
    {
      "data": "13-11-24",
      "horario": "12:00 - 12:30",
    },
    {
      "data": "14-11-24",
      "horario": "08:00 - 08:30",
    },
    {
      "data": "15-11-24",
      "horario": "18:00 - 18:30",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFFFF), // Cor de fundo
      appBar: const MyAppbar(),
      body: Center(
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return ReservationCard(
              data: reservation["data"] ?? '',
              horario: reservation["horario"] ?? '',
            );
          },
        ),
        ),
      ),
    );
  }
}
