import 'package:flutter/material.dart';
import '../controller/login_controller.dart';
import '../service/treinos_usuario_service.dart';
import '../model/treino_salvo_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final TreinosUsuarioService _treinosService = TreinosUsuarioService();
  List<TreinoSalvoModel> _treinosRecentes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carregarTreinosRecentes();
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
      _carregarTreinosRecentes();
    }
  }

  Future<void> _carregarTreinosRecentes() async {
    setState(() => _carregando = true);
    _treinosRecentes = await _treinosService.listarTreinosRecentes(limite: 3);
    setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com botões de voltar, refresh e sair
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFF9C22E),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFFF9C22E),
                        ),
                        onPressed: _carregarTreinosRecentes,
                        tooltip: 'Atualizar treinos',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Color(0xFFF9C22E),
                        ),
                        onPressed: () async {
                          final loginController = LoginController();
                          await loginController.logout(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Título
              const Text(
                'PÁGINA INICIAL',
                style: TextStyle(
                  color: Color(0xFFF9C22E),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'LeagueGothic',
                ),
              ),
              const SizedBox(height: 20),

              // Container "Peso Record"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E272F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFF9C22E)),
                        SizedBox(width: 8),
                        Text(
                          'Peso Record',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Rosca Martelo ....................... 22KG\n'
                      'Rosca Scott ............................ 18KG\n'
                      'LegPress 45° ......................... 120KG',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botão grande "PUMP!"
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9C22E),
                    minimumSize: const Size(340, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/selecionartreino');
                  },
                  child: const Text(
                    'PUMP!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LeagueGothic',
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão "Monte seu Treino"
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(340, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color(0xFFF9C22E),
                        width: 2,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/montetreino');
                    _carregarTreinosRecentes(); // Refresh ao voltar
                  },
                  child: const Text(
                    'MONTE SEU TREINO',
                    style: TextStyle(
                      color: Color(0xFFF9C22E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LeagueGothic',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Texto "TREINOS RECENTES:"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TREINOS RECENTES:',
                    style: TextStyle(
                      color: Color(0xFFF9C22E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (!_carregando)
                    TextButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/meustreinos');
                        _carregarTreinosRecentes(); // Refresh ao voltar
                      },
                      child: const Text(
                        'Ver Todos',
                        style: TextStyle(
                          color: Color(0xFFF9C22E),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Container com treinos recentes do Firebase
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E272F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _carregando
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF9C22E),
                          ),
                        )
                      : _treinosRecentes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Nenhum treino criado ainda',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/montetreino',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF9C22E),
                                ),
                                child: const Text(
                                  'Criar Primeiro Treino',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _carregarTreinosRecentes,
                          child: ListView.separated(
                            itemCount: _treinosRecentes.length,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Colors.grey, height: 24),
                            itemBuilder: (context, index) {
                              final treino = _treinosRecentes[index];
                              return InkWell(
                                onTap: () async {
                                  // Navega para a tela de detalhes/execução do treino
                                  await Navigator.pushNamed(
                                    context,
                                    '/executartreino',
                                    arguments: treino,
                                  );
                                  _carregarTreinosRecentes(); // Refresh ao voltar
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              treino.nome,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFFF9C22E),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${treino.exercicios.length} exercícios',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Criado em ${_formatarData(treino.dataCriacao)}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (treino.ultimaExecucao != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Último treino: ${_formatarData(treino.ultimaExecucao!)}',
                                          style: const TextStyle(
                                            color: Color(0xFFF9C22E),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 60,
        color: const Color(0xFFF9C22E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.fitness_center, color: Colors.black, size: 28),
              onPressed: () async {
                await Navigator.pushNamed(context, '/meustreinos');
                _carregarTreinosRecentes(); // Refresh ao voltar
              },
            ),
            Icon(Icons.menu, color: Colors.black, size: 28),
            IconButton(
              icon: Icon(Icons.help_outline, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/sobre');
              },
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/perfilusuario');
              },
            ),
          ],
        ),
      ),
    );
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
