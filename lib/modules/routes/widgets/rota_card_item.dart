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
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100], // fundo cinza claro
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
          children: [
            // Título
            Row(
              children: [
                const Icon(Icons.local_shipping, size: 20, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rota ${rota.codigo}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),

            // Origem
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Origem: ${rota.origem}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),

            // Destino
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.flag_outlined, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Destino: ${rota.destino}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),

            // Data de envio
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  'Data: ${rota.dataEnvio}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),

            // Pontos
            if (rota.pontos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.place_rounded, size: 16, color: Colors.black45),
                    const SizedBox(width: 4),
                    Text(
                      '${rota.pontos.length} ponto(s)',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
