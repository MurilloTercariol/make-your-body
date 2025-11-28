import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Importa o arquivo gerado pelo flutterfire configure

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_app/view/cadastro_view.dart';
import 'package:projeto_app/view/home_view.dart';
import 'package:projeto_app/view/esqueci_view.dart';
import 'package:projeto_app/view/sobre_view.dart';
import 'package:projeto_app/view/montetreino_view.dart';
import 'package:projeto_app/view/meustreinos_view.dart';
import 'package:projeto_app/view/perfilusuario_view.dart';
import 'package:projeto_app/view/executar_treino_view.dart';
import 'package:projeto_app/view/selecionar_treino_view.dart';

import 'controller/login_controller.dart';
import 'controller/esqueci_controller.dart';
import 'controller/meustreinos_controller.dart';
import 'view/login_view.dart';

final g = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Registrando os controllers como singleton
  g.registerSingleton<LoginController>(LoginController());
  g.registerSingleton<EsqueciController>(EsqueciController());
  g.registerSingleton<MeusTreinosController>(MeusTreinosController());

  runApp(DevicePreview(enabled: true, builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoginView(), // tela inicial
        '/login': (context) => const LoginView(), // tela de login
        '/home': (context) => const HomeView(), // tela após login
        '/cadastro': (context) => const CadastroView(), // tela de cadastro
        '/esqueci': (context) => const EsqueciView(), // tela recuperar senha
        '/sobre': (context) => const SobreView(), //tela sobre o app
        '/montetreino': (context) => const MonteTreinoView(), // monte seu treino
        '/meustreinos': (context) => const MeusTreinosView(), // meus treinos
        '/perfilusuario': (context) => const PerfilUsuarioView(), // perfil do usuário
        '/executartreino': (context) => const ExecutarTreinoView(), // executar treino
        '/selecionartreino': (context) => const SelecionarTreinoView(), // selecionar treino para executar
      },
    );
  }
}
