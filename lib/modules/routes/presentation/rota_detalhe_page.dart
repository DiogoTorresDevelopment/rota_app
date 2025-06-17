import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';
import 'package:rota_app/modules/routes/presentation/widgets/rota_ponto_tile.dart';
import 'package:rota_app/modules/anexos/presentation/anexos_page.dart';
import 'package:rota_app/core/routes/data/rota_repository_api.dart';

class RotaDetalhePage extends StatefulWidget {
  final DeliveryModel delivery;

  const RotaDetalhePage({super.key, required this.delivery});

  @override
  State<RotaDetalhePage> createState() => _RotaDetalhePageState();
}

class _RotaDetalhePageState extends State<RotaDetalhePage> {
  late List<StopModel> pontos;

  @override
  void initState() {
    super.initState();
    pontos = List.from(widget.delivery.stops); // Clona localmente
  }

  void _fazerCheckIn(int index) async {
    final stop = pontos[index];
    try {
      final repo = RotaRepositoryAPI();
      final updatedDelivery = await repo.concluirParada(widget.delivery.id, stop.id);
      setState(() {
        pontos = List.from(updatedDelivery.stops);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Check-in feito em: ${stop.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao concluir parada: $e')),
      );
    }
  }

  void _mostrarConfirmacaoEntrega() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Conclusão'),
        content: const Text('Você deseja finalizar essa entrega?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🚚 Entrega concluída!')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final delivery = widget.delivery;

    return Scaffold(
      appBar: AppBar(
        title: Text('Entrega #${delivery.id} - ${delivery.route.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_outlined),
            tooltip: 'Botão de pânico',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🚨 Botão de pânico acionado!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📅 Data: ${delivery.createdAt.toString().substring(0, 10)}'),
            Text('📝 Status: ${delivery.status}'),
            if (delivery.completedAt != null)
              Text('✅ Concluída em: ${delivery.completedAt!.toString().substring(0, 10)}'),
            const SizedBox(height: 16),

            // 🌍 MAPA
            if (pontos.isNotEmpty)
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      double.tryParse(pontos.first.latitude) ?? 0.0,
                      double.tryParse(pontos.first.longitude) ?? 0.0,
                    ),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.rota.app',
                    ),
                    MarkerLayer(
                      markers: pontos.map((p) {
                        return Marker(
                          point: LatLng(
                            double.tryParse(p.latitude) ?? 0.0,
                            double.tryParse(p.longitude) ?? 0.0,
                          ),
                          width: 40,
                          height: 40,
                          child: Icon(
                            p.status == 'completed'
                                ? Icons.flag
                                : Icons.location_pin,
                            color: p.status == 'completed'
                                ? Colors.green
                                : Colors.orange,
                            size: 30,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            const Text('🧭 Paradas da Entrega:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: pontos.length,
                itemBuilder: (context, index) {
                  final ponto = pontos[index];
                  return RotaPontoTile(
                    ponto: ponto,
                    onCheckIn: () => _fazerCheckIn(index),
                    onAnexar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnexosPage(
                            rotaId: delivery.id.toString(),
                            ponto: ponto.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _mostrarConfirmacaoEntrega,
              icon: const Icon(Icons.flag_outlined),
              label: const Text('Concluir Entrega'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
