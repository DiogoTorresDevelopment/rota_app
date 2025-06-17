import 'package:flutter/material.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/data/rota_repository.dart';
import 'package:rota_app/core/routes/data/rota_repository_api.dart';
// import 'package:rota_app/modules/routes/data/rota_repository_mock.dart';
import 'package:rota_app/modules/routes/widgets/filter_bottom_sheet.dart';
import 'package:rota_app/modules/routes/widgets/rota_list_tile.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  // final RotaRepository _repository = (DevConfig.isDev || DevConfig.forceMock)
  //     ? RotaRepositoryMock()
  //     : RotaRepositoryAPI();
  final RotaRepository _repository = RotaRepositoryAPI();

  final List<RotaModel> _allRotas = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 5;

  FilterResult? _currentFilter;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !_isLoading) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() => _isLoading = true);

    try {
      final newRotas = await _repository.listarRotas(
        page: _currentPage,
        pageSize: _pageSize,
        filtroStatus: _currentFilter?.status,
        filtroOrigem: _currentFilter?.origem,
        filtroDestino: _currentFilter?.destino,
      );

      setState(() {
        _allRotas.addAll(newRotas);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar rotas: $e')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<RotaModel> get _filteredRotas {
    final c = _currentFilter;
    if (c == null) return _allRotas;

    return _allRotas.where((rota) {
      final matchCodigo = c.codigo == null ||
          c.codigo!.isEmpty ||
          rota.codigo.contains(c.codigo!);
      final matchOrigem = c.origem == null ||
          c.origem!.isEmpty ||
          rota.origem.toLowerCase().contains(c.origem!.toLowerCase());
      final matchDestino = c.destino == null ||
          c.destino!.isEmpty ||
          rota.destino.toLowerCase().contains(c.destino!.toLowerCase());
      final matchStatus = c.status == null || rota.status == c.status;

      return matchCodigo && matchOrigem && matchDestino && matchStatus;
    }).toList();
  }

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(initial: _currentFilter),
    );

    if (result != null) {
      setState(() {
        _currentFilter = result;
        _allRotas.clear();
        _currentPage = 1;
        _loadMore(); // reaplica os filtros
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rotas = _filteredRotas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            tooltip: 'Filtrar rotas',
            onPressed: _openFilter,
          )
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: rotas.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < rotas.length) {
            final rota = rotas[index];
            return RotaListTile(rota: rota); // Navegação feita internamente
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
