import 'package:flutter/material.dart';
import 'package:upodz_web_app/widgets/my_appbar.dart';
import 'package:upodz_web_app/widgets/reservation_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyReservations extends StatefulWidget {
  MyReservations({super.key});

  @override
  _MyReservationsState createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  List<Map<String, dynamic>> reservations = []; // Lista para armazenar as reservas
  bool isLoading = true; // Controla o estado de carregamento

  @override
  void initState() {
    super.initState();
    carregarReservasUsuario(); // Chama a função para carregar as reservas
  }

  // Função para recuperar o e-mail do usuário logado
  Future<String?> recuperarEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  // Função para buscar reservas do usuário no backend
  Future<void> carregarReservasUsuario() async {
    String? email = await recuperarEmail();
    if (email == null) {
      print("❄️ Erro: E-mail do usuário não encontrado ❄️");
      return;
    }

    final url = Uri.parse('http://localhost:7003/consultaUserReservas');
    print("❄️ Enviando solicitação PUT para o backend com o e-mail: $email ❄️");

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      print("❄️ Status da resposta do backend: ${response.statusCode} ❄️");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("❄️ Dados recebidos: $data ❄️");

        setState(() {
          // Processa cada item e cria uma lista de mapas com os dados necessários
          reservations = data.map<Map<String, dynamic>>((reserva) {
            return {
              "id": reserva["id"].toString(),
              "data": reserva["data"] ?? '',
              "horario": reserva["horario"] ?? ''
            };
          }).toList();
          isLoading = false; // Carregamento completo
        });
      } else {
        print("❄️ Erro ao carregar reservas: Status ${response.statusCode} ❄️");
      }
    } catch (e) {
      print("❄️ Erro ao carregar reservas: $e ❄️");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFFFF),
      appBar: const MyAppbar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostra o indicador de carregamento
          : Center(
              child: Container(
                width: 700,
                padding: const EdgeInsets.all(16.0),
                child: reservations.isEmpty
                    ? const Text("Nenhuma reserva encontrada.")
                    : ListView.builder(
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservations[index];
                          return ReservationCard(
                            id: reservation["id"],
                            data: reservation["data"],
                            horario: reservation["horario"],
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
