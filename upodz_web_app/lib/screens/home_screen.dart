import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),

        // Botão que fica no topo podemos ussar isso para funcionalidade de mudar de conta
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/login');  // Navega para a tela de login
        //     },
        //   ),
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bem-vindo ao Meu Site em Flutter!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');  // Navega para a tela do calendário
              },
              child: Text('Ir para o Calendário'),
            ),
          ],
        ),
      ),
    );
  }
}
