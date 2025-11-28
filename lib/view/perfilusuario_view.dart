// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/perfil_controller.dart';

class PerfilUsuarioView extends StatefulWidget {
  const PerfilUsuarioView({super.key});

  @override
  State<PerfilUsuarioView> createState() => _PerfilUsuarioViewState();
}

class _PerfilUsuarioViewState extends State<PerfilUsuarioView> {
  late PerfilController _controller;
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isEditando = false;
  List<String> _objetivosSelecionados = [];

  @override
  void initState() {
    super.initState();
    _controller = PerfilController();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _atualizarCampos();
  }

  void _atualizarCampos() {
    _nomeController.text = _controller.usuarioAtual.nome;
    _emailController.text = _controller.usuarioAtual.email;
    _objetivosSelecionados = List.from(_controller.usuarioAtual.objetivos);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _salvarDados() {
    if (_formKey.currentState!.validate()) {
      if (_objetivosSelecionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione pelo menos um objetivo'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      _controller.salvarDados(
        nome: _nomeController.text,
        email: _emailController.text,
        objetivos: _objetivosSelecionados,
      );

      setState(() {
        _isEditando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados salvos com sucesso!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  void _apagarDados() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagar Dados'),
          content: const Text('Tem certeza que deseja apagar todos os dados?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _controller.apagarDados();
                _atualizarCampos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dados apagados!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Apagar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _cancelarEdicao() {
    setState(() {
      _isEditando = false;
      _atualizarCampos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PerfilController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9C22E),
          title: const Text(
            'PERFIL DO USUÁRIO',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'LeagueGothic',
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Consumer<PerfilController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF9C22E),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Avatar do usuário
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFFF9C22E),
                    child: const Icon(Icons.person, size: 80, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Nome do usuário
                  Text(
                    controller.usuarioAtual.nome,
                    style: const TextStyle(
                      color: Color(0xFFF9C22E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Formulário
                  if (!_isEditando)
                    _buildViewMode(controller)
                  else
                    _buildEditMode(controller),

                  const SizedBox(height: 30),

                  // Botões de ação
                  if (!_isEditando)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isEditando = true;
                            });
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9C22E),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _apagarDados,
                          icon: const Icon(Icons.delete),
                          label: const Text('Apagar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _salvarDados,
                          icon: const Icon(Icons.save),
                          label: const Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9C22E),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _cancelarEdicao,
                          icon: const Icon(Icons.close),
                          label: const Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                  // Mensagem de erro
                  if (controller.erro != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.erro!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildViewMode(PerfilController controller) {
    return Column(
      children: [
        _buildDadoCard('Nome', controller.usuarioAtual.nome),
        const SizedBox(height: 12),
        _buildDadoCard('Email', controller.usuarioAtual.email),
        const SizedBox(height: 12),
        _buildDadoCard('Objetivos', controller.usuarioAtual.objetivos.join(', ')),
      ],
    );
  }

  Widget _buildDadoCard(String label, String valor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E272F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Color(0xFFF9C22E),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            valor.isEmpty ? 'Não preenchido' : valor,
            style: TextStyle(
              color: valor.isEmpty ? Colors.white54 : Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode(PerfilController controller) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Nome',
              labelStyle: const TextStyle(color: Color(0xFFF9C22E)),
              filled: true,
              fillColor: const Color(0xFF1E272F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF9C22E)),
              ),
            ),
            validator: controller.validarNome,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Color(0xFFF9C22E)),
              filled: true,
              fillColor: const Color(0xFF1E272F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF9C22E)),
              ),
            ),
            validator: controller.validarEmail,
          ),
          const SizedBox(height: 16),
          const Text(
            'Seus Objetivos:',
            style: TextStyle(
              color: Color(0xFFF9C22E),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildObjetivoCheckbox('Perder Peso'),
          _buildObjetivoCheckbox('Ganhar Massa Muscular'),
          _buildObjetivoCheckbox('Resiliência'),
        ],
      ),
    );
  }

  Widget _buildObjetivoCheckbox(String objetivo) {
    return CheckboxListTile(
      title: Text(
        objetivo,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      value: _objetivosSelecionados.contains(objetivo),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _objetivosSelecionados.add(objetivo);
          } else {
            _objetivosSelecionados.remove(objetivo);
          }
        });
      },
      activeColor: const Color(0xFFF9C22E),
      checkColor: Colors.black,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
