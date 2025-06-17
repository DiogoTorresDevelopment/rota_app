import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/domain/models/delivery_model.dart';

abstract class RotaRepository {
  Future<List<RotaModel>> listarRotas({
    int page = 1,
    int pageSize = 10,
    String? filtroStatus,
    String? filtroOrigem,
    String? filtroDestino,
  });

  Future<List<RotaModel>> listarEntregasRecentes({int limit = 5});

  Future<List<DeliveryModel>> listarDeliveries();

  Future<DeliveryModel> buscarDeliveryPorId(int id);
}
