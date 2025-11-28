// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../controller/executar_treino_controller.dart';
import '../model/treino_salvo_model.dart';
import '../model/exercicio_model.dart';

class ExecutarTreinoView extends StatefulWidget {
  const ExecutarTreinoView({super.key});

  @override
  State<ExecutarTreinoView> createState() => _ExecutarTreinoViewState();
}

class _ExecutarTreinoViewState extends State<ExecutarTreinoView> {
  final ExecutarTreinoController _controller = ExecutarTreinoController();

  @override
  void initState() {
    super.initState();
    _controller.carregarConfiguracoes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recebe o treino passado como argumento
    final TreinoSalvoModel? treino =
        ModalRoute.of(context)?.settings.arguments as TreinoSalvoModel?;

    if (treino != null && _controller.treinoAtual == null) {
      _controller.iniciarTreino(treino);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Text(
              _controller.treinoAtual?.nome ?? 'EXECUTAR TREINO',
              style: const TextStyle(
                color: Color(0xFFF9C22E),
                fontFamily: 'LeagueGothic',
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFF9C22E)),
          onPressed: _mostrarDialogSairTreino,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFFF9C22E)),
            onPressed: _mostrarConfiguracoesDescanso,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.treinoAtual == null) {
            return const Center(
              child: Text(
                'Nenhum treino em execução',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (_controller.isDescansando) {
            return _buildTelaDescanso();
          }

          return _buildTelaExercicio();
        },
      ),
    );
  }

  Widget _buildTelaExercicio() {
    final exercicio = _controller.exercicioAtual;
    if (exercicio == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progresso do treino
          _buildProgressoTreino(),

          const SizedBox(height: 20),

          // Informações do exercício
          _buildInfoExercicio(exercicio),

          const SizedBox(height: 30),

          // Instruções
          _buildInstrucoes(exercicio),

          const SizedBox(height: 40),

          // Botões de controle
          _buildBotoesControle(),
        ],
      ),
    );
  }

  Widget _buildTelaDescanso() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _controller.isTimerEntreExercicios
                ? 'DESCANSO ENTRE EXERCÍCIOS'
                : 'DESCANSO ENTRE SÉRIES',
            style: const TextStyle(
              color: Color(0xFFF9C22E),
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueGothic',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Indicador de série atual (se não for entre exercícios)
          if (!_controller.isTimerEntreExercicios)
            Text(
              'Série ${_controller.serieAtual - 1} concluída',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

          const SizedBox(height: 20),

          // Timer grande
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF9C22E), width: 4),
            ),
            child: Center(
              child: Text(
                _controller.formatarTempo(_controller.tempoRestanteSegundos),
                style: const TextStyle(
                  color: Color(0xFFF9C22E),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Botões de controle do descanso
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _controller.adicionarTempo(-30),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  '-30s',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _controller.adicionarTempo(30),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  '+30s',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _controller.pularDescanso,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9C22E),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'PULAR DESCANSO',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Próximo exercício ou série
          if (_controller.isTimerEntreExercicios &&
              !_controller.isUltimoExercicio) ...[
            const Text(
              'PRÓXIMO EXERCÍCIO:',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _controller
                        .treinoAtual!
                        .exercicios[_controller.exercicioAtualIndex]
                        .name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nomeMusculoPortugues(
                      _controller
                          .treinoAtual!
                          .exercicios[_controller.exercicioAtualIndex]
                          .muscle,
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ] else if (!_controller.isTimerEntreExercicios) ...[
            const Text(
              'PRÓXIMA SÉRIE:',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Série ${_controller.serieAtual} de ${_controller.seriesPorExercicio}',
              style: const TextStyle(
                color: Color(0xFFF9C22E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressoTreino() {
    final progresso =
        (_controller.exercicioAtualIndex + 1) /
        _controller.treinoAtual!.exercicios.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercício ${_controller.exercicioAtualIndex + 1} de ${_controller.treinoAtual!.exercicios.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${(progresso * 100).round()}%',
              style: const TextStyle(
                color: Color(0xFFF9C22E),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Indicador de séries
        Text(
          'Série ${_controller.serieAtual} de ${_controller.seriesPorExercicio}',
          style: const TextStyle(
            color: Color(0xFFF9C22E),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progresso,
          backgroundColor: Colors.grey[800],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF9C22E)),
        ),
      ],
    );
  }

  Widget _buildInfoExercicio(ExercicioModel exercicio) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercicio.name,
            style: const TextStyle(
              color: Color(0xFFF9C22E),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                'Músculo',
                _nomeMusculoPortugues(exercicio.muscle),
              ),
              const SizedBox(width: 12),
              _buildInfoChip('Equipamento', exercicio.equipment),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoChip('Dificuldade', exercicio.difficulty),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $valor',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildInstrucoes(ExercicioModel exercicio) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMO EXECUTAR:',
            style: TextStyle(
              color: Color(0xFFF9C22E),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            exercicio.instructions,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotoesControle() {
    return Column(
      children: [
        // Navegação entre exercícios
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _controller.isPrimeiroExercicio
                    ? null
                    : _controller.exercicioAnterior,
                icon: const Icon(Icons.skip_previous),
                label: const Text('ANTERIOR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _controller.proximoExercicio,
                icon: const Icon(Icons.skip_next),
                label: Text(
                  _controller.isUltimoExercicio ? 'FINALIZAR' : 'PRÓXIMO',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Botão principal - Concluir série
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _controller.finalizarSerie,
            icon: const Icon(Icons.check_circle),
            label: Text(
              _controller.isUltimaSerie && _controller.isUltimoExercicio
                  ? 'FINALIZAR TREINO'
                  : _controller.isUltimaSerie
                  ? 'PRÓXIMO EXERCÍCIO'
                  : 'CONCLUIR SÉRIE ${_controller.serieAtual}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9C22E),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarDialogSairTreino() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Sair do Treino',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Deseja realmente sair? O progresso será perdido.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Continuar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.finalizarTreino();
              Navigator.pop(context); // Fechar dialog
              Navigator.pop(context); // Voltar para tela anterior
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _mostrarConfiguracoesDescanso() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Configuração de tempo entre séries
              const Text(
                'Tempo entre Séries',
                style: TextStyle(
                  color: Color(0xFFF9C22E),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...(_controller.opcoesTempoDescanso.map((tempo) {
                final isSelected = _controller.tempoDescansoSegundos == tempo;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio<int>(
                    value: tempo,
                    groupValue: _controller.tempoDescansoSegundos,
                    onChanged: (value) {
                      if (value != null) {
                        _controller.salvarTempoDescanso(value);
                      }
                    },
                    activeColor: const Color(0xFFF9C22E),
                  ),
                  title: Text(
                    _controller.formatarTempoOpcao(tempo),
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFF9C22E)
                          : Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _controller.salvarTempoDescanso(tempo);
                  },
                );
              }).toList()),

              const Divider(color: Colors.grey, height: 30),

              // Configuração de tempo entre exercícios
              const Text(
                'Tempo entre Exercícios',
                style: TextStyle(
                  color: Color(0xFFF9C22E),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...(_controller.opcoesTempoDescanso.map((tempo) {
                final isSelected =
                    _controller.tempoDescansoEntreExercicios == tempo;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio<int>(
                    value: tempo,
                    groupValue: _controller.tempoDescansoEntreExercicios,
                    onChanged: (value) {
                      if (value != null) {
                        _controller.salvarTempoDescansoEntreExercicios(value);
                      }
                    },
                    activeColor: const Color(0xFFF9C22E),
                  ),
                  title: Text(
                    _controller.formatarTempoOpcao(tempo),
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFF9C22E)
                          : Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _controller.salvarTempoDescansoEntreExercicios(tempo);
                  },
                );
              }).toList()),

              const Divider(color: Colors.grey, height: 30),

              // Configuração de séries por exercício
              const Text(
                'Séries por Exercício',
                style: TextStyle(
                  color: Color(0xFFF9C22E),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...(_controller.opcoesSeriesPorExercicio.map((series) {
                final isSelected = _controller.seriesPorExercicio == series;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio<int>(
                    value: series,
                    groupValue: _controller.seriesPorExercicio,
                    onChanged: (value) {
                      if (value != null) {
                        _controller.salvarSeriesPorExercicio(value);
                      }
                    },
                    activeColor: const Color(0xFFF9C22E),
                  ),
                  title: Text(
                    '$series série${series > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFF9C22E)
                          : Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _controller.salvarSeriesPorExercicio(series);
                  },
                );
              }).toList()),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9C22E),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'FECHAR',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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

  String _nomeMusculoPortugues(String musculo) {
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
      case 'abs':
        return 'Abdômen';
      case 'cardio':
        return 'Cardio';
      default:
        return musculo;
    }
  }
}
