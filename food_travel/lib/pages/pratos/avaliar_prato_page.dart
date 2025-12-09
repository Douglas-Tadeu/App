import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../models/avaliacao.dart';
import '../../services/food_travel_service.dart';

class AvaliarPratoPage extends StatefulWidget {
  final Prato prato;
  const AvaliarPratoPage({super.key, required this.prato});

  @override
  State<AvaliarPratoPage> createState() => _AvaliarPratoPageState();
}

class _AvaliarPratoPageState extends State<AvaliarPratoPage> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioController = TextEditingController();
  double _nota = 3.0;
  bool _isLoading = false;
  final service = FoodTravelService();

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final usuarioId = await service.getUsuarioLogado() ?? '';
    final avaliacao = Avaliacao(
      id: service.gerarId(),
      pratoId: widget.prato.id,
      usuarioId: usuarioId,
      comentario: _comentarioController.text.trim(),
      nota: _nota,
      data: DateTime.now(),
    );
    await service.salvarAvaliacao(avaliacao);
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Avaliação salva com sucesso!"), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prato = widget.prato;
    return Scaffold(
      appBar: AppBar(title: Text("Avaliar ${prato.nome}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Text(prato.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Nota:"), Text(_nota.toStringAsFixed(1))]),
            Slider(value: _nota, min: 1, max: 5, divisions: 8, label: _nota.toStringAsFixed(1), onChanged: (v) => setState(() => _nota = v)),
            const SizedBox(height: 20),
            TextFormField(controller: _comentarioController, decoration: const InputDecoration(labelText: "Comentário", border: OutlineInputBorder()), maxLines: 3, validator: (v) => v == null || v.trim().isEmpty ? "Digite um comentário" : null),
            const SizedBox(height: 20),
            _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _salvar, child: const Text("Salvar Avaliação")),
          ]),
        ),
      ),
    );
  }
}
