import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/meustreinos_controller.dart';
import '../model/treino_salvo_model.dart';

class MeusTreinosView extends StatefulWidget {
  const MeusTreinosView({super.key});

  @override
  State<MeusTreinosView> createState() => _MeusTreinosViewState();
}

class _MeusTreinosViewState extends State<MeusTreinosView>
    with WidgetsBindingObserver {
  late final MeusTreinosController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = GetIt.instance.get<MeusTreinosController>();
    _carregarTreinos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App voltou ao foreground - recarrega treinos
      _carregarTreinos();
    }
  }

  Future<void> _carregarTreinos() async {
    await _controller.carregarTreinos();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'MEUS TREINOS',
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
            icon: const Icon(Icons.refresh, color: Color(0xFFF9C22E)),
            onPressed: _carregarTreinos,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFF9C22E)),
            onPressed: () async {
              await Navigator.pushNamed(context, '/montetreino');
              _carregarTreinos(); // Recarrega ao voltar
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF9C22E)),
            );
          }

          if (_controller.treinos.isEmpty) {
            return _buildEstadoVazio();
          }

          return RefreshIndicator(
            onRefresh: _carregarTreinos,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _controller.treinos.length,
              itemBuilder: (context, index) {
                final treino = _controller.treinos[index];
                return _buildCardTreino(treino);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Nenhum treino criado ainda',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crie seu primeiro treino!',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/montetreino'),
            icon: const Icon(Icons.add),
            label: const Text('Criar Treino'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9C22E),
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTreino(TreinoSalvoModel treino) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    treino.nome,
                    style: const TextStyle(
                      color: Color(0xFFF9C22E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Colors.grey[800],
                  onSelected: (value) => _executarAcaoTreino(value, treino),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Editar Nome',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicar',
                      child: Row(
                        children: [
                          Icon(Icons.copy, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Duplicar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'excluir',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${treino.exercicios.length} exercicios',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Criado em ${_formatarData(treino.dataCriacao)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (treino.ultimaExecucao != null) ...[
              const SizedBox(height: 4),
              Text(
                'Ultimo treino: ${_formatarData(treino.ultimaExecucao!)}',
                style: const TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Lista previa dos exercicios
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: treino.exercicios.length,
                itemBuilder: (context, index) {
                  final exercicio = treino.exercicios[index];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercicio.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _nomeMusculoPortugues(exercicio.muscle),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          exercicio.difficulty,
                          style: TextStyle(
                            color: _corDificuldade(exercicio.difficulty),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Botao para iniciar treino
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _iniciarTreino(treino),
                icon: const Icon(Icons.play_arrow),
                label: const Text('INICIAR TREINO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9C22E),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _executarAcaoTreino(String acao, TreinoSalvoModel treino) {
    switch (acao) {
      case 'editar':
        _mostrarDialogEditarNome(treino);
        break;
      case 'duplicar':
        _duplicarTreino(treino);
        break;
      case 'excluir':
        _mostrarDialogConfirmarExclusao(treino);
        break;
    }
  }

  Future<void> _duplicarTreino(TreinoSalvoModel treino) async {
    final sucesso = await _controller.duplicarTreino(treino);

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Treino duplicado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Erro ao duplicar treino'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarDialogEditarNome(TreinoSalvoModel treino) {
    final TextEditingController nomeController = TextEditingController(
      text: treino.nome,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Editar Nome do Treino',
          style: TextStyle(color: Color(0xFFF9C22E)),
        ),
        content: TextField(
          controller: nomeController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nome do treino',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF9C22E)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF9C22E)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final novoNome = nomeController.text.trim();
              if (novoNome.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nome não pode estar vazio'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.pop(context);

              final sucesso = await _controller.editarNomeTreino(
                treino.id,
                novoNome,
              );

              if (!mounted) return;

              if (sucesso) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Nome atualizado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Erro ao atualizar nome'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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

  void _mostrarDialogConfirmarExclusao(TreinoSalvoModel treino) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Confirmar Exclusao',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          'Deseja realmente excluir o treino "${treino.nome}"?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final sucesso = await _controller.excluirTreino(treino.id);

              if (!mounted) return;

              if (sucesso) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Treino excluído com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Erro ao excluir treino'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _iniciarTreino(TreinoSalvoModel treino) {
    Navigator.pushNamed(context, '/executartreino', arguments: treino);
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _nomeMusculoPortugues(String musculo) {
    switch (musculo.toLowerCase()) {
      case 'chest':
        return 'Peito';
      case 'back':
        return 'Costas';
      case 'shoulders':
        return 'Ombros';
      case 'biceps':
        return 'Biceps';
      case 'triceps':
        return 'Triceps';
      case 'legs':
        return 'Pernas';
      case 'abs':
        return 'Abdomen';
      case 'cardio':
        return 'Cardio';
      default:
        return musculo;
    }
  }

  Color _corDificuldade(String dificuldade) {
    switch (dificuldade.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'expert':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
