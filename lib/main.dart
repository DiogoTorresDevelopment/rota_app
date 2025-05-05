import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_app/core/routes/app_router.dart';
import 'package:rota_app/shared/themes/app_theme.dart';
import 'package:rota_app/core/config/dev_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await dotenv.load(
      fileName: DevConfig.isDev ? '.env.dev' : '.env.prod',
    );
  } catch (e) {
    // Log claro em caso de erro de carregamento
    debugPrint('Erro ao carregar o arquivo .env: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: DevConfig.isDev,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
