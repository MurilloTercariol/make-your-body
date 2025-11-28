import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/exercicio_model.dart';

class MontetreinoController extends ChangeNotifier {
  List<ExercicioModel> _todosExercicios = [];
  final List<ExercicioModel> _exerciciosSelecionados = [];
  List<ExercicioModel> _exerciciosFiltrados = [];
  bool _isLoading = false;
  String _erro = '';
  String _filtroMusculo = 'all';

  // Getters
  List<ExercicioModel> get todosExercicios => _todosExercicios;
  List<ExercicioModel> get exerciciosSelecionados => _exerciciosSelecionados;
  List<ExercicioModel> get exerciciosFiltrados => _exerciciosFiltrados;
  bool get isLoading => _isLoading;
  String get erro => _erro;
  String get filtroMusculo => _filtroMusculo;

  // Lista de grupos musculares para filtro
  List<String> get gruposMusculares => [
    'all',
    'chest',
    'back',
    'shoulders',
    'biceps',
    'triceps',
    'legs',
    'abs',
    'cardio',
  ];

  // Mapear nomes dos músculos para português
  String nomeMusculoPortugues(String musculo) {
    switch (musculo.toLowerCase()) {
      case 'chest':
        return 'Peito';
      case 'back':
        return 'Costas';
      case 'shoulders':
        return 'Ombros';
      case 'biceps':
        return 'Bíceps';
      case 'triceps':
        return 'Tríceps';
      case 'legs':
        return 'Pernas';
      case 'quads':
        return 'Quadríceps';
      case 'hamstrings':
        return 'Posterior';
      case 'calves':
        return 'Panturrilha';
      case 'glutes':
        return 'Glúteos';
      case 'abs':
        return 'Abdomen';
      case 'cardio':
        return 'Cardio';
      case 'all':
        return 'Todos';
      default:
        return musculo;
    }
  }

  // Buscar exercícios da API
  Future<void> buscarExercicios() async {
    _setLoading(true);
    _setErro('');

    try {
      // Buscar exercícios de diferentes grupos musculares
      List<ExercicioModel> todosExercicios = [];

      for (String musculo in [
        'biceps',
        'triceps',
        'chest',
        'back',
        'shoulders',
        'legs',
        'abs',
      ]) {
        final response = await http.get(
          Uri.parse('https://api.api-ninjas.com/v1/exercises?muscle=$musculo'),
          headers: {'X-Api-Key': 'FKdtPSPnKdsgizlyPhcMfw==sdSlYZVhhP4JpoLZ'},
        );

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          List<ExercicioModel> exerciciosMusculo = data
              .map((json) => ExercicioModel.fromJson(json))
              .toList();
          todosExercicios.addAll(exerciciosMusculo);
        }
      }

      if (todosExercicios.isNotEmpty) {
        _todosExercicios = todosExercicios;
        _aplicarFiltro();
      } else {
        _carregarExerciciosExemplo();
      }
    } catch (e) {
      // Se houver erro de conexão, usar exercícios de exemplo
      _carregarExerciciosExemplo();
    }

    _setLoading(false);
  }

  // Carregar exercícios de exemplo (backup)
  void _carregarExerciciosExemplo() {
    _todosExercicios = [
      ExercicioModel(
        id: 'supino_reto',
        name: 'Supino Reto',
        type: 'strength',
        muscle: 'chest',
        equipment: 'barbell',
        difficulty: 'intermediate',
        instructions:
            'Deite-se no banco, segure a barra com as mãos afastadas na largura dos ombros. Abaixe a barra até o peito e empurre de volta.',
      ),
      ExercicioModel(
        id: 'agachamento',
        name: 'Agachamento',
        type: 'strength',
        muscle: 'legs',
        equipment: 'barbell',
        difficulty: 'intermediate',
        instructions:
            'Com a barra nos ombros, desça mantendo as costas retas até as coxas ficarem paralelas ao chão.',
      ),
      ExercicioModel(
        id: 'rosca_biceps',
        name: 'Rosca Bíceps',
        type: 'strength',
        muscle: 'biceps',
        equipment: 'dumbbell',
        difficulty: 'beginner',
        instructions:
            'Com os halteres nas mãos, flexione os cotovelos levando o peso em direção aos ombros.',
      ),
      ExercicioModel(
        id: 'puxada_frente',
        name: 'Puxada pela Frente',
        type: 'strength',
        muscle: 'back',
        equipment: 'cable',
        difficulty: 'intermediate',
        instructions:
            'Sentado na máquina, puxe a barra em direção ao peito contraindo as costas.',
      ),
      ExercicioModel(
        id: 'desenvolvimento_ombro',
        name: 'Desenvolvimento de Ombros',
        type: 'strength',
        muscle: 'shoulders',
        equipment: 'dumbbell',
        difficulty: 'intermediate',
        instructions:
            'Com halteres nas mãos, empurre os pesos para cima até os braços ficarem estendidos.',
      ),
      ExercicioModel(
        id: 'triceps_pulley',
        name: 'Tríceps no Pulley',
        type: 'strength',
        muscle: 'triceps',
        equipment: 'cable',
        difficulty: 'beginner',
        instructions:
            'Com a corda ou barra, empurre para baixo estendendo completamente os braços.',
      ),
      ExercicioModel(
        id: 'abdominais',
        name: 'Abdominal Tradicional',
        type: 'strength',
        muscle: 'abs',
        equipment: 'body_only',
        difficulty: 'beginner',
        instructions:
            'Deitado, flexione o tronco em direção aos joelhos contraindo o abdômen.',
      ),
      ExercicioModel(
        id: 'corrida',
        name: 'Corrida na Esteira',
        type: 'cardio',
        muscle: 'cardio',
        equipment: 'machine',
        difficulty: 'beginner',
        instructions:
            'Mantenha um ritmo constante adequado ao seu condicionamento físico.',
      ),
    ];
    _aplicarFiltro();
  }

  // Aplicar filtro por grupo muscular
  void aplicarFiltro(String musculo) {
    _filtroMusculo = musculo;
    _aplicarFiltro();
    notifyListeners();
  }

  void _aplicarFiltro() {
    if (_filtroMusculo == 'all') {
      _exerciciosFiltrados = List.from(_todosExercicios);
    } else {
      _exerciciosFiltrados = _todosExercicios
          .where(
            (exercicio) =>
                exercicio.muscle.toLowerCase() == _filtroMusculo.toLowerCase(),
          )
          .toList();
    }
  }

  // Adicionar exercício à seleção
  void adicionarExercicio(ExercicioModel exercicio) {
    if (!_exerciciosSelecionados.contains(exercicio)) {
      _exerciciosSelecionados.add(exercicio);
      notifyListeners();
    }
  }

  // Remover exercício da seleção
  void removerExercicio(ExercicioModel exercicio) {
    _exerciciosSelecionados.remove(exercicio);
    notifyListeners();
  }

  // Verificar se exercício está selecionado
  bool isExercicioSelecionado(ExercicioModel exercicio) {
    return _exerciciosSelecionados.contains(exercicio);
  }

  // Limpar seleção
  void limparSelecao() {
    _exerciciosSelecionados.clear();
    notifyListeners();
  }

  // Finalizar treino - agora retorna os exercícios selecionados para salvar
  List<ExercicioModel> finalizarTreino() {
    final exerciciosSelecionados = List<ExercicioModel>.from(
      _exerciciosSelecionados,
    );
    limparSelecao();
    return exerciciosSelecionados;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErro(String value) {
    _erro = value;
    notifyListeners();
  }
}
