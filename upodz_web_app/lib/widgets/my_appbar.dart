import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {

  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          color: const Color(0xFFEBFFFF), // Cor do ícone de calendário
          onPressed: () {
            Navigator.pushNamed(context, '/calendar'); // Navega para a tela de calendário
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          color: const Color(0xFFEBFFFF), // Cor do ícone de bookmark
          onPressed: () {
            Navigator.pushNamed(context, '/reservations'); // Navega para a tela de login
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
