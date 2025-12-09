import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../models/restaurante.dart';
import '../../services/food_travel_service.dart';

class PratoFormPage extends StatefulWidget {
  final FoodTravelService service;
  final Prato? prato;
  final String? restauranteId; // opcional: se vier de um restaurante específico

  const PratoFormPage({
    super.key,
    required this.service,
    this.prato,
    this.restauranteId,
  });

  @override
  State<PratoFormPage> createState() => _PratoFormPageState();
}

class _PratoFormPageState extends State<PratoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  String? _restauranteId;
  bool _saving = false;

  List<Restaurante> restaurantesList = [];

  @override
  void initState() {
    super.initState();
    _restauranteId = widget.restauranteId ?? widget.prato?.restauranteId;
    if (widget.prato != null) {
      _nomeCtrl.text = widget.prato!.nome;
      _descCtrl.text = widget.prato!.descricao;
      _imgCtrl.text = widget.prato!.imagemUrl;
      _precoCtrl.text = widget.prato!.preco.toString();
    }
    _carregarRestaurantes();
  }

  Future<void> _carregarRestaurantes() async {
    final r = await widget.service.listarRestaurantes();
    setState(() {
      restaurantesList = r;
    });
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _descCtrl.dispose();
    _imgCtrl.dispose();
    _precoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_restauranteId == null || _restauranteId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione o restaurante')));
      return;
    }

    setState(() => _saving = true);

    final nome = _nomeCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final img = _imgCtrl.text.trim();
    final preco = double.tryParse(_precoCtrl.text.trim().replaceAll(',', '.')) ?? 0.0;

    final novoPrato = Prato(
      id: widget.prato?.id ?? widget.service.gerarId(),
      nome: nome,
      descricao: desc,
      imagemUrl: img,
      preco: preco,
      restauranteId: _restauranteId!,
      usuarioId: widget.prato?.usuarioId ?? (await widget.service.getUsuarioLogado()) ?? '',
    );

    if (widget.prato == null) {
      await widget.service.adicionarPrato(novoPrato);
    } else {
      await widget.service.atualizarPrato(novoPrato);
    }

    setState(() => _saving = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.prato != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Prato' : 'Novo Prato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeCtrl,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    maxLines: 3,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe a descrição' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _imgCtrl,
                    decoration: const InputDecoration(labelText: 'URL da imagem'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _precoCtrl,
                    decoration: const InputDecoration(labelText: 'Preço (ex: 12.50)'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o preço' : null,
                  ),
                  const SizedBox(height: 12),

                  // seletor de restaurante (apenas se houver restaurantes)
                  DropdownButtonFormField<String>(
                    value: _restauranteId,
                    items: restaurantesList.map<DropdownMenuItem<String>>((r) {
                      return DropdownMenuItem(value: r.id, child: Text(r.nome));
                    }).toList(),
                    onChanged: (v) => setState(() => _restauranteId = v),
                    decoration: const InputDecoration(labelText: 'Restaurante'),
                    validator: (v) => v == null || v.isEmpty ? 'Selecione um restaurante' : null,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _salvar,
                      child: _saving ? const CircularProgressIndicator(color: Colors.white) : Text(isEdit ? 'Atualizar' : 'Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
