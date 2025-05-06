import 'package:flutter/material.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/auth_repository_mock.dart';
import 'package:rota_app/modules/auth/data/auth_repository_api.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthRepository _repository = (DevConfig.isDev || DevConfig.forceMock)
      ? AuthRepositoryMock()
      : AuthRepositoryAPI();

  bool _isLoading = false;

  void _enviarSolicitacao() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite seu e-mail')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _repository.forgotPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📧 Instruções enviadas para seu e-mail!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Informe seu e-mail para recuperar sua senha.'),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _enviarSolicitacao,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Enviar'),
            )
          ],
        ),
      ),
    );
  }
}
