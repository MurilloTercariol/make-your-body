import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_app/controller/cadastro_controller_basic.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  late final CadastroControllerBasic _cadastroController;

  // Controllers para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Adicione estas duas linhas:
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Estados para os checkboxes
  bool _hiperChecked = false;
  bool _perderChecked = false;
  bool _resilienciaChecked = false;
  bool _termosChecked = false;
  bool _dependeChecked = false;

  @override
  void initState() {
    super.initState();
    _cadastroController = GetIt.instance.get<CadastroControllerBasic>();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cabeçalho
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Text(
                  'MAKE YOUR BODY',
                  style: TextStyle(
                    fontFamily: 'LeagueGothic',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9C22E),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Queremos conhecer a fera!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'LeagueGothic',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Container do Formulário
              Container(
                width: 340,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9C22E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo Nome
                    TextFormField(
                      controller: _nomeController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: const Icon(Icons.person_outline),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Email
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Confirmar Senha
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Seção Objetivos
                    const Text(
                      'Seus Objetivos, Nossa Missão!',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        fontFamily: 'LeagueGothic',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Checkboxes Objetivos
                    _buildCheckboxListTile(
                      value: _perderChecked,
                      onChanged: (value) {
                        setState(() {
                          _perderChecked = value ?? false;
                        });
                      },
                      title: 'Perder Peso',
                    ),
                    _buildCheckboxListTile(
                      value: _hiperChecked,
                      onChanged: (value) {
                        setState(() {
                          _hiperChecked = value ?? false;
                        });
                      },
                      title: 'Ganhar Massa Muscular',
                    ),
                    _buildCheckboxListTile(
                      value: _resilienciaChecked,
                      onChanged: (value) {
                        setState(() {
                          _resilienciaChecked = value ?? false;
                        });
                      },
                      title: 'Resiliência',
                    ),

                    const SizedBox(height: 12),

                    // Seção Termos
                    const Text(
                      'Termos de Uso e Privacidade',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        fontFamily: 'LeagueGothic',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Checkboxes Termos
                    _buildCheckboxListTile(
                      value: _termosChecked,
                      onChanged: (value) {
                        setState(() {
                          _termosChecked = value ?? false;
                        });
                      },
                      title: 'Aceito os Termos de Uso',
                    ),
                    _buildCheckboxListTile(
                      value: _dependeChecked,
                      onChanged: (value) {
                        setState(() {
                          _dependeChecked = value ?? false;
                        });
                      },
                      title: 'Aceito a Política de Privacidade',
                    ),

                    const SizedBox(height: 20),

                    // Botão Cadastrar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _cadastrarUsuario();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFF9C22E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botão Voltar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFF9C22E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Widget reutilizável para CheckboxListTile
  Widget _buildCheckboxListTile({
    required bool value,
    required Function(bool?) onChanged,
    required String title,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'LeagueGothic',
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: Colors.black,
      checkColor: const Color(0xFFF9C22E),
    );
  }

  // Método para cadastrar usuário
  void _cadastrarUsuario() async {
    // Validações básicas
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _mostrarSnackBar('Por favor, preencha todos os campos');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _mostrarSnackBar('As senhas não coincidem');
      return;
    }

    if (!_termosChecked || !_dependeChecked) {
      _mostrarSnackBar('Aceite os termos e política de privacidade');
      return;
    }

    //Código antigo antes do Firebase
    // Aqui você chamaria o método do controller para cadastrar
    /*_cadastroController.cadastrarUsuario(
      _nomeController.text,
      _emailController.text,
      _passwordController.text,
    );

    _mostrarSnackBar('Cadastro realizado com sucesso!');
  }
   */

    // Coletando objetivos selecionados
    List<String> objetivos = [];
    if (_perderChecked) objetivos.add('Perder Peso');
    if (_hiperChecked) objetivos.add('Ganhar Massa Muscular');
    if (_resilienciaChecked) objetivos.add('Resiliência');

    String? erro = await _cadastroController.cadastrarUsuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _passwordController.text,
      objetivos: objetivos,
    );

    if (erro == null) {
      // Sucesso! Usuário cadastrado
      _mostrarSnackBar('Usuário cadastrado com sucesso!');
      Navigator.pushNamed(context, '/');
    } else {
      // Erro - mostrar para o usuário
      _mostrarSnackBar('Erro: $erro');
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    // Limpa os controllers quando o widget for destruído
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
