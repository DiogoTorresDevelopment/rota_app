import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_app/core/helpers/token_helper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _logout(BuildContext context) async {
    await TokenHelper.clearToken();

    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usuário',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Gustavo'), // Futuro: pegar do token
              subtitle: Text('gustavo@rota.com'),
            ),
            const Divider(height: 32),
            const Text(
              'Sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair do aplicativo'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
