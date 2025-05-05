import 'package:rota_app/core/network/api_service.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';

class RotaRepositoryAPI implements RotaRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<RotaModel>> listarRotas({
    int page = 1,
    int pageSize = 10,
    String? filtroStatus,
    String? filtroOrigem,
    String? filtroDestino,
  }) async {
    final response = await _api.get('/rotas', queryParameters: {
      'page': page,
      'pageSize': pageSize,
      if (filtroStatus != null) 'status': filtroStatus,
      if (filtroOrigem != null) 'origem': filtroOrigem,
      if (filtroDestino != null) 'destino': filtroDestino,
    });

    // Validação segura da estrutura recebida
    final data = response.data;
    if (data is List) {
      return data.map((json) => RotaModel.fromJson(json)).toList();
    } else {
      throw Exception('Resposta inesperada da API: esperado uma lista de rotas.');
    }
  }
}
