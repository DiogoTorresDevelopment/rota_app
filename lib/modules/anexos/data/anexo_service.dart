import 'package:dio/dio.dart';
import 'package:rota_app/core/network/dio_client.dart';
import 'package:rota_app/modules/anexos/data/anexo_model.dart';

class AnexoService {
  final Dio _dio = DioClient().client;

  Future<void> enviarAnexos(List<AnexoModel> anexos) async {
    for (var anexo in anexos) {
      final formData = FormData.fromMap({
        'rota_id': anexo.rotaId,
        'ponto': anexo.ponto,
        'arquivo': await MultipartFile.fromFile(
          anexo.arquivo.path,
          filename: anexo.nome,
        ),
      });

      await _dio.post('/anexos', data: formData);
    }
  }
}
