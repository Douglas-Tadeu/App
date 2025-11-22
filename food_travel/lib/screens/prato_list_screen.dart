// lib/screens/prato_list_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prato.dart';
import '../models/restaurante.dart';
import '../services/food_travel_service.dart';
import 'prato_form_screen.dart';
import 'prato_detail_screen.dart';

class PratoListScreen extends StatefulWidget {
  final FoodTravelService service;
  final Restaurante restaurante;

  const PratoListScreen({super.key, required this.service, required this.restaurante});

  @override
  State<PratoListScreen> createState() => _PratoListScreenState();
}

class _PratoListScreenState extends State<PratoListScreen> {
  late List<Prato> pratos;
  String? usuarioIdLogado;
  bool ehDono = false;

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
    pratos = widget.service.listarPratosPorRestaurante(widget.restaurante.id);
  }

  Future<void> _carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    usuarioIdLogado = prefs.getString('usuarioId');
    setState(() {
      ehDono = usuarioIdLogado == widget.restaurante.usuarioId;
    });
  }

  void _atualizarLista() {
    setState(() {
      pratos = widget.service.listarPratosPorRestaurante(widget.restaurante.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pratos de ${widget.restaurante.nome}')),
      body: ListView.builder(
        itemCount: pratos.length,
        itemBuilder: (context, index) {
          final p = pratos[index];
          final podeAvaliar = usuarioIdLogado != null && widget.service.usuarioPodeAvaliar(usuarioIdLogado!, p.id);

          return ListTile(
            leading: p.imageUrl.isNotEmpty
                ? Image.network(p.imageUrl, width: 50, height: 50)
                : const Icon(Icons.fastfood),
            title: Text(p.nome),
            subtitle: Text(p.descricao),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // avaliar (só se usuário logado e permitido)
                if (podeAvaliar)
                  IconButton(
                    icon: const Icon(Icons.rate_review),
                    tooltip: 'Avaliar',
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PratoDetailScreen(service: widget.service, prato: p),
                        ),
                      );
                      _atualizarLista();
                    },
                  ),

                // botões de edição/exclusão somente para o dono
                if (ehDono) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PratoFormScreen(
                            service: widget.service,
                            restaurante: widget.restaurante,
                            prato: p,
                          ),
                        ),
                      );
                      _atualizarLista();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.service.removerPrato(p.id);
                      _atualizarLista();
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: ehDono
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PratoFormScreen(service: widget.service, restaurante: widget.restaurante),
                  ),
                );
                _atualizarLista();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
