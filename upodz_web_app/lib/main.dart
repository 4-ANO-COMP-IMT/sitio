import 'package:flutter/material.dart';
import 'package:upodz_web_app/screens/my_reservations.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/create_account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPodzz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/calendar',  // Define a rota inicial para a tela de login
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/calendar':
            return MaterialPageRoute(builder: (context) => const CalendarScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => CreateAccountScreen());
          case '/reservation':
            return MaterialPageRoute(builder: (context) => MyReservations());
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen()); // Fallback
        }
      },
    );
  }
}
