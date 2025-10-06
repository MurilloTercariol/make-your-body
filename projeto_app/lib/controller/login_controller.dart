// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  // Variáveis para armazenar email e senha
  String email = '';
  String password = '';

  // Contexto para navegação
  BuildContext? context;

  // Método para autenticação simples
  bool authenticate() {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }
    return true;
  }

  // Método principal de login
  void login(String email, String password) {
    this.email = email;
    this.password = password;

    if (authenticate()) {
      print('✅ Login bem-sucedido');
      Navigator.pushNamed(context!, '/home');
    } else {
      print('❌ Falha no login: campos vazios');
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
