import 'package:flutter/material.dart';

class EsqueciController {
  void verificaemail(BuildContext context, String email) {
    if (email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu e-mail.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link enviado para $email'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
