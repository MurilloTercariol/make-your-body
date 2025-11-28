import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/montetreino_controller.dart';
import '../controller/meustreinos_controller.dart';
import '../model/exercicio_model.dart';

class MonteTreinoView extends StatefulWidget {
  const MonteTreinoView({super.key});

  @override
  State<MonteTreinoView> createState() => _MonteTreinoViewState();
}

class _MonteTreinoViewState extends State<MonteTreinoView> {
  final MontetreinoController _controller = MontetreinoController();
  String _pesquisa = '';

  @override
  void initState() {
    super.initState();
    _controller.buscarExercicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'MONTE SEU TREINO',
          style: TextStyle(
            color: Color(0xFFF9C22E),
            fontFamily: 'LeagueGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF9C22E)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.playlist_add_check, color: Color(0xFFF9C22E)),
                if (_controller.exerciciosSelecionados.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${_controller.exerciciosSelecionados.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _mostrarExerciciosSelecionados,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF9C22E)),
            );
          }

          if (_controller.erro.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    _controller.erro,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Filtro por grupo muscular
              _buildFiltroMusculo(),

              // Barra de pesquisa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _pesquisa = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar exercício...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _pesquisa.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _pesquisa = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFF9C22E),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFF9C22E),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Lista de exercícios
              Expanded(child: _buildListaExercicios()),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.exerciciosSelecionados.isEmpty) {
            return const SizedBox();
          }

          return FloatingActionButton.extended(
            onPressed: _finalizarTreino,
            backgroundColor: const Color(0xFFF9C22E),
            foregroundColor: Colors.black,
            label: Text(
              'Finalizar (${_controller.exerciciosSelecionados.length})',
            ),
            icon: const Icon(Icons.check),
          );
        },
      ),
    );
  }

  Widget _buildFiltroMusculo() {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.gruposMusculares.length,
        itemBuilder: (context, index) {
          final musculo = _controller.gruposMusculares[index];
          final isSelected = _controller.filtroMusculo == musculo;

          return GestureDetector(
            onTap: () => _controller.aplicarFiltro(musculo),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF9C22E) : Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFF9C22E)
                      : Colors.grey[600]!,
                ),
              ),
              child: Center(
                child: Text(
                  _controller.nomeMusculoPortugues(musculo),
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListaExercicios() {
    // Filtrar exercícios por pesquisa (case-insensitive)
    final exerciciosFiltrados = _controller.exerciciosFiltrados
        .where((exercicio) =>
            exercicio.name.toLowerCase().contains(_pesquisa.toLowerCase()) ||
            _controller
                .nomeMusculoPortugues(exercicio.muscle)
                .toLowerCase()
                .contains(_pesquisa.toLowerCase()))
        .toList();

    if (_controller.exerciciosFiltrados.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum exercício encontrado',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (exerciciosFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Nenhum exercício encontrado para "$_pesquisa"',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: exerciciosFiltrados.length,
      itemBuilder: (context, index) {
        final exercicio = exerciciosFiltrados[index];
        final isSelected = _controller.isExercicioSelecionado(exercicio);

        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isSelected
                  ? const Color(0xFFF9C22E)
                  : Colors.grey[700],
              child: Text(
                exercicio.muscle[0].toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              exercicio.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Músculo: ${_controller.nomeMusculoPortugues(exercicio.muscle)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Equipamento: ${exercicio.equipment}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Dificuldade: ${exercicio.difficulty}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isSelected ? Icons.remove_circle : Icons.add_circle,
                color: isSelected ? Colors.red : const Color(0xFFF9C22E),
              ),
              onPressed: () {
                if (isSelected) {
                  _controller.removerExercicio(exercicio);
                } else {
                  _controller.adicionarExercicio(exercicio);
                }
              },
            ),
            onTap: () => _mostrarDetalhesExercicio(exercicio),
          ),
        );
      },
    );
  }

  void _mostrarDetalhesExercicio(ExercicioModel exercicio) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercicio.name,
              style: const TextStyle(
                color: Color(0xFFF9C22E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Músculo: ${_controller.nomeMusculoPortugues(exercicio.muscle)}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Equipamento: ${exercicio.equipment}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Dificuldade: ${exercicio.difficulty}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instruções:',
              style: TextStyle(
                color: Color(0xFFF9C22E),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercicio.instructions,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_controller.isExercicioSelecionado(exercicio)) {
                        _controller.removerExercicio(exercicio);
                      } else {
                        _controller.adicionarExercicio(exercicio);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _controller.isExercicioSelecionado(exercicio)
                          ? Colors.red
                          : const Color(0xFFF9C22E),
                    ),
                    child: Text(
                      _controller.isExercicioSelecionado(exercicio)
                          ? 'Remover do Treino'
                          : 'Adicionar ao Treino',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarExerciciosSelecionados() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Exercícios Selecionados (${_controller.exerciciosSelecionados.length})',
                style: const TextStyle(
                  color: Color(0xFFF9C22E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _controller.exerciciosSelecionados.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum exercício selecionado',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _controller.exerciciosSelecionados.length,
                        itemBuilder: (context, index) {
                          final exercicio =
                              _controller.exerciciosSelecionados[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFF9C22E),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              exercicio.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              _controller.nomeMusculoPortugues(
                                exercicio.muscle,
                              ),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _controller.removerExercicio(exercicio),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _controller.exerciciosSelecionados.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context);
                              _controller.limparSelecao();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Limpar Tudo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _controller.exerciciosSelecionados.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context);
                              _finalizarTreino();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9C22E),
                      ),
                      child: const Text(
                        'Finalizar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finalizarTreino() {
    if (_controller.exerciciosSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um exercício'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _mostrarDialogNomeTreino();
  }

  void _mostrarDialogNomeTreino() {
    final TextEditingController nomeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Nome do Treino',
          style: TextStyle(color: Color(0xFFF9C22E)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dê um nome para seu treino com ${_controller.exerciciosSelecionados.length} exercícios:',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomeController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ex: Treino de Peito e Tríceps',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF9C22E)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF9C22E)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              String nome = nomeController.text.trim();
              if (nome.isEmpty) {
                nome =
                    'Meu Treino ${DateTime.now().day}/${DateTime.now().month}';
              }
              _salvarTreino(nome);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9C22E),
            ),
            child: const Text('Salvar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _salvarTreino(String nome) async {
    final exerciciosSelecionados = _controller.finalizarTreino();

    final meusTreinosController = GetIt.instance.get<MeusTreinosController>();

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFF9C22E)),
      ),
    );

    final sucesso = await meusTreinosController.adicionarTreino(
      nome,
      exerciciosSelecionados,
    );

    if (!mounted) return;

    Navigator.pop(context); // Fechar loading
    Navigator.pop(context); // Fechar dialog do nome

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Treino "$nome" salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Ver Treinos',
            textColor: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/meustreinos'),
          ),
        ),
      );
      Navigator.pop(context); // Voltar para a tela anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Erro ao salvar treino. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
