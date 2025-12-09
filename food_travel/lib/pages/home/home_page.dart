import 'package:flutter/material.dart';
import '../../services/food_travel_service.dart';
import '../../models/restaurante.dart';
import '../../models/prato.dart';
import '../../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = FoodTravelService();
  List<Restaurante> restaurantes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    restaurantes = await service.listarRestaurantes();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurantes")),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: restaurantes.length,
              itemBuilder: (context, i) {
                final r = restaurantes[i];
                return ListTile(
                  leading: r.imageUrl.isNotEmpty ? Image.network(r.imageUrl, width: 60, height: 60, fit: BoxFit.cover) : const Icon(Icons.restaurant),
                  title: Text(r.nome),
                  subtitle: Text(r.endereco),
                  onTap: () async {
                    final pratos = await service.listarPratosPorRestaurante(r.id);
                    Navigator.pushNamed(context, "/pratos", arguments: pratos);
                  },
                );
              },
            ),
    );
  }
}
