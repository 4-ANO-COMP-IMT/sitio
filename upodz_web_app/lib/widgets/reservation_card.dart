import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final String id;
  final String data;
  final String horario;
  final VoidCallback onCancel;

  const ReservationCard({
    super.key,
    required this.id,
    required this.data,
    required this.horario,
    required this.onCancel,
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Data: $data",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF033F58),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Horário: $horario",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF033F58),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 70,
              child: ElevatedButton(
                onPressed: onCancel, // Aciona a função de cancelamento passada pelo MyReservations
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF033F58),
                  foregroundColor: Colors.white, // Define a cor do texto como branco
                  textStyle: const TextStyle(
                    fontSize: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
