import 'package:dio/dio.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/core/network/dio_client.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/login_response.dart';

class AuthRepositoryAPI implements AuthRepository {
  final DioClient _dioClient = DioClient();

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.client.post('/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;

      final result = LoginResponse.fromJson(data);

      await TokenHelper.saveToken(result.token);
      await TokenHelper.saveUserName(result.user['name']);

      return result;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Erro desconhecido';

      if (statusCode == 401) {
        throw Exception('Credenciais inválidas. Verifique seu e-mail e senha.');
      } else if (statusCode == 422) {
        throw Exception('Dados inválidos. Preencha corretamente.');
      } else {
        throw Exception(message);
      }
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dioClient.client.post('/forgot-password', data: {
        'email': email,
      });
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Erro desconhecido';

      if (statusCode == 404) {
        throw Exception('E-mail não encontrado.');
      } else if (statusCode == 422) {
        throw Exception('E-mail inválido.');
      } else {
        throw Exception(message);
      }
    }
  }
}
