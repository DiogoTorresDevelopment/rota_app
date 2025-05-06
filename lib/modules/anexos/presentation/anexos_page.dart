import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/anexos/data/anexo_service.dart';
import 'package:rota_app/modules/anexos/data/anexo_storage_helper.dart';
import 'package:rota_app/modules/anexos/data/anexo_model.dart';
import 'package:rota_app/modules/anexos/widgets/anexo_item.dart';

class AnexosPage extends StatefulWidget {
  final String rotaId;
  final String ponto;

  const AnexosPage({
    super.key,
    required this.rotaId,
    required this.ponto,
  });

  @override
  State<AnexosPage> createState() => _AnexosPageState();
}

class _AnexosPageState extends State<AnexosPage> {
  final List<AnexoModel> _anexos = [];

  @override
  void initState() {
    super.initState();
    _carregarAnexosPendentes();
  }

  Future<void> _carregarAnexosPendentes() async {
    final pendentes = await AnexoStorageHelper.carregarAnexosPendentes(
      rotaId: widget.rotaId,
      ponto: widget.ponto,
    );
    if (DevConfig.enableLogs) {
      debugPrint('[MOCK] ${pendentes.length} anexo(s) pendente(s) encontrados para ponto ${widget.ponto}');
    }
    setState(() => _anexos.addAll(pendentes));
  }

  Future<void> _escolherImagem(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: source);

    if (imagem != null) {
      final novoAnexo = AnexoModel(
        arquivo: File(imagem.path),
        nome: imagem.name,
        rotaId: widget.rotaId,
        ponto: widget.ponto,
      );

      setState(() => _anexos.add(novoAnexo));

      if (DevConfig.enableLogs) {
        debugPrint('[MOCK] Anexo adicionado: ${imagem.name}');
      }

      // Salva localmente imediatamente
      await AnexoStorageHelper.salvarAnexosPendentes(_anexos);
    }
  }

  Future<void> _enviarAnexos() async {
    final service = AnexoService();

    try {
      if (DevConfig.enableLogs) {
        debugPrint('[ENVIAR] Tentando enviar ${_anexos.length} anexo(s)...');
      }

      if (DevConfig.simulateDelay) {
        await Future.delayed(const Duration(seconds: 2));
      }

      await service.enviarAnexos(_anexos);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anexos enviados com sucesso!')),
      );

      // Limpa somente os anexos deste ponto
      await AnexoStorageHelper.removerAnexosPorRotaEPonto(
        rotaId: widget.rotaId,
        ponto: widget.ponto,
      );

      setState(() => _anexos.clear());

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (DevConfig.enableLogs) {
        debugPrint('[ERRO] Falha ao enviar anexos: $e');
      }

      await AnexoStorageHelper.salvarAnexosPendentes(_anexos);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar. Anexos salvos localmente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anexar Documentos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rota: ${widget.rotaId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Ponto: ${widget.ponto}'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _escolherImagem(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Câmera'),
              ),
              ElevatedButton.icon(
                onPressed: () => _escolherImagem(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: const Text('Galeria'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _anexos.isEmpty
                ? const Center(child: Text('Nenhum anexo ainda.'))
                : ListView.builder(
              itemCount: _anexos.length,
              itemBuilder: (context, index) {
                return AnexoItem(file: _anexos[index].arquivo);
              },
            ),
          ),
          if (_anexos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _enviarAnexos,
                icon: const Icon(Icons.upload_file),
                label: const Text('Enviar Anexos'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
