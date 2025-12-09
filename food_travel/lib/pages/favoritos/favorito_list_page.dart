import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import '../../services/food_travel_service.dart';
import 'usuario_form_page.dart';

class UsuarioListPage extends StatefulWidget {
  const UsuarioListPage({super.key});
  @override
  State<UsuarioListPage> createState() => _UsuarioListPageState();
}

class _UsuarioListPageState extends State<UsuarioListPage> {
  final service = FoodTravelService();
  List<Usuario> usuarios = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() => loading = true);
    usuarios = await service.listarUsuarios();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuários"), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: carregar)]),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const UsuarioFormPage()));
        carregar();
      }, child: const Icon(Icons.add)),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, i) {
          final u = usuarios[i];
          return ListTile(title: Text(u.nome), subtitle: Text(u.email));
        },
      ),
    );
  }
}
