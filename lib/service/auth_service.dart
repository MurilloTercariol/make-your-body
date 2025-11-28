import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verifica se o usuário está logado
  Future<bool> verificarLogin() async {
    final user = _auth.currentUser;
    return user != null;
  }

  // Pega o usuário atual
  User? get currentUser => _auth.currentUser;

  // Fazer logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
