import 'package:flutter/material.dart';

class FilterResult {
  final String? codigo;
  final String? origem;
  final String? destino;
  final String? status;

  FilterResult({this.codigo, this.origem, this.destino, this.status});
}

class FilterBottomSheet extends StatefulWidget {
  final FilterResult? initial;

  const FilterBottomSheet({super.key, this.initial});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _origemController;
  late TextEditingController _destinoController;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.initial?.codigo);
    _origemController = TextEditingController(text: widget.initial?.origem);
    _destinoController = TextEditingController(text: widget.initial?.destino);
    _selectedStatus = widget.initial?.status;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            const Text('Filtros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _codigoController,
              decoration: const InputDecoration(labelText: 'Código da Rota'),
            ),
            TextFormField(
              controller: _origemController,
              decoration: const InputDecoration(labelText: 'Origem'),
            ),
            TextFormField(
              controller: _destinoController,
              decoration: const InputDecoration(labelText: 'Destino'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'Iniciada', child: Text('Iniciada')),
                DropdownMenuItem(value: 'Concluída', child: Text('Concluída')),
                DropdownMenuItem(value: 'Cancelada', child: Text('Cancelada')),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  FilterResult(
                    codigo: _codigoController.text,
                    origem: _origemController.text,
                    destino: _destinoController.text,
                    status: _selectedStatus,
                  ),
                );
              },
              child: const Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }
}
