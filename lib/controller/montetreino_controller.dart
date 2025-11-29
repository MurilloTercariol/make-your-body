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
  bool _jaCarregou = false; // Flag para evitar carregar múltiplas vezes

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
    'abductors',
    'adductors',
    'biceps',
    'calves',
    'chest',
    'forearms',
    'glutes',
    'hamstrings',
    'lats',
    'lower_back',
    'middle_back',
    'neck',
    'quadriceps',
    'traps',
    'triceps',
  ];

  // Mapear nomes dos músculos para português
  String nomeMusculoPortugues(String musculo) {
    switch (musculo.toLowerCase()) {
      case 'abductors':
        return 'Abdutores';
      case 'adductors':
        return 'Adutores';
      case 'biceps':
        return 'Bíceps';
      case 'calves':
        return 'Panturrilha';
      case 'chest':
        return 'Peito';
      case 'forearms':
        return 'Antebraços';
      case 'glutes':
        return 'Glúteos';
      case 'hamstrings':
        return 'Posterior';
      case 'lats':
        return 'Dorsais';
      case 'lower_back':
        return 'Parte Inferior das Costas';
      case 'middle_back':
        return 'Parte Média das Costas';
      case 'neck':
        return 'Pescoço';
      case 'quadriceps':
        return 'Quadríceps';
      case 'traps':
        return 'Trapézio';
      case 'all':
        return 'Todos';
      case 'triceps':
        return 'Tríceps';
      default:
        return musculo;
    }
  }

  // Buscar exercícios da API
  Future<void> buscarExercicios() async {
    // Se já carregou, apenas aplicar o filtro
    if (_jaCarregou && _todosExercicios.isNotEmpty) {
      _aplicarFiltro();
      return;
    }

    _setLoading(true);
    _setErro('');

    // Carregar exercícios de exemplo imediatamente
    _carregarExerciciosExemplo();
    _setLoading(false);

    // Buscar da API em segundo plano (opcional)
    if (!_jaCarregou) {
      _jaCarregou = true;
      _buscarExerciciosAPI();
    }
  }

  // Buscar exercícios da API em segundo plano
  Future<void> _buscarExerciciosAPI() async {
    try {
      List<ExercicioModel> todosExercicios = [];

      // Buscar todos os grupos musculares principais
      final musculos = [
        'chest',
        'biceps',
        'triceps',
        'quadriceps',
        'hamstrings',
        'calves',
        'lats',
        'middle_back',
        'lower_back',
        'abductors',
        'adductors',
        'glutes',
        'forearms',
        'traps',
        'neck',
      ];

      // Fazer requisições em paralelo (mais rápido que sequencial)
      final futures = musculos.map((musculo) async {
        try {
          final response = await http
              .get(
                Uri.parse(
                  'https://api.api-ninjas.com/v1/exercises?muscle=$musculo&offset=0',
                ),
                headers: {
                  'X-Api-Key': 'FKdtPSPnKdsgizlyPhcMfw==sdSlYZVhhP4JpoLZ',
                },
              )
              .timeout(const Duration(seconds: 5));

          if (response.statusCode == 200) {
            List<dynamic> data = json.decode(response.body);
            return data.map((json) => ExercicioModel.fromJson(json)).toList();
          }
        } catch (e) {
          debugPrint('Erro ao buscar $musculo: $e');
        }
        return <ExercicioModel>[];
      });

      // Aguardar todas as requisições
      final resultados = await Future.wait(futures);

      // Combinar todos os resultados
      for (var lista in resultados) {
        todosExercicios.addAll(lista);
      }

      if (todosExercicios.isNotEmpty) {
        // Combinar com exercícios de exemplo sem duplicar
        final idsExemplo = _todosExercicios.map((e) => e.id).toSet();
        final exerciciosNovos = todosExercicios
            .where((e) => !idsExemplo.contains(e.id))
            .toList();

        _todosExercicios.addAll(exerciciosNovos);
        _aplicarFiltro();
        notifyListeners();
        debugPrint('✅ ${exerciciosNovos.length} exercícios da API adicionados');
      }
    } catch (e) {
      // Ignora erro - já temos exercícios de exemplo
      debugPrint('Erro ao buscar da API: $e');
    }
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
