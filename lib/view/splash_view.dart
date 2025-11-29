import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/montetreino_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _statusText = 'Carregando exercícios...';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    _preCarregarDados();
  }

  Future<void> _preCarregarDados() async {
    try {
      // Criar e registrar o controller de exercícios se ainda não existir
      final g = GetIt.instance;

      // Verificar se já existe
      MontetreinoController controller;
      if (!g.isRegistered<MontetreinoController>()) {
        controller = MontetreinoController();
        g.registerSingleton<MontetreinoController>(controller);
      } else {
        controller = g.get<MontetreinoController>();
      }

      // Buscar exercícios da API
      await controller.buscarExercicios();

      // Aguardar um mínimo de tempo para mostrar a splash
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _statusText = 'Pronto!';
      });

      // Aguardar animação
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navegar para a home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Erro ao pré-carregar dados: $e');

      setState(() {
        _statusText = 'Erro ao carregar. Continuando...';
      });

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(17, 17, 17, 0.878),
              Color.fromRGBO(0, 0, 0, 1),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Nome do App
              const Text(
                'MAKE YOUR BODY',
                style: TextStyle(
                  fontFamily: 'LeagueGothic',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9C22E),
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Transforme seu corpo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: 'LeagueGothic',
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 60),

              // Loading indicator
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Color(0xFFF9C22E),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),

              // Status text
              Text(
                _statusText,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
