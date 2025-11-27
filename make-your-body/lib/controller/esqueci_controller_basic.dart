import 'package:flutter/material.dart';

class EsqueciControllerBasic extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? validarEmail(String email) {
    if (email.trim().isEmpty) return 'E-mail é obrigatório';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      return 'Formato de e-mail inválido';
    }
    return null;
  }

  Future<String?> recuperarSenha(String email) async {
    _setLoading(true);

    // Simular recuperação de senha
    await Future.delayed(const Duration(seconds: 1));

    _setLoading(false);
    return null; // null = sucesso
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
