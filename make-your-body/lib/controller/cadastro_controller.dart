// cadastro_controller_simples.dart
class CadastroController {
  // Apenas as validações básicas
  String? validarCadastro({
    required String nome,
    required String email,
    required String senha,
    required String confirmacaoSenha,
    required bool temObjetivos,
    required bool aceitouTermos,
    required bool aceitouPolitica,
  }) {
    if (nome.isEmpty) return 'Nome é obrigatório';
    if (email.isEmpty) return 'E-mail é obrigatório';
    if (senha.isEmpty) return 'Senha é obrigatória';
    if (senha.length < 6) return 'Senha deve ter 6 caracteres ou mais';
    if (senha != confirmacaoSenha) return 'As senhas não coincidem';
    if (!temObjetivos) return 'Selecione pelo menos um objetivo';
    if (!aceitouTermos || !aceitouPolitica) {
      return 'Aceite os termos e política';
    }

    return null; // null significa que não há erros
  }

  // Simular cadastro
  Future<bool> simularCadastro() async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Sempre retorna sucesso na simulação
  }

  void cadastrarUsuario(String text, String text2, String text3) {}
}
