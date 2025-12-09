import 'package:flutter/material.dart';
import '../../models/favorito.dart';
import '../../services/food_travel_service.dart';
import '../../models/prato.dart';

class FavoritosUsuarioPage extends StatefulWidget {
  const FavoritosUsuarioPage({super.key});
  @override
  State<FavoritosUsuarioPage> createState() => _FavoritosUsuarioPageState();
}

class _FavoritosUsuarioPageState extends State<FavoritosUsuarioPage> {
  final service = FoodTravelService();
  bool loading = true;
  List<Favorito> favoritos = [];

  @override
  void initState() {
    super.initState();
    carregarFavoritos();
  }

  Future<void> carregarFavoritos() async {
    final userId = await service.getUsuarioLogado();
    if (userId == null) {
      setState(() => loading = false);
      return;
    }
    favoritos = await service.listarFavoritosPorUsuario(userId);
    setState(() => loading = false);
  }

  Future<Prato?> _buscarPrato(String pratoId) async {
    final pratos = await service.listarPratos();
    try {
      return pratos.firstWhere((p) => p.id == pratoId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Favoritos")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favoritos.isEmpty
              ? const Center(child: Text("Nenhum prato favoritado ainda"))
              : ListView.builder(
                  itemCount: favoritos.length,
                  itemBuilder: (context, index) {
                    final f = favoritos[index];
                    return FutureBuilder<Prato?>(
                      future: _buscarPrato(f.pratoId),
                      builder: (context, snap) {
                        final prato = snap.data;
                        return ListTile(
                          leading: const Icon(Icons.favorite, color: Colors.red),
                          title: Text(prato?.nome ?? f.pratoId),
                          subtitle: Text("Prato ID: ${f.pratoId}"),
                          onTap: () {
                            if (prato != null) Navigator.pushNamed(context, "/pratos", arguments: [prato]);
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
