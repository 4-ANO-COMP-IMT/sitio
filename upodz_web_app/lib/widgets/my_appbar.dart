import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {

  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(137, 3, 62, 88), // Cor da AppBar
      flexibleSpace: IconButton(
        onPressed: () => Navigator.pushNamed(context, '/'), // Navega para a tela de reservas
        icon: const Image(
          image: AssetImage('assets/UPodzzH.png'), // Logo da UPodz
          fit: BoxFit.contain,
        ),
      ),
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
            Navigator.pushNamed(context, '/reservation'); // Navega para a tela de login
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
