import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
              // Header com botões de voltar e sair
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
                  IconButton(
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Color(0xFFF9C22E),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
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
                    Navigator.pushNamed(context, '/treino');
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/montetreino');
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

              // Texto "ÚLTIMO TREINO:"
              const Text(
                'ÚLTIMO TREINO:',
                style: TextStyle(
                  color: Color(0xFFF9C22E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              // Container com treino e imagens
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E272F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TREINO A
                        const Text(
                          'TREINO A (PEITO + TRÍCEPS):',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Exercício 1
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'CrossOver Pegada Alta',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '4x12',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.timer,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '1\'30"',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset(
                                'CrossAlta.png',
                              ), // colocar imagem
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Tríceps Pulley',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '4x12',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.timer,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '1\'30"',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset('TricepsPulley.png'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Exercício 2
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Tríceps Francês',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '4x12',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.timer,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '1\'30"',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset('TricepsFrances.png'),
                            ),
                          ],
                        ),
                      ],
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
              onPressed: () {
                Navigator.pushNamed(context, '/meustreinos');
              },
            ),
            Icon(Icons.menu, color: Colors.black, size: 28),
            IconButton(
              icon: Icon(Icons.help_outline, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/sobre');
              },
            ),
            Icon(Icons.person_outline, color: Colors.black, size: 28),
          ],
        ),
      ),
    );
  }
}
