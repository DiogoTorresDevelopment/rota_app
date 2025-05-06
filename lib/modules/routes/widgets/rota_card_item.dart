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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 240,
        height: 220,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 🔁 Distribuição vertical
            children: [
              // Cabeçalho
              Row(
                children: [
                  const Icon(Icons.local_shipping, size: 20, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rota ${rota.codigo}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),

              // Informações
              _buildInfoRow(Icons.location_on_outlined, 'Origem: ${rota.origem}'),
              _buildInfoRow(Icons.flag_outlined, 'Destino: ${rota.destino}'),
              _buildInfoRow(Icons.calendar_today, 'Data: ${rota.dataEnvio}', fontSize: 13, color: Colors.black54),

              if (rota.pontos.isNotEmpty)
                _buildInfoRow(
                  Icons.place_rounded,
                  '${rota.pontos.length} ponto(s)',
                  fontSize: 13,
                  color: Colors.black54,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String text, {
        double fontSize = 14,
        Color color = Colors.black87,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, color: color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
