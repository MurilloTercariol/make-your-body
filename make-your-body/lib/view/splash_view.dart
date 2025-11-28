import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _inicializarApp();
  }

  Future<void> _inicializarApp() async {
    // Aguardar um pouco para mostrar a splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Verificar se o usuario ja esta logado
    final authService = AuthService();
    final isLoggedIn = await authService.verificarLogin();

    if (!mounted) return;

    if (isLoggedIn) {
      // Usuario ja esta logado, ir para a home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Usuario nao esta logado, ir para o login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo do app
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF9C22E),
                borderRadius: BorderRadius.circular(75),
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            // Nome do app
            const Text(
              'MAKE YOUR BODY',
              style: TextStyle(
                color: Color(0xFFF9C22E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LeagueGothic',
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Seu app de treinos personalizado',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 50),

            // Loading indicator
            const CircularProgressIndicator(
              color: Color(0xFFF9C22E),
              strokeWidth: 3,
            ),

            const SizedBox(height: 20),

            const Text(
              'Carregando...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
