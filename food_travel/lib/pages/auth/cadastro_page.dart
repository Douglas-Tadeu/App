import 'package:flutter/material.dart';
import '../../services/food_travel_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _loading = false;
  String? _erro;

  final service = FoodTravelService();

  Future<void> _cadastrar() async {
    setState(() {
      _loading = true;
      _erro = null;
    });

    final sucesso = await service.cadastrarUsuario(
      _nomeController.text.trim(),
      _emailController.text.trim(),
      _senhaController.text.trim(),
    );

    setState(() => _loading = false);

    if (sucesso) {
      Navigator.pop(context);
    } else {
      setState(() => _erro = "Erro ao cadastrar usuário.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
            ),
            const SizedBox(height: 20),
            if (_erro != null)
              Text(
                _erro!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _cadastrar,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
