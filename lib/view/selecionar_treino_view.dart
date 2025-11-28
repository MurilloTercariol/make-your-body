import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/meustreinos_controller.dart';
import '../model/treino_salvo_model.dart';
import '../service/treinos_usuario_service.dart';

class SelecionarTreinoView extends StatefulWidget {
  const SelecionarTreinoView({super.key});

  @override
  State<SelecionarTreinoView> createState() => _SelecionarTreinoViewState();
}

class _SelecionarTreinoViewState extends State<SelecionarTreinoView> {
  final TreinosUsuarioService _treinosService = TreinosUsuarioService();
  List<TreinoSalvoModel> _treinos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _carregarTreinos() async {
    setState(() => _carregando = true);
    _treinos = await _treinosService.listarTreinos();
    setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SELECIONE SEU TREINO',
          style: TextStyle(
            color: Color(0xFFF9C22E),
            fontFamily: 'LeagueGothic',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF9C22E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF9C22E)),
            )
          : _treinos.isEmpty
          ? _buildEstadoVazio()
          : RefreshIndicator(
              onRefresh: _carregarTreinos,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _treinos.length,
                itemBuilder: (context, index) {
                  final treino = _treinos[index];
                  return _buildCardTreino(treino);
                },
              ),
            ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Nenhum treino disponível',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Crie seu primeiro treino para começar!',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/montetreino');
            },
            icon: const Icon(Icons.add),
            label: const Text('CRIAR TREINO'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9C22E),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTreino(TreinoSalvoModel treino) {
    return Card(
      color: const Color(0xFF1E272F),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _iniciarTreino(treino),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      treino.nome,
                      style: const TextStyle(
                        color: Color(0xFFF9C22E),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LeagueGothic',
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.play_circle_filled,
                    color: Color(0xFFF9C22E),
                    size: 40,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${treino.exercicios.length} exercícios',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Criado em ${_formatarData(treino.dataCriacao)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              if (treino.ultimaExecucao != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Último treino: ${_formatarData(treino.ultimaExecucao!)}',
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _iniciarTreino(treino),
                  icon: const Icon(Icons.play_arrow, size: 24),
                  label: const Text(
                    'INICIAR TREINO',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9C22E),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _iniciarTreino(TreinoSalvoModel treino) {
    // Registrar execução no Firebase
    _treinosService.registrarExecucao(treino.id);

    // Navegar para tela de execução
    Navigator.pushNamed(context, '/executartreino', arguments: treino);
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) {
      return 'Hoje';
    } else if (diferenca.inDays == 1) {
      return 'Ontem';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays} dias atrás';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }
}
