import 'package:flutter/material.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';

class RotaPontoTile extends StatelessWidget {
  final StopModel ponto;
  final VoidCallback onCheckIn;
  final VoidCallback onAnexar;

  const RotaPontoTile({
    super.key,
    required this.ponto,
    required this.onCheckIn,
    required this.onAnexar,
  });

  @override
  Widget build(BuildContext context) {
    final checkinFeito = ponto.status == 'completed';
    final cor = checkinFeito ? Colors.green : Colors.orange;
    final icone = checkinFeito ? Icons.check_circle : Icons.radio_button_unchecked;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icone, color: cor),
        title: Text(ponto.name),
        subtitle: Text(checkinFeito ? 'Check-in realizado' : 'Aguardando check-in'),
        trailing: Wrap(
          spacing: 12,
          children: [
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: onAnexar,
              tooltip: 'Anexar Documento',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: onCheckIn,
              tooltip: 'Fazer Check-in',
            ),
          ],
        ),
      ),
    );
  }
}
