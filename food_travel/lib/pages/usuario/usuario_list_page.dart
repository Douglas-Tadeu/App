import 'package:flutter/material.dart';
import '../../controllers/usuario_controller.dart';

class UsuarioListPage extends StatefulWidget {
  const UsuarioListPage({super.key});

  @override
  State<UsuarioListPage> createState() => _UsuarioListPageState();
}

class _UsuarioListPageState extends State<UsuarioListPage> {
  final controller = UsuarioController();
  List<dynamic> usuarios = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final data = await controller.listarUsuarios();
    setState(() {
      usuarios = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuários")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final u = usuarios[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(u["nome"] ?? "Sem nome"),
                  subtitle: Text(u["email"] ?? ""),
                );
              },
            ),
    );
  }
}
