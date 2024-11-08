import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      _checkLogin(context);

      // Simulação de um processo de login com delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        // Navegar para a próxima tela
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/');
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu login';
    }

    // Expressão regular para validar formato de e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }

    return null;
  }

  Future<void> _checkLogin(BuildContext context) async {
    final String email = _loginController.text;
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

            //   ElevatedButton(
            //   onPressed: () {
            //     // Lógica de login (simulada)
            //     print('Login: ${_emailController.text}');
            //     print('Senha: ${_passwordController.text}');
            //     Navigator.pushNamed(context, '/');
            //     _checkLogin(context); // Chama a função para enviar os dados
            //   },
            //   child: Text('Login'),
            // ),



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFFFF), // Cor de fundo da página
      body: Center(
        child: Container(
          width: 700, // Largura máxima do container
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: 256,
                  height: 256,
                  child: Image.asset('assets/UPodzz.png'),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Login',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF92C0C8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF033F58)),
                    ),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF92C0C8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF033F58)),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : OutlinedButton.icon(
                        onPressed: _login,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        icon: const Icon(Icons.login, color: Color(0xFF033F58)),
                        label: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033F58),
                          ),
                        ),
                      ),
                const SizedBox(height: 16.0),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF033F58), width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    icon: const Icon(Icons.person_add, color: Color(0xFF033F58)),
                    label: const Text(
                      'Se cadastrar',
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
        ),
      ),
    );
  }
}
