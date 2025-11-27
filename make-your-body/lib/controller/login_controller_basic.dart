import 'package:flutter/material.dart';

class LoginControllerBasic extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? validarEmail(String email) {
    if (email.trim().isEmpty) return 'E-mail é obrigatório';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      return 'Formato de e-mail inválido';
    }
    return null;
  }

  String? validarSenha(String senha) {
    if (senha.trim().isEmpty) return 'Senha é obrigatória';
    if (senha.trim().length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  Future<String?> login({required String email, required String senha}) async {
    _setLoading(true);

    // Simular login básico - aceitar qualquer email/senha por enquanto
    await Future.delayed(const Duration(seconds: 1));

    _setLoading(false);
    return null; // null = sucesso
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
