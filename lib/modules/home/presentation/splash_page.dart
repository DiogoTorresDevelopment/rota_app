import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/core/config/dev_config.dart'; // opcional: para logs

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkLoginStatus();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // tempo da animação
    final token = await TokenHelper.getToken();

    if (DevConfig.enableLogs) {
      debugPrint('[SPLASH] Token carregado: $token');
    }

    if (!mounted) return;

    if (token != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          child: Image.asset(
            'assets/images/logo_rota.png',
            height: 150,
          ),
        ),
      ),
    );
  }
}
