import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/login_response.dart';
import 'package:rota_app/modules/auth/data/user_profile.dart';

class AuthRepositoryAPI implements AuthRepository {
  final String _baseUrl = DevConfig.apiBaseUrl.replaceAll('/api', '');

  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/login/driver'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(data);
      
      // Salva o token e dados do usuário
      await TokenHelper.saveToken(loginResponse.token);
      await TokenHelper.saveUserData(loginResponse.user);
      
      return loginResponse;
    } else {
      final errorMessage = _getErrorMessage(response);
      throw Exception('Falha no login: $errorMessage');
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse('$_baseUrl/api/driver/profile'),
      headers: {
        ..._defaultHeaders,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data['data']);
    } else {
      final errorMessage = _getErrorMessage(response);
      throw Exception('Falha ao buscar perfil: $errorMessage');
    }
  }

  @override
  Future<void> logout() async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.post(
      Uri.parse('$_baseUrl/api/logout'),
      headers: {
        ..._defaultHeaders,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Limpa os dados locais independente da resposta
      await TokenHelper.clearToken();
      await TokenHelper.clearUserData();
    } else {
      final errorMessage = _getErrorMessage(response);
      throw Exception('Falha no logout: $errorMessage');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Implemente o método para solicitar recuperação de senha
    throw Exception('Método forgotPassword não implementado');
  }

  String _getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? response.body;
    } catch (e) {
      return response.body;
    }
  }
}
