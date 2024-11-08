import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFFFF), // Fundo da página
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250, // Largura uniforme para todos os botões
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar'); // Navega para a tela do calendário
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Melhorando o padding
                ),
                icon: const Icon(Icons.calendar_month, color: Color(0xFF033F58)),
                label: const Text(
                  'Reservar Pod',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF033F58),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os botões
            SizedBox(
              width: 250,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Ação para "Minhas Reservas"
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                icon: const Icon(Icons.bookmark, color: Color(0xFF033F58)),
                label: const Text(
                  'Minhas Reservas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF033F58),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 250,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Sair e ir para a tela de login
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                icon: const Icon(Icons.logout, color: Color(0xFF033F58)),
                label: const Text(
                  'Sair',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF033F58),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
