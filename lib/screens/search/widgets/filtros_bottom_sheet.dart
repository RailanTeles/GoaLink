import 'package:flutter/material.dart';
import 'package:goalink/models/filtros_pesquisa.dart';
import 'package:goalink/screens/search/search_view_model.dart';

class FiltrosBottomSheet extends StatefulWidget {
  final SearchViewModel vm;
  const FiltrosBottomSheet({super.key, required this.vm});

  @override
  State<FiltrosBottomSheet> createState() => _FiltrosBottomSheetState();
}

class _FiltrosBottomSheetState extends State<FiltrosBottomSheet> {
  String? _tipoSelecionado;
  String? _posicaoSelecionada;
  String? _pernaSelecionada;
  final _cidadeController = TextEditingController();

  RangeValues _alturaRange = const RangeValues(1.50, 2.20);
  RangeValues _pesoRange = const RangeValues(50, 120);
  static const RangeValues _alturaPadrao = RangeValues(1.50, 2.20);
  static const RangeValues _pesoPadrao = RangeValues(50, 120);

  @override
  void initState() {
    super.initState();
    final filtros = widget.vm.filtrosAtuais;
    if (filtros != null) {
      _tipoSelecionado = filtros.tipo;
      _posicaoSelecionada = filtros.posicao;
      _pernaSelecionada = filtros.pernaPreferida;
      _cidadeController.text = filtros.cidade ?? '';

      _alturaRange = RangeValues(
        filtros.alturaMinima ?? 1.50,
        filtros.alturaMaxima ?? 2.20,
      );
      _pesoRange = RangeValues(
        filtros.pesoMinimo ?? 50,
        filtros.pesoMaximo ?? 120,
      );
    }
  }

  @override
  void dispose() {
    _cidadeController.dispose();
    super.dispose();
  }

  void _aplicarFiltros() {
    final aplicarFiltrosJogador =
        _tipoSelecionado == 'jogador' || _tipoSelecionado == null;
    final alturaAlterada =
        _alturaRange.start != _alturaPadrao.start ||
        _alturaRange.end != _alturaPadrao.end;
    final pesoAlterado =
        _pesoRange.start != _pesoPadrao.start ||
        _pesoRange.end != _pesoPadrao.end;

    final novosFiltros = FiltrosPesquisa(
      tipo: _tipoSelecionado,
      posicao: aplicarFiltrosJogador ? _posicaoSelecionada : null,
      pernaPreferida: aplicarFiltrosJogador ? _pernaSelecionada : null,
      cidade: _cidadeController.text.isNotEmpty
          ? _cidadeController.text.trim()
          : null,
      alturaMinima: aplicarFiltrosJogador && alturaAlterada
          ? _alturaRange.start
          : null,
      alturaMaxima: aplicarFiltrosJogador && alturaAlterada
          ? _alturaRange.end
          : null,
      pesoMinimo: aplicarFiltrosJogador && pesoAlterado
          ? _pesoRange.start
          : null,
      pesoMaximo: aplicarFiltrosJogador && pesoAlterado ? _pesoRange.end : null,
    );
    final buscarTodos =
        novosFiltros.tipo == null &&
        novosFiltros.cidade == null &&
        novosFiltros.posicao == null &&
        novosFiltros.pernaPreferida == null &&
        novosFiltros.alturaMinima == null &&
        novosFiltros.alturaMaxima == null &&
        novosFiltros.pesoMinimo == null &&
        novosFiltros.pesoMaximo == null;

    debugPrint(
      '[FiltrosBottomSheet] aplicando filtros: '
      'buscarTodos=$buscarTodos, '
      'tipo=${novosFiltros.tipo}, '
      'cidade=${novosFiltros.cidade}, '
      'posicao=${novosFiltros.posicao}, '
      'perna=${novosFiltros.pernaPreferida}, '
      'altura=${novosFiltros.alturaMinima}-${novosFiltros.alturaMaxima}, '
      'peso=${novosFiltros.pesoMinimo}-${novosFiltros.pesoMaximo}',
    );

    widget.vm.buscar(novosFiltros: novosFiltros, buscarTodos: buscarTodos);

    Navigator.pop(context);
  }

  void _limparFiltros() {
    setState(() {
      _tipoSelecionado = null;
      _posicaoSelecionada = null;
      _pernaSelecionada = null;
      _cidadeController.clear();
      _alturaRange = const RangeValues(1.50, 2.20);
      _pesoRange = const RangeValues(50, 120);
    });

    widget.vm.buscar(novosFiltros: FiltrosPesquisa());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text(
                  'Filtros Avançados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSecaoTitulo('Tipo de Perfil'),
                    _buildDropdown(
                      valorAtual: _tipoSelecionado,
                      opcoes: const ['jogador', 'olheiro', 'clube'],
                      hint: 'Qualquer tipo',
                      onChanged: (val) => setState(() {
                        _tipoSelecionado = val;
                        if (val != 'jogador') {
                          _posicaoSelecionada = null;
                          _pernaSelecionada = null;
                          _alturaRange = _alturaPadrao;
                          _pesoRange = _pesoPadrao;
                        }
                      }),
                    ),
                    const SizedBox(height: 16),

                    _buildSecaoTitulo('Cidade'),
                    TextField(
                      controller: _cidadeController,
                      decoration: InputDecoration(
                        hintText: 'Ex: São Paulo',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (_tipoSelecionado == 'jogador' ||
                        _tipoSelecionado == null) ...[
                      const Text(
                        'Filtros para Jogadores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildSecaoTitulo('Posição'),
                      _buildDropdown(
                        valorAtual: _posicaoSelecionada,
                        opcoes: const [
                          'Goleiro',
                          'Zagueiro',
                          'Lateral',
                          'Volante',
                          'Meia',
                          'Atacante',
                        ],
                        hint: 'Qualquer posição',
                        onChanged: (val) =>
                            setState(() => _posicaoSelecionada = val),
                      ),
                      const SizedBox(height: 16),

                      _buildSecaoTitulo('Perna Preferida'),
                      _buildDropdown(
                        valorAtual: _pernaSelecionada,
                        opcoes: const ['Direita', 'Esquerda', 'Ambidestro'],
                        hint: 'Qualquer perna',
                        onChanged: (val) =>
                            setState(() => _pernaSelecionada = val),
                      ),
                      const SizedBox(height: 24),

                      _buildSecaoTitulo('Altura (m)'),
                      RangeSlider(
                        values: _alturaRange,
                        min: 1.50,
                        max: 2.20,
                        divisions: 70,
                        labels: RangeLabels(
                          '${_alturaRange.start.toStringAsFixed(2)}m',
                          '${_alturaRange.end.toStringAsFixed(2)}m',
                        ),
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (val) => setState(() => _alturaRange = val),
                      ),

                      _buildSecaoTitulo('Peso (kg)'),
                      RangeSlider(
                        values: _pesoRange,
                        min: 50,
                        max: 120,
                        divisions: 70,
                        labels: RangeLabels(
                          '${_pesoRange.start.round()}kg',
                          '${_pesoRange.end.round()}kg',
                        ),
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (val) => setState(() => _pesoRange = val),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botões de Ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _limparFiltros,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _aplicarFiltros,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Aplicar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String? valorAtual,
    required List<String> opcoes,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: valorAtual,
          isExpanded: true,
          hint: Text(hint),
          items: [
            const DropdownMenuItem(value: null, child: Text('Qualquer um')),
            ...opcoes.map((op) => DropdownMenuItem(value: op, child: Text(op))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
