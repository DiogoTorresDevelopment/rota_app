import 'package:flutter/material.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';

class RotaCardItem extends StatelessWidget {
  final RotaModel rota;
  final VoidCallback? onTap;

  const RotaCardItem({
    super.key,
    required this.rota,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'concluída':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      case 'iniciada':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'concluída':
        return Icons.check_circle;
      case 'cancelada':
        return Icons.cancel;
      case 'iniciada':
        return Icons.timelapse;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(rota.status);
    final statusIcon = _getStatusIcon(rota.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // 🔁 Fundo cinza claro (substitui gradiente)
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho: Status + ícone de seta
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    rota.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black45),
              ],
            ),
            const SizedBox(height: 12),

            // Código da Rota
            Text(
              'Rota ${rota.codigo}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            // Origem e destino
            Text(
              '${rota.origem} → ${rota.destino}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 4),

            // Data de envio
            Text(
              'Data: ${rota.dataEnvio}',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const SizedBox(height: 10),

            // Rodapé: pontos
            if (rota.pontos.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.black45),
                  const SizedBox(width: 4),
                  Text(
                    '${rota.pontos.length} ponto(s)',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
