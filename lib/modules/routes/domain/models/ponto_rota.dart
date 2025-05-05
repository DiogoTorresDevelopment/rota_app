class PontoRota {
  final String nome;
  final String tipo;
  final bool checkinFeito;
  final double latitude;
  final double longitude;

  PontoRota({
    required this.nome,
    required this.tipo,
    required this.latitude,
    required this.longitude,
    this.checkinFeito = false,
  });

  factory PontoRota.fromJson(Map<String, dynamic> json) {
    return PontoRota(
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      checkinFeito: json['checkinFeito'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'latitude': latitude,
      'longitude': longitude,
      'checkinFeito': checkinFeito,
    };
  }
}
