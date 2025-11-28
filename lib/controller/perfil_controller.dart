// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/usuario_model.dart';

class PerfilController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late UsuarioModel _usuarioAtual;
  bool _isLoading = false;
  String? _erro;

  UsuarioModel get usuarioAtual => _usuarioAtual;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  PerfilController() {
    _usuarioAtual = UsuarioModel(
      id: '',
      nome: '',
      email: '',
      objetivos: [],
    );
    carregarDadosUsuario();
  }

  // READ - Carregar dados do usuário
  Future<void> carregarDadosUsuario() async {
    try {
      _isLoading = true;
      _erro = null;
      notifyListeners();

      User? usuarioAtual = _auth.currentUser;
      if (usuarioAtual == null) {
        _erro = 'Usuário não autenticado';
        _isLoading = false;
        notifyListeners();
        return;
      }

      DocumentSnapshot doc =
          await _firestore.collection('usuarios').doc(usuarioAtual.uid).get();

      if (doc.exists) {
        _usuarioAtual = UsuarioModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        _usuarioAtual = UsuarioModel(
          id: usuarioAtual.uid,
          nome: '',
          email: usuarioAtual.email ?? '',
          objetivos: [],
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _erro = 'Erro ao carregar dados: $e';
      _isLoading = false;
      notifyListeners();
      print(_erro);
    }
  }

  // CREATE/UPDATE - Salvar dados do usuário
  Future<void> salvarDados({
    required String nome,
    required String email,
    required List<String> objetivos,
  }) async {
    try {
      _isLoading = true;
      _erro = null;
      notifyListeners();

      User? usuarioAtual = _auth.currentUser;
      if (usuarioAtual == null) {
        throw Exception('Usuário não autenticado');
      }

      UsuarioModel novoUsuario = UsuarioModel(
        id: usuarioAtual.uid,
        nome: nome,
        email: email,
        objetivos: objetivos,
      );

      await _firestore
          .collection('usuarios')
          .doc(usuarioAtual.uid)
          .set(novoUsuario.toMap(), SetOptions(merge: true));

      _usuarioAtual = novoUsuario;
      _isLoading = false;
      notifyListeners();

      print('Dados salvos com sucesso!');
    } catch (e) {
      _erro = 'Erro ao salvar dados: $e';
      _isLoading = false;
      notifyListeners();
      print(_erro);
    }
  }

  // DELETE - Apagar perfil do usuário
  Future<void> apagarDados() async {
    try {
      _isLoading = true;
      _erro = null;
      notifyListeners();

      User? usuarioAtual = _auth.currentUser;
      if (usuarioAtual == null) {
        throw Exception('Usuário não autenticado');
      }

      await _firestore.collection('usuarios').doc(usuarioAtual.uid).delete();

      _usuarioAtual = UsuarioModel(
        id: usuarioAtual.uid,
        nome: '',
        email: '',
        objetivos: [],
      );

      _isLoading = false;
      notifyListeners();

      print('Dados apagados com sucesso!');
    } catch (e) {
      _erro = 'Erro ao apagar dados: $e';
      _isLoading = false;
      notifyListeners();
      print(_erro);
    }
  }

  // Validar formulário
  String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }
}

