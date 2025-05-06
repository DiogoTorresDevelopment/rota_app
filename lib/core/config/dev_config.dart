import 'package:flutter/foundation.dart'; // para usar kReleaseMode
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DevConfig {
  /// Define se o app está rodando em modo desenvolvimento (manual ou automático)
  static const bool isDev = !kReleaseMode;

  /// Define se deve exibir logs em debug
  static const bool enableLogs = isDev;

  /// Simula delay em chamadas de repositório (mock)
  static const bool simulateDelay = isDev;

  /// Força uso de repositórios mockados mesmo fora do dev
  static final bool forceMock = dotenv.env['FORCE_MOCK'] == 'true';

  /// Acesso à API definida no .env
  static String get apiBaseUrl => dotenv.env['API_URL'] ?? '';

  /// Nome do ambiente (opcional para exibir no app ou log)
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'unknown';
}
