class AuthService {
  // Simula o Login
  Future<bool> fazerLogin(String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) {
      throw Exception('Os campos e-mail e senhas não podem estar vazios');
    }

    await Future.delayed(const Duration(seconds: 3));
    if (email == 'lian@teste.com' && senha == '123456') {
      return true;
    }
    throw Exception('E-mail ou senha incorretos.');
  }

  // Simula a Recuperação de Senha (Requisito)
  Future<void> recuperarSenha(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty) {
      throw Exception("Por favor, insira um e-mail válido.");
    }
  }

  // Simula a Exclusão da Conta (Requisito LGPD)
  Future<void> excluirConta(String uidUsuario) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
