import 'dart:io';

class AnexoModel {
  final File arquivo;
  final String nome;
  final String rotaId;
  final String ponto;

  AnexoModel({
    required this.arquivo,
    required this.nome,
    required this.rotaId,
    required this.ponto,
  });

  /// Serializa o objeto para um Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'arquivo_path': arquivo.path,
      'nome': nome,
      'rotaId': rotaId,
      'ponto': ponto,
    };
  }

  /// Construtor a partir de um JSON
  factory AnexoModel.fromJson(Map<String, dynamic> json) {
    final path = json['arquivo_path'] as String?;
    return AnexoModel(
      arquivo: File(path ?? ''), // fallback seguro
      nome: json['nome'] ?? 'anexo_sem_nome',
      rotaId: json['rotaId'] ?? '',
      ponto: json['ponto'] ?? '',
    );
  }
}
