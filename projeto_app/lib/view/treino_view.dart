import 'package:flutter/material.dart';

void main() {
  runApp(const BodybuilderApp());
}

class BodybuilderApp extends StatelessWidget {
  const BodybuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TreinoView(),
    );
  }
}

class TreinoView extends StatelessWidget {
  const TreinoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC727),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 520,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'SEJA BODYBUILDER',
                          style: TextStyle(
                            fontFamily: 'LeagueGothic',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9C22E),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'faça valer.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'TREINO A (PEITO + TRÍCEPS):',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 👉 Container com ListView dentro
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: const [
                          ExerciseTile(
                            name: 'CrossOver Pegada Alta',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'CrossAlta.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Supino Vertical Máquina',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'SupinoMaquina.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Peck Deck',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'PeckDeck.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Supino Inclinado Halter',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'SupinoInclinado.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Crucifixo Reto',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'CrucifixoReto.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Supino Reto Barra',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'SupinoRetoBarra.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Tríceps Francês',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'TricepsFrances.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Tríceps Pulley',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'TricepsPulley.png',
                          ),

                          SizedBox(height: 8),

                          ExerciseTile(
                            name: 'Tríceps Paralela',
                            series: '4x12',
                            tempo: "1'30\"",
                            image: 'TricepsParalela.png',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botão Finalizar
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC727),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'FINALIZAR',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final String name;
  final String series;
  final String tempo;
  final String image;

  const ExerciseTile({
    super.key,
    required this.name,
    required this.series,
    required this.tempo,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Parte textual
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(series, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(tempo, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          // Imagem
          const SizedBox(width: 8),
          Image.asset(
            image,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.fitness_center,
              color: Colors.white70,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
