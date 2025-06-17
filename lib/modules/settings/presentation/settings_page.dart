import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/auth_repository_api.dart';
import 'package:rota_app/modules/auth/data/auth_repository_mock.dart';
import 'package:rota_app/modules/auth/data/user_profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthRepository _repository = DevConfig.forceMock
      ? AuthRepositoryMock()
      : AuthRepositoryAPI();
  
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _repository.getProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _repository.logout();
      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      // Mesmo com erro, redireciona para o login
      if (!mounted) return;
      context.go('/login');
    }
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
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Erro ao carregar dados',
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadUserProfile,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_userProfile != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Nome'),
                        subtitle: Text(_userProfile!.name),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('E-mail'),
                        subtitle: Text(_userProfile!.email),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Telefone'),
                        subtitle: Text(_userProfile!.driver.phone),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair do aplicativo'),
                onTap: _isLoading ? null : _logout,
                trailing: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
