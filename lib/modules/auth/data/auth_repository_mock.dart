import 'dart:async';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/login_response.dart';
import 'package:rota_app/core/helpers/token_helper.dart';

class AuthRepositoryMock implements AuthRepository {
  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    // Simula um tempo de resposta da API
    await Future.delayed(const Duration(milliseconds: 800));

    // Dados simulados
    if (email == 'teste@rota.com' && password == '123456') {
      const tokenFalso = 'mocked-token-123456';

      // Salva o token falso no storage
      await TokenHelper.saveToken(tokenFalso);
      await TokenHelper.saveUserName('Motorista Teste'); // 👈 novo


      return LoginResponse(
        token: tokenFalso,
        user: {
          'id': 1,
          'name': 'Motorista Teste',
          'email': email,
        },
      );
    } else {
      throw Exception('Usuário ou senha inválidos (modo mock)');
    }
  }
}
