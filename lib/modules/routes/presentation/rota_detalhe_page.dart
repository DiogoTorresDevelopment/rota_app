import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/domain/models/ponto_rota.dart';
import 'package:rota_app/modules/routes/presentation/widgets/rota_ponto_tile.dart';
import 'package:rota_app/modules/anexos/presentation/anexos_page.dart';

class RotaDetalhePage extends StatefulWidget {
  final RotaModel rota;

  const RotaDetalhePage({super.key, required this.rota});

  @override
  State<RotaDetalhePage> createState() => _RotaDetalhePageState();
}

class _RotaDetalhePageState extends State<RotaDetalhePage> {
  late List<PontoRota> pontos;

  @override
  void initState() {
    super.initState();
    // pontos = List.from(widget.rota.pontos); // Clona localmente
  }

  void _fazerCheckIn(int index) {
    if (pontos[index].checkinFeito) return;

    setState(() {
      pontos[index] = PontoRota(
        nome: pontos[index].nome,
        tipo: pontos[index].tipo,
        checkinFeito: true,
        latitude: pontos[index].latitude,
        longitude: pontos[index].longitude,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Check-in feito em: ${pontos[index].nome}')),
    );
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
    final rota = widget.rota;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rota ${rota.codigo}'),
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
            Text('📅 Data: ${rota.dataEnvio}'),
            Text('📝 Status: ${rota.status}'),
            const SizedBox(height: 16),

            // 🌍 MAPA
            SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(pontos.first.latitude, pontos.first.longitude),
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
                        point: LatLng(p.latitude, p.longitude),
                        width: 40,
                        height: 40,
                        child: Icon(
                          p.tipo == 'origem'
                              ? Icons.location_on
                              : p.tipo == 'destino'
                              ? Icons.flag
                              : Icons.location_pin,
                          color: p.tipo == 'origem'
                              ? Colors.green
                              : p.tipo == 'destino'
                              ? Colors.red
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
            const Text('🧭 Pontos da Rota:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            rotaId: widget.rota.codigo,
                            ponto: ponto.nome,
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
