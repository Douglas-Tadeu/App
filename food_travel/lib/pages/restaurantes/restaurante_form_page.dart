import 'package:flutter/material.dart';
import '../../models/restaurante.dart';

class RestauranteFormPage extends StatefulWidget {
  final Restaurante? restaurante;
  const RestauranteFormPage({super.key, this.restaurante});

  @override
  State<RestauranteFormPage> createState() => _RestauranteFormPageState();
}

class _RestauranteFormPageState extends State<RestauranteFormPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nomeCtrl;
  late TextEditingController enderecoCtrl;
  late TextEditingController imageUrlCtrl; 

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.restaurante?.nome ?? '');
    enderecoCtrl = TextEditingController(text: widget.restaurante?.endereco ?? '');
    imageUrlCtrl = TextEditingController(text: widget.restaurante?.imageUrl ?? '');
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    enderecoCtrl.dispose();
    imageUrlCtrl.dispose(); // << ADICIONADO
    super.dispose();
  }

  void salvar() async {
  if (!formKey.currentState!.validate()) return;

  final r = Restaurante(
    id: widget.restaurante?.id ?? "0", 
    nome: nomeCtrl.text,
    endereco: enderecoCtrl.text,
    usuarioId: widget.restaurante?.usuarioId ?? "1", 
    imageUrl: imageUrlCtrl.text,
  );

  Navigator.pop(context, r);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurante == null ? 'Novo Restaurante' : 'Editar Restaurante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: "Nome do restaurante"),
                validator: (v) => v!.isEmpty ? "Informe o nome" : null,
              ),
              TextFormField(
                controller: enderecoCtrl,
                decoration: const InputDecoration(labelText: "Endereço"),
                validator: (v) => v!.isEmpty ? "Informe o endereço" : null,
              ),
              TextFormField(
                controller: imageUrlCtrl,
                decoration: const InputDecoration(labelText: "URL da imagem"),
                validator: (v) => v!.isEmpty ? "Informe a imagem" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: salvar,
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
