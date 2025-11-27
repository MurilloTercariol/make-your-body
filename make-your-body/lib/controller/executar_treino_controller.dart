import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/treino_salvo_model.dart';
import '../model/exercicio_model.dart';

class ExecutarTreinoController extends ChangeNotifier {
  TreinoSalvoModel? _treinoAtual;
  int _exercicioAtualIndex = 0;
  bool _isDescansando = false;
  int _tempoRestanteSegundos = 0;
  Timer? _timer;

  // Configurações de tempo de descanso do usuário
  int _tempoDescansoSegundos = 90; // Padrão 1:30

  // Getters
  TreinoSalvoModel? get treinoAtual => _treinoAtual;
  int get exercicioAtualIndex => _exercicioAtualIndex;
  ExercicioModel? get exercicioAtual =>
      _treinoAtual?.exercicios[_exercicioAtualIndex];
  bool get isDescansando => _isDescansando;
  int get tempoRestanteSegundos => _tempoRestanteSegundos;
  int get tempoDescansoSegundos => _tempoDescansoSegundos;
  bool get isUltimoExercicio =>
      _exercicioAtualIndex >= (_treinoAtual?.exercicios.length ?? 0) - 1;
  bool get isPrimeiroExercicio => _exercicioAtualIndex == 0;

  // Opções de tempo de descanso
  List<int> get opcoesTempoDescanso => [
    90,
    120,
    180,
    300,
  ]; // 1:30, 2:00, 3:00, 5:00

  static const String _chaveTempoDescanso = 'tempo_descanso_usuario';

  // Inicializar treino
  void iniciarTreino(TreinoSalvoModel treino) {
    _treinoAtual = treino;
    _exercicioAtualIndex = 0;
    _isDescansando = false;
    _tempoRestanteSegundos = 0;
    _pararTimer();
    notifyListeners();
  }

  // Carregar configurações do usuário
  Future<void> carregarConfiguracoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _tempoDescansoSegundos = prefs.getInt(_chaveTempoDescanso) ?? 90;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar configurações: $e');
    }
  }

  // Salvar tempo de descanso
  Future<void> salvarTempoDescanso(int segundos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_chaveTempoDescanso, segundos);
      _tempoDescansoSegundos = segundos;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar tempo de descanso: $e');
    }
  }

  // Finalizar exercício e iniciar descanso
  void finalizarExercicio() {
    if (_treinoAtual == null) return;

    if (!isUltimoExercicio) {
      _iniciarDescanso();
    } else {
      // Último exercício - finalizar treino
      finalizarTreino();
    }
  }

  void _iniciarDescanso() {
    _isDescansando = true;
    _tempoRestanteSegundos = _tempoDescansoSegundos;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tempoRestanteSegundos > 0) {
        _tempoRestanteSegundos--;
        notifyListeners();
      } else {
        _finalizarDescanso();
      }
    });
  }

  void _finalizarDescanso() {
    _pararTimer();
    _isDescansando = false;
    _tempoRestanteSegundos = 0;
    _exercicioAtualIndex++;
    notifyListeners();
  }

  // Pular descanso
  void pularDescanso() {
    if (_isDescansando) {
      _finalizarDescanso();
    }
  }

  // Adicionar/remover tempo do descanso
  void adicionarTempo(int segundos) {
    if (_isDescansando) {
      _tempoRestanteSegundos += segundos;
      if (_tempoRestanteSegundos < 0) _tempoRestanteSegundos = 0;
      notifyListeners();
    }
  }

  // Ir para próximo exercício (sem descanso)
  void proximoExercicio() {
    if (_treinoAtual == null) return;

    _pararTimer();
    _isDescansando = false;
    _tempoRestanteSegundos = 0;

    if (!isUltimoExercicio) {
      _exercicioAtualIndex++;
    } else {
      finalizarTreino();
    }
    notifyListeners();
  }

  // Ir para exercício anterior
  void exercicioAnterior() {
    if (_treinoAtual == null || isPrimeiroExercicio) return;

    _pararTimer();
    _isDescansando = false;
    _tempoRestanteSegundos = 0;
    _exercicioAtualIndex--;
    notifyListeners();
  }

  // Finalizar treino
  void finalizarTreino() {
    _pararTimer();
    _treinoAtual = null;
    _exercicioAtualIndex = 0;
    _isDescansando = false;
    _tempoRestanteSegundos = 0;
    notifyListeners();
  }

  void _pararTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Formatador de tempo para exibição
  String formatarTempo(int segundos) {
    final minutes = segundos ~/ 60;
    final secs = segundos % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String formatarTempoOpcao(int segundos) {
    final minutes = segundos ~/ 60;
    final secs = segundos % 60;
    if (secs == 0) {
      return '${minutes}min';
    } else {
      return '$minutes:${secs.toString().padLeft(2, '0')}min';
    }
  }

  @override
  void dispose() {
    _pararTimer();
    super.dispose();
  }
}
