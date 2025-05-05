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

  Map<String, dynamic> toJson() {
    return {
      'arquivo_path': arquivo.path,
      'nome': nome,
      'rotaId': rotaId,
      'ponto': ponto,
    };
  }

  factory AnexoModel.fromJson(Map<String, dynamic> json) {
    return AnexoModel(
      arquivo: File(json['arquivo_path']),
      nome: json['nome'],
      rotaId: json['rotaId'],
      ponto: json['ponto'],
    );
  }
}
