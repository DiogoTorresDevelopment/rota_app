import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/domain/models/ponto_rota.dart';
import 'rota_repository.dart';

class RotaRepositoryMock implements RotaRepository {
  @override
  Future<List<RotaModel>> listarRotas({
    int page = 1,
    int pageSize = 10,
    String? filtroStatus,
    String? filtroOrigem,
    String? filtroDestino,
  }) async {
    if (DevConfig.simulateDelay) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (DevConfig.enableLogs) {
      debugPrint('[Mock] Carregando rotas - Página $page');
    }

    final todas = List.generate(50, (index) {
      final id = index + 1;

      return RotaModel(
        codigo: id.toString().padLeft(3, '0'),
        origem: 'Cidade ${id % 5 + 1}',
        destino: 'Destino ${id % 7 + 1}',
        dataEnvio: '2024-04-${(id % 30 + 1).toString().padLeft(2, '0')}',
        status: (id % 3 == 0)
            ? 'Concluída'
            : (id % 3 == 1)
            ? 'Iniciada'
            : 'Cancelada',
        pontos: [
          PontoRota(
            nome: 'Cidade ${id % 5 + 1}',
            tipo: 'origem',
            checkinFeito: false,
            latitude: -19.9 + id * 0.01,
            longitude: -43.9 + id * 0.01,
          ),
          PontoRota(
            nome: 'Destino ${id % 7 + 1}',
            tipo: 'destino',
            checkinFeito: false,
            latitude: -20.0 + id * 0.01,
            longitude: -44.0 + id * 0.01,
          ),
        ],
      );
    });

    final filtradas = todas.where((rota) {
      final statusOK = filtroStatus == null || rota.status == filtroStatus;
      final origemOK = filtroOrigem == null || rota.origem.contains(filtroOrigem);
      final destinoOK = filtroDestino == null || rota.destino.contains(filtroDestino);
      return statusOK && origemOK && destinoOK;
    }).toList();

    final start = (page - 1) * pageSize;
    final end = (start + pageSize) > filtradas.length ? filtradas.length : start + pageSize;

    return filtradas.sublist(start, end);
  }

  @override
  Future<List<RotaModel>> listarEntregasRecentes({int limit = 5}) async {
    if (DevConfig.simulateDelay) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (DevConfig.enableLogs) {
      debugPrint('[Mock] Carregando entregas recentes');
    }

    final recentes = List.generate(limit, (index) {
      final id = index + 100;
      return RotaModel(
        codigo: 'E${id.toString().padLeft(3, '0')}',
        origem: 'Origem ${index + 1}',
        destino: 'Destino ${index + 1}',
        dataEnvio: '2024-05-${(index + 1).toString().padLeft(2, '0')}',
        status: 'Concluída',
        pontos: [
          PontoRota(
            nome: 'Origem ${index + 1}',
            tipo: 'origem',
            checkinFeito: true,
            latitude: -19.0 + index * 0.01,
            longitude: -43.0 + index * 0.01,
          ),
          PontoRota(
            nome: 'Destino ${index + 1}',
            tipo: 'destino',
            checkinFeito: true,
            latitude: -19.5 + index * 0.01,
            longitude: -43.5 + index * 0.01,
          ),
        ],
      );
    });

    return recentes;
  }
}
