import 'dart:convert';
import 'package:rota_app/core/network/api_service.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:http/http.dart' as http;

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

    final data = response.data;
    if (data is List) {
      return data.map((json) => RotaModel.fromJson(json)).toList();
    } else {
      throw Exception('Resposta inesperada da API: esperado uma lista de rotas.');
    }
  }

  @override
  Future<List<RotaModel>> listarEntregasRecentes({int limit = 5}) async {
    final response = await _api.get('/entregas/recentes', queryParameters: {
      'limit': limit,
    });

    final data = response.data;
    if (data is List) {
      return data.map((json) => RotaModel.fromJson(json)).toList();
    } else {
      throw Exception('Resposta inesperada da API: esperado uma lista de entregas recentes.');
    }
  }

  Future<List<DeliveryModel>> listarDeliveries() async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('Token não encontrado');
    final baseUrl = DevConfig.apiBaseUrl;
    final response = await http.get(
      Uri.parse('$baseUrl/api/driver/deliveries'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null && data['data']['deliveries'] != null) {
        final deliveries = data['data']['deliveries'] as List;
        return deliveries.map((e) => DeliveryModel.fromJson(e)).toList();
      } else {
        throw Exception('Formato de resposta inválido da API');
      }
    } else {
      throw Exception('Erro ao buscar deliveries: ${response.body}');
    }
  }

  @override
  Future<DeliveryModel> buscarDeliveryPorId(int id) async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('Token não encontrado');
    final baseUrl = DevConfig.apiBaseUrl;
    final response = await http.get(
      Uri.parse('$baseUrl/api/driver/deliveries/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null && data['data']['delivery'] != null) {
        return DeliveryModel.fromJson(data['data']['delivery']);
      } else {
        throw Exception('Formato de resposta inválido da API');
      }
    } else {
      throw Exception('Erro ao buscar delivery: ${response.body}');
    }
  }
}
