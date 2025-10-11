import 'package:flutter/material.dart';


class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0), 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height:15),

            // Título
            const Text(
              'QUEM SOMOS',
              style: TextStyle(
                fontFamily: 'LeagueGothic',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF9C22E),
              ),
            ),

            const SizedBox(height: 20),

            // Retângulo 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 300, 
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9C22E),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: const SingleChildScrollView(
                  child: Text(
                    'Um aplicativo criado para a disciplina de Programação de Dispositivos Móveis.'
                    '\n\n'
                    'Este aplicativo foi desenvolvido com o objetivo de ajudar '
                    'pessoas a realizarem seus treinos na academia de forma mais eficiente. '
                    'Entre suas funcionalidades, estão o registro de peso recorde, adição de peso '
                    'personalizado, marcação de exercícios como concluídos e muito mais.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Retângulo 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 180, 
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9C22E),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: const SingleChildScrollView(
                  child: Text(
                    'Nomes Integrantes: \n'
                    'Kauã Henrique Medeiros da Silva \n'
                    'Murillo Oliveira Terçariol ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Image.asset(
              'Logo2.png', 
              width: 125,
              height: 125,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            // Botão "BACK"
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9C22E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'BACK',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}