import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/create_account_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPodzz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',  // Define a rota inicial para a tela de login
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/calendar':
            return MaterialPageRoute(builder: (context) => CalendarScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => CreateAccountScreen());
          default:
            return MaterialPageRoute(builder: (context) => HomeScreen()); // Fallback
        }
      },
    );
  }
}
