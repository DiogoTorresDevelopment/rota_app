import 'package:rota_app/modules/routes/domain/models/rota_model.dart';

abstract class RotaRepository {
  Future<List<RotaModel>> listarRotas({
    int page = 1,
    int pageSize = 10,
    String? filtroStatus,
    String? filtroOrigem,
    String? filtroDestino,
  });
}
