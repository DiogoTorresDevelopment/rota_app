import 'package:flutter/foundation.dart'; // para usar kReleaseMode

class AppEnvironment {
  static bool get isDev => !kReleaseMode;

// alternativo manual:
static const bool isDev = false;
static const bool isDev = false;
}
