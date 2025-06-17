import 'package:flutter/material.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';
import 'package:rota_app/core/routes/data/rota_repository_api.dart';
import 'package:go_router/go_router.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final RotaRepository _repository = RotaRepositoryAPI();
  List<DeliveryModel> _deliveries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDeliveries();
  }

  Future<void> _carregarDeliveries() async {
    setState(() => _isLoading = true);
    try {
      final resultado = await _repository.listarDeliveries();
      setState(() {
        _deliveries = resultado;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar entregas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotas'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deliveries.isEmpty
              ? const Center(child: Text('Nenhuma entrega encontrada.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _deliveries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final delivery = _deliveries[index];
                    return ListTile(
                      title: Text(delivery.route.name),
                      subtitle: Text('Status: ${delivery.status}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.push('/rota_detalhe', extra: delivery);
                      },
                    );
                  },
                ),
    );
  }
}
