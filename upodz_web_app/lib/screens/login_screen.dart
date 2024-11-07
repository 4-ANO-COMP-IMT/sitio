import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _checkLogin(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('http://localhost:5000/SolicitacaoLogin'); // Endpoint do backend

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': password,
        }),
      );

      if (response.statusCode == 201) {
        // Usuário criado com sucesso, navega para a HomeScreen
        Navigator.pushNamed(context, '/');
      } else {
        // Exibe uma mensagem de erro se a criação falhar
        print('Erro ao criar o usuário: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar conta')),
        );
      }
    } catch (e) {
      print('Erro na requisição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão com o servidor')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,  // Remove o botão de "voltar"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Lógica de login (simulada)
                print('Login: ${_emailController.text}');
                print('Senha: ${_passwordController.text}');
                Navigator.pushNamed(context, '/');
                _checkLogin(context); // Chama a função para enviar os dados
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');  // Navega para a tela de cadastro
              },
              child: Text('Ir para Cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
