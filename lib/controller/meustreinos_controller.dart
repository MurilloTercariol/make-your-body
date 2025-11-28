import 'package:flutter/material.dart';
import '../model/treino_salvo_model.dart';
import '../model/exercicio_model.dart';
import '../service/treinos_usuario_service.dart';

class MeusTreinosController extends ChangeNotifier {
  final TreinosUsuarioService _service = TreinosUsuarioService();
  List<TreinoSalvoModel> _treinos = [];
  bool _isLoading = false;

  MeusTreinosController();

  List<TreinoSalvoModel> get treinos => _treinos;
  bool get isLoading => _isLoading;

  // Carregar treinos do Firebase
  Future<void> carregarTreinos() async {
    _setLoading(true);

    try {
      _treinos = await _service.listarTreinos();
      debugPrint('✅ ${_treinos.length} treinos carregados do Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao carregar treinos: $e');
    }

    _setLoading(false);
  }

  // Adicionar novo treino no Firebase
  Future<bool> adicionarTreino(
    String nome,
    List<ExercicioModel> exercicios,
  ) async {
    try {
      debugPrint(
        '🔵 Controller: Adicionando treino "$nome" com ${exercicios.length} exercícios',
      );

      final treinoId = await _service.criarTreino(
        nome: nome,
        exercicios: exercicios,
      );

      debugPrint('🔵 Controller: Resultado do service - treinoId: $treinoId');

      if (treinoId != null) {
        debugPrint('🔵 Controller: Recarregando lista de treinos...');
        await carregarTreinos(); // Recarrega lista
        debugPrint('✅ Controller: Treino adicionado com sucesso!');
        return true;
      }

      debugPrint('❌ Controller: treinoId é nulo - falha ao salvar');
      return false;
    } catch (e) {
      debugPrint('❌ Erro ao adicionar treino: $e');
      debugPrint('❌ Stack: ${StackTrace.current}');
      return false;
    }
  }

  // Editar nome do treino no Firebase
  Future<bool> editarNomeTreino(String treinoId, String novoNome) async {
    try {
      final index = _treinos.indexWhere((t) => t.id == treinoId);
      if (index != -1) {
        final treinoAtualizado = _treinos[index].copyWith(nome: novoNome);
        final sucesso = await _service.atualizarTreino(treinoAtualizado);

        if (sucesso) {
          _treinos[index] = treinoAtualizado;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('❌ Erro ao editar treino: $e');
      return false;
    }
  }

  // Excluir treino do Firebase
  Future<bool> excluirTreino(String treinoId) async {
    try {
      final sucesso = await _service.deletarTreino(treinoId);

      if (sucesso) {
        _treinos.removeWhere((t) => t.id == treinoId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Erro ao excluir treino: $e');
      return false;
    }
  }

  // Duplicar treino
  Future<bool> duplicarTreino(TreinoSalvoModel treino) async {
    try {
      final novoNome = '${treino.nome} (Cópia)';
      final treinoId = await _service.criarTreino(
        nome: novoNome,
        exercicios: treino.exercicios,
      );

      if (treinoId != null) {
        await carregarTreinos();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Erro ao duplicar treino: $e');
      return false;
    }
  }

  // Marcar treino como executado
  Future<bool> marcarTreinoExecutado(String treinoId) async {
    try {
      final sucesso = await _service.registrarExecucao(treinoId);

      if (sucesso) {
        final index = _treinos.indexWhere((t) => t.id == treinoId);
        if (index != -1) {
          _treinos[index] = _treinos[index].copyWith(
            ultimaExecucao: DateTime.now(),
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Erro ao marcar execução: $e');
      return false;
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
