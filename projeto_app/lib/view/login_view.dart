// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:projeto_app/controller/login_controller.dart';

// Classe principal da tela de Login
// StatefulWidget é usada quando a tela precisa mudar (ex: atualizar dados, mostrar mensagens, etc)
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Estado da tela (onde fica a parte "viva" que pode mudar)
class _LoginViewState extends State<LoginView> {
  //chave para o formulário

  //controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //instancia do controller de login
  final LoginController _loginController = LoginController();

  //Limpar os controladores quando o widget for descartado
  @override
  void initState() {
    super.initState();
    _loginController.context = context;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var elevatedButton = ElevatedButton(
      onPressed: () {
        //vai para controller de login
        _loginController.login(_emailController.text, _passwordController.text);
        // Aqui você colocaria a lógica do login
        // Exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => OutraTela()));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: const Text(
        'Entrar',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF9C22E),
        ),
      ),
    );
    return Scaffold(
      // O Scaffold é a estrutura base de uma tela no Flutter
      body: Container(
        // Faz o container ocupar toda a tela
        width: double.infinity,
        height: double.infinity,

        // Fundo com um degradê (do cinza escuro ao preto)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 32, 32, 32),
              Color.fromARGB(255, 2, 3, 4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // Centraliza o conteúdo no meio da tela
        child: Center(
          // Container principal (a "caixinha" do login)
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),

            // Estilo do container
            decoration: BoxDecoration(
              color: const Color(
                0xFFF9C22E,
              ).withOpacity(0.9), // Amarelo com transparência
              borderRadius: BorderRadius.circular(16), // Cantos arredondados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            // Coluna com os elementos da tela (um embaixo do outro)
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título principal
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 24.0,
                ), // Espaço entre o título e o campo de e-mail
                // Campo de e-mail
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0), // Espaço entre o e-mail e a senha
                // Campo de senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Oculta os caracteres da senha
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8.0,
                ), // Espaço entre a senha e o esqueci minha senha
                // Link "Esqueci minha senha"
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Aqui você colocaria a lógica para recuperar a senha
                    },
                    child: const Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24.0), // Espaço antes do botão
                // Botão "Entrar"
                SizedBox(
                  width: double
                      .infinity, // Faz o botão ocupar toda a largura do container
                  child: elevatedButton,
                ),

                const SizedBox(height: 16.0),
                // Espaço antes do link de cadastro
                // Link "Criar uma conta"
                SizedBox(
                  width: double
                      .infinity, // Faz o botão ocupar toda a largura do container
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Criar uma conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF9C22E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
