// ignore_for_file: avoid_print, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Variáveis para armazenar email e senha

  String email = '';
  String password = '';
  bool _isLoading = false;

  // Contexto para navegação
  BuildContext? context;

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

  // Login com Firebase Auth
  Future<String?> loginComFirebase(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Mostra que está tentando
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔄 Tentando fazer login...'),
          duration: Duration(seconds: 1),
        ),
      );

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Mostra sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Login realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      return null; // Sucesso - sem erro
    } on FirebaseAuthException catch (e) {
      String mensagem;
      switch (e.code) {
        case 'user-not-found':
          mensagem = '❌ Usuário não encontrado';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          mensagem = '❌ Email ou senha incorretos';
          break;
        case 'invalid-email':
          mensagem = '❌ Email inválido';
          break;
        case 'user-disabled':
          mensagem = '❌ Conta desativada';
          break;
        case 'too-many-requests':
          mensagem = '❌ Muitas tentativas. Tente novamente mais tarde';
          break;
        default:
          mensagem = '❌ Email ou senha incorretos';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
      );

      return mensagem;
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      // Mostra que está tentando
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔄 Fazendo logout...'),
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

      // Mostra sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Logout realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      await _auth.signOut();
    } catch (e) {
      // Mostra erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erro no logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
