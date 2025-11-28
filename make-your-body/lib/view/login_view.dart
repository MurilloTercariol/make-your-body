// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/login_controller_basic.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Adicione esta linha
  final LoginController _loginController = LoginController();

  @override
  void initState() {
    super.initState();
    _loginController = GetIt.instance.get<LoginControllerBasic>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _passwordController.text;

    // Validar email
    String? erro = _loginController.validarEmail(email);
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
      return;
    }

    // Validar senha
    erro = _loginController.validarSenha(senha);
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
      return;
    }

    // Fazer login
    erro = await _loginController.login(email: email, senha: senha);

    if (!mounted) return;

    if (erro == null) {
      // Login bem-sucedido
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Erro no login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
    );

    var elevatedButton = ElevatedButton(
      onPressed: () async {
        String? erro = await _loginController.loginComFirebase(
          _emailController.text,
          _passwordController.text,
          context,
        );

        if (erro == null) {
          // Login bem-sucedido - ir para a tela principal
          Navigator.pushNamed(context, '/home');
        }
        // Se houver erro, o SnackBar já foi mostrado no controller
      },
      style: customButtonStyle,
      child: AnimatedBuilder(
        animation: _loginController,
        builder: (context, child) {
          if (_loginController.isLoading) {
            return const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFF9C22E),
                strokeWidth: 2,
              ),
            );
          }
          return const Text(
            'Entrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF9C22E),
            ),
          );
        },
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'Logo2.png',
                width: 175,
                height: 175,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),

              Container(
                width: 320,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9C22E).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24.0),

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

                    const SizedBox(height: 16.0),

                    // Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Link "Esqueci minha senha"
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/esqueci');
                        },
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Botão Entrar
                    SizedBox(width: double.infinity, child: elevatedButton),

                    const SizedBox(height: 16.0),

                    // Botão Criar conta
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        style: customButtonStyle,
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
            ],
          ),
        ),
      ),
    );
  }
}
