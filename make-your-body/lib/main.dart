import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Importa o arquivo gerado pelo flutterfire configure

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:firebase_core/firebase_core.dart'; // Firebase removido
import 'package:projeto_app/view/cadastro_view.dart';
import 'package:projeto_app/view/home_view.dart';
import 'package:projeto_app/view/esqueci_view.dart';
import 'package:projeto_app/view/sobre_view.dart';
import 'package:projeto_app/view/treino_view.dart';

import 'controller/login_controller.dart';
import 'view/login_view.dart';

final g = GetIt.instance;

void main() {
  // Registrando o LoginController como singleton
  g.registerSingleton<LoginController>(LoginController());

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
        '/treino': (context) => TreinoView(), // tela treino
        '/sobre':(context) => const SobreView() //tela sobre o app
      },
    );
  }
}
