import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/widgets/status_badge.dart';

class RotaListTile extends StatelessWidget {
  final RotaModel rota;

  const RotaListTile({super.key, required this.rota});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple[100],
          child: const Icon(Icons.route, color: Colors.deepPurple),
        ),
        title: Text(
          'Rota ${rota.codigo}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('De: ${rota.origem} → Para: ${rota.destino}'),
            Text('Data: ${rota.dataEnvio}'),
          ],
        ),
        trailing: StatusBadge(status: rota.status),
        onTap: () {
          context.push('/rota_detalhe', extra: rota);
        },
      ),
    );
  }
}
