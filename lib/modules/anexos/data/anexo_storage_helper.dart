import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_app/modules/anexos/data/anexo_model.dart';

class AnexoStorageHelper {
  static const _keyAnexosPendentes = 'anexos_pendentes';

  /// Salva a lista de anexos pendentes no SharedPreferences
  static Future<void> salvarAnexosPendentes(List<AnexoModel> anexos) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = anexos.map((a) => a.toJson()).toList();
    await prefs.setString(_keyAnexosPendentes, jsonEncode(lista));
  }

  /// Recupera a lista de anexos pendentes do SharedPreferences
  static Future<List<AnexoModel>> carregarAnexosPendentes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyAnexosPendentes);

    if (jsonString == null) return [];

    final List<dynamic> lista = jsonDecode(jsonString);
    return lista.map((e) => AnexoModel.fromJson(e)).toList();
  }

  /// Limpa todos os anexos pendentes
  static Future<void> limparAnexosPendentes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAnexosPendentes);
  }
}
