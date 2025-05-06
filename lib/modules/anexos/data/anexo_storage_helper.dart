import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_app/modules/anexos/data/anexo_model.dart';

class AnexoStorageHelper {
  static const _keyAnexosPendentes = 'anexos_pendentes';

  /// Salva a lista de anexos pendentes no SharedPreferences
  static Future<void> salvarAnexosPendentes(List<AnexoModel> novosAnexos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyAnexosPendentes);

    List<AnexoModel> anexosAntigos = [];
    if (jsonString != null) {
      final List<dynamic> lista = jsonDecode(jsonString);
      anexosAntigos = lista.map((e) => AnexoModel.fromJson(e)).toList();
    }

    // Remove duplicados da mesma rotaId + ponto + nome
    anexosAntigos.removeWhere((antigo) => novosAnexos.any((novo) =>
    antigo.rotaId == novo.rotaId &&
        antigo.ponto == novo.ponto &&
        antigo.nome == novo.nome,
    ));

    // Junta os antigos + novos
    final todosAnexos = [...anexosAntigos, ...novosAnexos];
    final listaJson = todosAnexos.map((a) => a.toJson()).toList();
    await prefs.setString(_keyAnexosPendentes, jsonEncode(listaJson));
  }


  /// Recupera a lista de anexos pendentes do SharedPreferences
  static Future<List<AnexoModel>> carregarAnexosPendentes({
    String? rotaId,
    String? ponto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyAnexosPendentes);

    if (jsonString == null) return [];

    final List<dynamic> lista = jsonDecode(jsonString);
    final todos = lista.map((e) => AnexoModel.fromJson(e)).toList();

    // Se rotaId e ponto não forem fornecidos, retorna todos
    if (rotaId == null || ponto == null) return todos;

    // Caso contrário, filtra por rota e ponto
    return todos.where((anexo) =>
    anexo.rotaId == rotaId && anexo.ponto == ponto).toList();
  }

  /// Remove apenas os anexos de uma rota e ponto específicos
  static Future<void> removerAnexosPorRotaEPonto({
    required String rotaId,
    required String ponto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyAnexosPendentes);

    if (jsonString == null) return;

    final List<dynamic> lista = jsonDecode(jsonString);
    final todos = lista.map((e) => AnexoModel.fromJson(e)).toList();

    // Filtra e mantém apenas os que NÃO pertencem à rota + ponto indicados
    final restantes = todos.where((a) => a.rotaId != rotaId || a.ponto != ponto).toList();

    await prefs.setString(_keyAnexosPendentes, jsonEncode(restantes.map((e) => e.toJson()).toList()));
  }

  /// Limpa todos os anexos pendentes (usado em casos genéricos)
  static Future<void> limparAnexosPendentes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAnexosPendentes);
  }
}
