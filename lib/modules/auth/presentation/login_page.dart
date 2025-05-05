import 'package:flutter/material.dart';
import 'package:rota_app/modules/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/logo_rota.png',
                height: 120,
              ),
              const SizedBox(height: 24),
              const LoginForm(),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
