import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';
import 'package:rota_app/modules/routes/data/rota_repository_mock.dart';
import 'package:rota_app/core/routes/data/rota_repository_api.dart';
import 'package:rota_app/modules/routes/widgets/rota_card_item.dart';
import 'package:rota_app/modules/routes/widgets/section_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RotaRepository _repository = (DevConfig.isDev || DevConfig.forceMock)
      ? RotaRepositoryMock()
      : RotaRepositoryAPI();

  String _userName = '...';
  List<RotaModel> _rotas = [];
  List<RotaModel> _entregasRecentes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _carregarRotas();
    _carregarEntregasRecentes();
  }

  Future<void> _carregarUsuario() async {
    final nome = await TokenHelper.getUserName();
    if (DevConfig.enableLogs) {
      debugPrint('[HOME] Nome do usuário carregado: $nome');
    }
    if (mounted && nome != null) {
      setState(() => _userName = nome);
    }
  }

  Future<void> _carregarRotas() async {
    try {
      final resultado = await _repository.listarRotas();
      setState(() {
        _rotas = resultado;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('[HOME] Erro ao carregar rotas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar rotas')),
      );
    }
  }

  Future<void> _carregarEntregasRecentes() async {
    try {
      final recentes = await _repository.listarEntregasRecentes(limit: 5);
      setState(() => _entregasRecentes = recentes);
    } catch (e) {
      debugPrint('[HOME] Erro ao carregar entregas recentes: $e');
    }
  }

  void _logout(BuildContext context) async {
    await TokenHelper.clearToken();
    if (DevConfig.enableLogs) {
      debugPrint('[LOGOUT] Token e dados do usuário removidos');
    }
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $_userName 👋'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Rotas Ativas'),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_rotas.isEmpty)
              const Text('Nenhuma rota ativa no momento.')
            else
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _rotas.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final rota = _rotas[index];
                    return RotaCardItem(
                      rota: rota,
                      onTap: () {
                        context.push('/rota_detalhe', extra: rota);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Entregas Recentes'),
            const SizedBox(height: 12),
            _entregasRecentes.isEmpty
                ? const Text('Nenhuma entrega recente encontrada.')
                : SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _entregasRecentes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final entrega = _entregasRecentes[index];
                  return RotaCardItem(
                    rota: entrega,
                    onTap: () {
                      context.push('/rota_detalhe', extra: entrega);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
