import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../services/food_travel_service.dart';
import 'prato_detail_page.dart';
import 'prato_form_page.dart';

class PratoListPage extends StatefulWidget {
  final FoodTravelService service;
  final List<Prato>? initialPratos;

  const PratoListPage({super.key, required this.service, this.initialPratos});

  @override
  State<PratoListPage> createState() => _PratoListPageState();
}

class _PratoListPageState extends State<PratoListPage> {
  List<Prato> pratos = [];

  @override
  void initState() {
    super.initState();
    _carregarPratos();
  }

  Future<void> _carregarPratos() async {
    if (widget.initialPratos != null) {
      setState(() => pratos = widget.initialPratos!);
      return;
    }
    final lista = await widget.service.listarPratos();
    setState(() => pratos = lista);
  }

  Future<void> _abrirFormulario({Prato? prato}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PratoFormPage(
          service: widget.service,
          prato: prato,
        ),
      ),
    );
    _carregarPratos();
  }

  Future<void> _abrirDetalhes(Prato prato) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PratoDetailPage(prato: prato),
      ),
    );
    _carregarPratos();
  }

  Future<void> _excluir(String id) async {
    await widget.service.removerPrato(id);
    _carregarPratos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pratos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: pratos.isEmpty
          ? const Center(child: Text("Nenhum prato cadastrado."))
          : ListView.builder(
              itemCount: pratos.length,
              itemBuilder: (_, i) {
                final prato = pratos[i];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: prato.imagemUrl.isNotEmpty
                        ? Image.network(
                            prato.imagemUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.fastfood, size: 40),
                    title: Text(prato.nome),
                    subtitle: Text(
                      prato.descricao.length > 50
                          ? prato.descricao.substring(0, 50) + "..."
                          : prato.descricao,
                    ),
                    onTap: () => _abrirDetalhes(prato),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _abrirFormulario(prato: prato),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _excluir(prato.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
