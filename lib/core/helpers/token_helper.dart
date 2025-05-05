import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenHelper {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_name';

  // Salva o token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Recupera o token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove o token e o nome do usuário
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Salva o nome do usuário diretamente (caso não venha no JWT)
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, name);
  }

  // Recupera o nome do usuário salvo localmente
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // (Opcional) Tenta extrair o nome do usuário diretamente do token JWT, se aplicável
  static Future<String?> getUserNameFromToken() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> data = jsonDecode(payload);

      return data['name'] ?? data['user']?['name']; // Depende da estrutura do JWT
    } catch (e) {
      return null;
    }
  }
}
