import 'ponto_rota.dart';

class RotaModel {
  final String codigo;
  final String origem;
  final String destino;
  final String dataEnvio;
  final String status;
  final List<PontoRota> pontos;

  RotaModel({
    required this.codigo,
    required this.origem,
    required this.destino,
    required this.dataEnvio,
    required this.status,
    required this.pontos,
  });

  factory RotaModel.fromJson(Map<String, dynamic> json) {
    return RotaModel(
      codigo: json['codigo'] ?? '',
      origem: json['origem'] ?? '',
      destino: json['destino'] ?? '',
      dataEnvio: json['data_envio'] ?? '',
      status: json['status'] ?? '',
      pontos: (json['pontos'] as List<dynamic>? ?? [])
          .map((p) => PontoRota.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'origem': origem,
      'destino': destino,
      'data_envio': dataEnvio,
      'status': status,
      'pontos': pontos.map((p) => p.toJson()).toList(),
    };
  }
}
