import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final String data;
  final String horario;

  const ReservationCard({
    super.key,
    required this.data,
    required this.horario,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEBFFFF), // Cor de fundo do card
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFF033F58), width: 1.5), // Borda com a cor principal
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Data: $data",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF033F58),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Horário: $horario",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF033F58),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
