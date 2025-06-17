import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/domain/models/ponto_rota.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';
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

  @override
  Future<List<DeliveryModel>> listarDeliveries() async {
    if (DevConfig.simulateDelay) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (DevConfig.enableLogs) {
      debugPrint('[Mock] Carregando deliveries');
    }

    return [
      DeliveryModel(
        id: 1,
        status: 'in_progress',
        createdAt: DateTime.now(),
        completedAt: null,
        notes: null,
        route: RouteModel(
          id: 1,
          name: 'Rota 1',
          status: 'active',
        ),
        driver: DriverModel(
          id: 1,
          name: 'Motorista 1',
          phone: '(46) 99292-9292',
          email: 'motorista1@gmail.com',
        ),
        truck: TruckModel(
          id: 1,
          plate: 'ASD2S23',
          model: 'FHN-8008',
          brand: 'Volvo FH',
          year: 2025,
          color: 'Vermelho',
          fuelType: 'Gasolina',
          loadCapacity: '400000.00',
          chassis: 'ASDK19281984ASD',
          mileage: '15000.00',
          lastReview: '2025-06-07T00:00:00.000000Z',
          status: true,
        ),
        currentStop: StopModel(
          id: 1,
          name: 'Destino1',
          order: 1,
          status: 'pending',
          completedAt: null,
          photos: [],
          latitude: '-25.0774645',
          longitude: '-50.2064726',
          address: AddressModel(
            street: 'Avenida Souza Naves',
            number: '2420',
            city: 'Ponta Grossa',
            state: 'PR',
            cep: '84062-000',
          ),
        ),
        stops: [
          StopModel(
            id: 1,
            name: 'Destino1',
            order: 1,
            status: 'pending',
            completedAt: null,
            photos: [],
            latitude: '-25.0774645',
            longitude: '-50.2064726',
            address: AddressModel(
              street: 'Avenida Souza Naves',
              number: '2420',
              city: 'Ponta Grossa',
              state: 'PR',
              cep: '84062-000',
            ),
          ),
          StopModel(
            id: 2,
            name: 'Destino 2',
            order: 2,
            status: 'pending',
            completedAt: null,
            photos: [],
            latitude: '-25.3622156',
            longitude: '-51.4804577',
            address: AddressModel(
              street: 'Rua Industrial',
              number: '400',
              city: 'Guarapuava',
              state: 'PR',
              cep: '85045-390',
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Future<DeliveryModel> buscarDeliveryPorId(int id) async {
    if (DevConfig.simulateDelay) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (DevConfig.enableLogs) {
      debugPrint('[Mock] Buscando delivery com ID: $id');
    }

    // Retorna o primeiro delivery da lista mock como exemplo
    final deliveries = await listarDeliveries();
    if (deliveries.isEmpty) {
      throw Exception('Nenhum delivery encontrado');
    }
    return deliveries.first;
  }
}
