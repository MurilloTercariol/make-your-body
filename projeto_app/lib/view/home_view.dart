import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: const Center(
        child: Text(
          'Bem-vindo à tela inicial!, aqui será o restante do app',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
