import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// cadastro_controller_simples.dart
class CadastroController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Apenas as validações básicas
  String? validarCadastro({
    required String nome,
    required String email,
    required String senha,
    required String confirmacaoSenha,
    required bool temObjetivos,
    required bool aceitouTermos,
    required bool aceitouPolitica,
  }) {
    if (nome.isEmpty) return 'Nome é obrigatório';
    if (email.isEmpty) return 'E-mail é obrigatório';
    if (senha.isEmpty) return 'Senha é obrigatória';
    if (senha.length < 6) return 'Senha deve ter 6 caracteres ou mais';
    if (senha != confirmacaoSenha) return 'As senhas não coincidem';
    if (!temObjetivos) return 'Selecione pelo menos um objetivo';
    if (!aceitouTermos || !aceitouPolitica) {
      return 'Aceite os termos e política';
    }

    return null; // null significa que não há erros
  }

  // Simular cadastro
  Future<bool> simularCadastro() async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Sempre retorna sucesso na simulação
  }

  //void cadastrarUsuario(String text, String text2, String text3) {}
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required List<String> objetivos,
  }) async {
    try {
      // 1. Criar usuário no Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: senha);

      // 2. Salvar dados extras no Firestore
      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
            'nome': nome,
            'email': email,
            'objetivos': objetivos,
            'dataCadastro': FieldValue.serverTimestamp(),
          });

      return null; // Cadastro bem-sucedido
    } catch (e) {
      return e.toString(); // Retorna a mensagem de erro
    }
  }
}
