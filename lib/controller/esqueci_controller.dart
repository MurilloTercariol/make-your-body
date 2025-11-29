import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueciController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verificaemail(BuildContext context, String email) async {
    if (email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu e-mail.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Mostra que está enviando
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔄 Enviando email de recuperação...'),
          duration: Duration(seconds: 2),
        ),
      );

      await _auth.sendPasswordResetEmail(email: email.trim());

      // Sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Link de recuperação enviado para $email'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem;
      switch (e.code) {
        case 'user-not-found':
          mensagem = '❌ Usuário não encontrado com este email';
          break;
        case 'invalid-email':
          mensagem = '❌ Email inválido';
          break;
        default:
          mensagem = '❌ Erro ao enviar email: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
      );
    }
  }
}
