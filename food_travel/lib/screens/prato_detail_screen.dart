// lib/screens/prato_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/prato.dart';
import '../models/avaliacao.dart';
import '../services/food_travel_service.dart';

class PratoDetailScreen extends StatefulWidget {
  final FoodTravelService service;
  final Prato prato;

  const PratoDetailScreen({super.key, required this.service, required this.prato});

  @override
  State<PratoDetailScreen> createState() => _PratoDetailScreenState();
}

class _PratoDetailScreenState extends State<PratoDetailScreen> {
  String? usuarioId;
  late double media;
  late List<Avaliacao> avaliacoes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    usuarioId = prefs.getString('usuarioId');
    _refreshAvaliacoes();
  }

  void _refreshAvaliacoes() {
    setState(() {
      avaliacoes = widget.service.listarAvaliacoesPorPrato(widget.prato.id);
      media = widget.service.calcularMediaAvaliacoes(widget.prato.id);
    });
  }

  Future<void> _mostrarDialogAvaliar() async {
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faça login para avaliar.')));
      return;
    }

    if (!widget.service.usuarioPodeAvaliar(usuarioId!, widget.prato.id)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Você não pode avaliar este prato.')));
      return;
    }

    final _notaCtrl = TextEditingController(text: '5');
    final _comentCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Avaliar prato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _notaCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Nota (0.0 - 5.0)'),
              ),
              TextField(
                controller: _comentCtrl,
                decoration: const InputDecoration(labelText: 'Comentário (opcional)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Enviar')),
          ],
        );
      },
    );

    if (result == true) {
      final nota = double.tryParse(_notaCtrl.text) ?? 0.0;
      final comentario = _comentCtrl.text.trim();

      final ok = widget.service.criarAvaliacao(widget.prato.id, usuarioId!, nota, comentario);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível avaliar.')));
        return;
      }

      _refreshAvaliacoes();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avaliação enviada!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.prato.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.prato.imageUrl.isNotEmpty)
              Image.network(widget.prato.imageUrl, height: 160, fit: BoxFit.cover)
            else
              const Icon(Icons.fastfood, size: 120),
            const SizedBox(height: 12),
            Text(widget.prato.nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.prato.descricao),
            const SizedBox(height: 8),
            Text('Preço: R\$ ${widget.prato.preco.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Text('Média: ${media.toStringAsFixed(1)}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _mostrarDialogAvaliar,
              child: const Text('Avaliar prato'),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Avaliações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: avaliacoes.isEmpty
                  ? const Center(child: Text('Nenhuma avaliação ainda.'))
                  : ListView.builder(
                      itemCount: avaliacoes.length,
                      itemBuilder: (_, i) {
                        final a = avaliacoes[i];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Nota: ${a.nota.toStringAsFixed(1)}'),
                          subtitle: Text(a.comentario),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
