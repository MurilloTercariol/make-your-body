import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_app/controller/esqueci_controller_basic.dart';

class EsqueciView extends StatefulWidget {
  const EsqueciView({super.key});

  @override
  State<EsqueciView> createState() => _EsqueciViewState();
}

class _EsqueciViewState extends State<EsqueciView> {
  final TextEditingController _controller = TextEditingController();
  late final EsqueciControllerBasic _esqueciController;

  @override
  void initState() {
    super.initState();
    _esqueciController = GetIt.instance.get<EsqueciControllerBasic>();
  }

  @override
  Widget build(BuildContext context) {
    //TÍTULO
    return Scaffold(
      backgroundColor: Color(0x00D18210),
      appBar: AppBar(
        backgroundColor: Color(0xFFF9C22E),
        title: const Text(
          'RECUPERE O MONSTRO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'LeagueGothic',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // CAIXA DE TEXTO E MENSAGEM PARA INSERIR DADOS
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Digite seu e-mail e enviaremos um link para redefinir sua senha:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFF9C22E),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _controller.text.trim();

                // Validar email
                final validacao = _esqueciController.validarEmail(email);
                if (validacao != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(validacao)));
                  return;
                }

                // Recuperar senha
                final erro = await _esqueciController.recuperarSenha(email);

                if (!mounted) return;

                if (erro != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erro: $erro')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail de recuperação enviado!'),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                backgroundColor: Color(0xFFF9C22E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enviar Link',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
