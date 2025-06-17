import 'package:flutter/material.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';
import 'package:rota_app/core/routes/data/rota_repository_api.dart';
import 'package:go_router/go_router.dart';

class DeliveryListCard extends StatelessWidget {
  final DeliveryModel delivery;
  final VoidCallback onTap;
  const DeliveryListCard({super.key, required this.delivery, required this.onTap});

  Color get statusColor {
    switch (delivery.status) {
      case 'completed':
        return Colors.green.shade100;
      case 'in_progress':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color get badgeColor {
    switch (delivery.status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get statusLabel {
    switch (delivery.status) {
      case 'completed':
        return 'Concluída';
      case 'in_progress':
        return 'Em andamento';
      default:
        return delivery.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: statusColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.route, size: 36, color: badgeColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rota: ${delivery.route.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: statusLabel,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusLabel,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Entrega #${delivery.id}  •  ${delivery.createdAt.toString().substring(0, 10)}'),
                    const SizedBox(height: 2),
                    Text('Motorista: ${delivery.driver.name}'),
                    Text('Caminhão: ${delivery.truck.plate ?? '-'}'),
                    Text('Paradas: ${delivery.stops.length}'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}

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
                    return DeliveryListCard(
                      delivery: delivery,
                      onTap: () {
                        context.push('/rota_detalhe', extra: delivery);
                      },
                    );
                  },
                ),
    );
  }
}
