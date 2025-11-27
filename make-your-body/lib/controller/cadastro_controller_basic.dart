import 'package:flutter/material.dart';

class CadastroControllerBasic extends ChangeNotifier {
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

  String? validarNome(String nome) {
    if (nome.trim().isEmpty) return 'Nome é obrigatório';
    if (nome.trim().length < 2) return 'Nome deve ter pelo menos 2 caracteres';
    return null;
  }

  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    _setLoading(true);

    // Simular cadastro básico
    await Future.delayed(const Duration(seconds: 1));

    _setLoading(false);
    return null; // null = sucesso
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
