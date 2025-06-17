import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';
// import 'package:rota_app/modules/routes/data/rota_repository_mock.dart';
import 'package:rota_app/core/routes/data/rota_repository_api.dart';
import 'package:rota_app/modules/routes/widgets/rota_card_item.dart';
import 'package:rota_app/modules/routes/widgets/section_title.dart';
import 'package:rota_app/modules/routes/widgets/delivery_card_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final RotaRepository _repository = (DevConfig.isDev || DevConfig.forceMock)
  //     ? RotaRepositoryMock()
  //     : RotaRepositoryAPI();
  final RotaRepository _repository = RotaRepositoryAPI();

  String _userName = '...';
  List<DeliveryModel> _deliveries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _carregarDeliveries();
  }

  Future<void> _carregarUsuario() async {
    final nome = await TokenHelper.getUserNameFromToken();
    if (DevConfig.enableLogs) {
      debugPrint('[HOME] Nome do usuário carregado: $nome');
    }
    if (mounted && nome != null) {
      setState(() => _userName = nome);
    }
  }

  Future<void> _carregarDeliveries() async {
    try {
      final resultado = await _repository.listarDeliveries();
      setState(() {
        _deliveries = resultado;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('[HOME] Erro ao carregar deliveries: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar entregas')),
      );
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
    final inProgressDeliveries = _deliveries.where((d) => d.status == 'in_progress').toList();
    final completedDeliveries = _deliveries.where((d) => d.status == 'completed').toList();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (inProgressDeliveries.isNotEmpty) ...[
                const SectionTitle(title: 'Entregas em Andamento'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: inProgressDeliveries.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final delivery = inProgressDeliveries[index];
                      return DeliveryCardItem(
                        delivery: delivery,
                        onTap: () {
                          context.push('/rota_detalhe', extra: delivery);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              if (completedDeliveries.isNotEmpty) ...[
                const SectionTitle(title: 'Entregas Concluídas'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: completedDeliveries.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final delivery = completedDeliveries[index];
                      return DeliveryCardItem(
                        delivery: delivery,
                        onTap: () {
                          context.push('/rota_detalhe', extra: delivery);
                        },
                      );
                    },
                  ),
                ),
              ],

              if (_deliveries.isEmpty)
                const Center(child: Text('Nenhuma entrega encontrada.')),
            ],
          ],
        ),
      ),
    );
  }
}
