import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/treino_salvo_model.dart';
import '../model/exercicio_model.dart';

class MeusTreinosController extends ChangeNotifier {
  static const String _chavePreferences = 'meus_treinos';
  List<TreinoSalvoModel> _treinos = [];
  bool _isLoading = false;

  MeusTreinosController();

  List<TreinoSalvoModel> get treinos => _treinos;
  bool get isLoading => _isLoading;

  // Carregar treinos do SharedPreferences
  Future<void> carregarTreinos() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? treinosJson = prefs.getString(_chavePreferences);

      if (treinosJson != null) {
        final List<dynamic> data = json.decode(treinosJson);
        _treinos = data.map((json) => TreinoSalvoModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Erro ao carregar treinos: $e');
    }

    _setLoading(false);
  }

  // Salvar treinos no SharedPreferences
  Future<void> _salvarTreinos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String treinosJson = json.encode(
        _treinos.map((t) => t.toJson()).toList(),
      );
      await prefs.setString(_chavePreferences, treinosJson);
    } catch (e) {
      debugPrint('Erro ao salvar treinos: $e');
    }
  }

  // Adicionar novo treino
  Future<void> adicionarTreino(
    String nome,
    List<ExercicioModel> exercicios,
  ) async {
    final novoTreino = TreinoSalvoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      exercicios: exercicios,
      dataCriacao: DateTime.now(),
    );

    _treinos.insert(0, novoTreino); // Adiciona no início da lista
    await _salvarTreinos();
    notifyListeners();
  }

  // Editar nome do treino
  Future<void> editarNomeTreino(String treinoId, String novoNome) async {
    final index = _treinos.indexWhere((t) => t.id == treinoId);
    if (index != -1) {
      _treinos[index] = _treinos[index].copyWith(nome: novoNome);
      await _salvarTreinos();
      notifyListeners();
    }
  }

  // Excluir treino
  Future<void> excluirTreino(String treinoId) async {
    _treinos.removeWhere((t) => t.id == treinoId);
    await _salvarTreinos();
    notifyListeners();
  }

  // Duplicar treino
  Future<void> duplicarTreino(TreinoSalvoModel treino) async {
    final novoCopia = TreinoSalvoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: '${treino.nome} (Cópia)',
      exercicios: treino.exercicios,
      dataCriacao: DateTime.now(),
    );

    _treinos.insert(_treinos.indexOf(treino) + 1, novoCopia);
    await _salvarTreinos();
    notifyListeners();
  }

  // Marcar treino como executado
  Future<void> marcarTreinoExecutado(String treinoId) async {
    final index = _treinos.indexWhere((t) => t.id == treinoId);
    if (index != -1) {
      _treinos[index] = _treinos[index].copyWith(
        ultimaExecucao: DateTime.now(),
      );
      await _salvarTreinos();
      notifyListeners();
    }
  }

  // Obter treino por ID
  TreinoSalvoModel? obterTreino(String treinoId) {
    try {
      return _treinos.firstWhere((t) => t.id == treinoId);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
