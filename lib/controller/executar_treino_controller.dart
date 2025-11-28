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
  int _tempoDescansoEntreExercicios = 120; // Padrão 2:00 entre exercícios

  // Sistema de séries
  int _serieAtual = 1;
  int _seriesPorExercicio = 3; // Padrão 3 séries por exercício
  bool _isTimerEntreExercicios = false;

  // Getters
  TreinoSalvoModel? get treinoAtual => _treinoAtual;
  int get exercicioAtualIndex => _exercicioAtualIndex;
  ExercicioModel? get exercicioAtual =>
      _treinoAtual?.exercicios[_exercicioAtualIndex];
  bool get isDescansando => _isDescansando;
  int get tempoRestanteSegundos => _tempoRestanteSegundos;
  int get tempoDescansoSegundos => _tempoDescansoSegundos;
  int get tempoDescansoEntreExercicios => _tempoDescansoEntreExercicios;
  int get serieAtual => _serieAtual;
  int get seriesPorExercicio => _seriesPorExercicio;
  bool get isTimerEntreExercicios => _isTimerEntreExercicios;
  bool get isUltimoExercicio =>
      _exercicioAtualIndex >= (_treinoAtual?.exercicios.length ?? 0) - 1;
  bool get isPrimeiroExercicio => _exercicioAtualIndex == 0;
  bool get isUltimaSerie => _serieAtual >= _seriesPorExercicio;

  // Opções de tempo de descanso
  List<int> get opcoesTempoDescanso => [
    90,
    120,
    180,
    300,
  ]; // 1:30, 2:00, 3:00, 5:00

  // Opções de séries por exercício
  List<int> get opcoesSeriesPorExercicio => [1, 2, 3, 4, 5];

  static const String _chaveTempoDescanso = 'tempo_descanso_usuario';
  static const String _chaveTempoDescansoEntreExercicios =
      'tempo_descanso_entre_exercicios';
  static const String _chaveSeriesPorExercicio = 'series_por_exercicio';

  // Inicializar treino
  void iniciarTreino(TreinoSalvoModel treino) {
    _treinoAtual = treino;
    _exercicioAtualIndex = 0;
    _serieAtual = 1;
    _isDescansando = false;
    _isTimerEntreExercicios = false;
    _tempoRestanteSegundos = 0;
    _pararTimer();
    notifyListeners();
  }

  // Carregar configurações do usuário
  Future<void> carregarConfiguracoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _tempoDescansoSegundos = prefs.getInt(_chaveTempoDescanso) ?? 90;
      _tempoDescansoEntreExercicios =
          prefs.getInt(_chaveTempoDescansoEntreExercicios) ?? 120;
      _seriesPorExercicio = prefs.getInt(_chaveSeriesPorExercicio) ?? 3;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar configurações: $e');
    }
  }

  // Salvar tempo de descanso entre séries
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

  // Salvar tempo de descanso entre exercícios
  Future<void> salvarTempoDescansoEntreExercicios(int segundos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_chaveTempoDescansoEntreExercicios, segundos);
      _tempoDescansoEntreExercicios = segundos;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar tempo de descanso entre exercícios: $e');
    }
  }

  // Salvar número de séries por exercício
  Future<void> salvarSeriesPorExercicio(int series) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_chaveSeriesPorExercicio, series);
      _seriesPorExercicio = series;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar séries por exercício: $e');
    }
  }

  // Finalizar série
  void finalizarSerie() {
    if (_treinoAtual == null) return;

    if (_serieAtual < _seriesPorExercicio) {
      // Ainda há séries restantes neste exercício
      _serieAtual++;
      _isTimerEntreExercicios = false;
      _iniciarDescanso();
    } else {
      // Todas as séries completas, ir para próximo exercício
      _serieAtual = 1;
      if (!isUltimoExercicio) {
        _isTimerEntreExercicios = true;
        _exercicioAtualIndex++;
        _iniciarDescanso();
      } else {
        // Último exercício finalizado
        finalizarTreino();
      }
    }
  }

  // Finalizar exercício (mantido para compatibilidade)
  void finalizarExercicio() {
    finalizarSerie();
  }

  void _iniciarDescanso() {
    _isDescansando = true;
    // Usar tempo diferente se for entre exercícios ou entre séries
    _tempoRestanteSegundos = _isTimerEntreExercicios
        ? _tempoDescansoEntreExercicios
        : _tempoDescansoSegundos;
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
    _isTimerEntreExercicios = false;
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
    _isTimerEntreExercicios = false;

    if (!isUltimoExercicio) {
      _exercicioAtualIndex++;
      _serieAtual = 1; // Reinicia contador de séries
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
    _isTimerEntreExercicios = false;
    _exercicioAtualIndex--;
    _serieAtual = 1; // Reinicia contador de séries
    notifyListeners();
  }

  // Finalizar treino
  void finalizarTreino() {
    _pararTimer();
    _treinoAtual = null;
    _exercicioAtualIndex = 0;
    _serieAtual = 1;
    _isDescansando = false;
    _isTimerEntreExercicios = false;
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
