import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccountScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  CreateAccountScreen({super.key});

  Future<void> _createUser(BuildContext context) async {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('http://localhost:4000/criarUsuario'); // Endpoint do backend

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': name,
          'celular': phone,
          'email': email,
          'senha': password,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pushNamed(context, '/'); // Navega para a HomeScreen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar conta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão com o servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFFFF), // Cor de fundo
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 700, // Largura máxima do container
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: 256,
                  height: 256,
                  child: Image.asset('assets/UPodzz_256.png'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF033F58)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Celular',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF033F58)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF033F58)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF033F58)),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                OutlinedButton.icon(
                  onPressed: () {
                    _createUser(context); // Chama a função para enviar os dados
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  icon: const Icon(Icons.person_add, color: Color(0xFF033F58)),
                  label: const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF033F58),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Chama a função para enviar os dados
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text(
                    'Voltar para o Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF033F58),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
