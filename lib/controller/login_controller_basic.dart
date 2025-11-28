import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginControllerBasic extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _setLoading(false);
      return null; // null = sucesso
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ou senha incorretos';
        case 'invalid-email':
          return 'Email inválido';
        case 'user-disabled':
          return 'Conta desativada';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde';
        default:
          return 'Email ou senha incorretos';
      }
    } catch (e) {
      _setLoading(false);
      return 'Erro inesperado: ${e.toString()}';
    }
  }

  // Adicionar método loginComFirebase para compatibilidade
  Future<String?> loginComFirebase(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoading(true);

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

      _setLoading(false);
      return null; // Sucesso - sem erro
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
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
    } catch (e) {
      _setLoading(false);
      String mensagem = '❌ Erro inesperado: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
      );
      return mensagem;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
