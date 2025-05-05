import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final lowerStatus = status.toLowerCase();
    final color = _getColor(lowerStatus);
    final icon = _getIcon(lowerStatus);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(String status) {
    switch (status) {
      case 'concluída':
        return Colors.green;
      case 'iniciada':
        return Colors.orange;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String status) {
    switch (status) {
      case 'concluída':
        return Icons.check_circle;
      case 'iniciada':
        return Icons.play_arrow;
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }
}
