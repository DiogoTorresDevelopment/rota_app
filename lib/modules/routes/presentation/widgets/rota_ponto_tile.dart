import 'package:flutter/material.dart';
import 'package:rota_app/modules/routes/domain/models/ponto_rota.dart';

class RotaPontoTile extends StatelessWidget {
  final PontoRota ponto;
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
    final cor = ponto.checkinFeito ? Colors.green : Colors.orange;
    final icone = ponto.checkinFeito ? Icons.check_circle : Icons.radio_button_unchecked;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icone, color: cor),
        title: Text('${ponto.tipo.toUpperCase()} - ${ponto.nome}'),
        subtitle: Text(ponto.checkinFeito ? 'Check-in realizado' : 'Aguardando check-in'),
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
