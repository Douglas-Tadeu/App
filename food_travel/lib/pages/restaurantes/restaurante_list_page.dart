import 'package:flutter/material.dart';
import '../../models/restaurante.dart';
import '../../services/food_travel_service.dart';
import 'restaurante_form_page.dart';
import 'restaurant_detail_page.dart';

class RestauranteListPage extends StatefulWidget {
  const RestauranteListPage({super.key});
  @override
  State<RestauranteListPage> createState() => _RestauranteListPageState();
}

class _RestauranteListPageState extends State<RestauranteListPage> {
  final service = FoodTravelService();
  List<Restaurante> restaurantes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    restaurantes = await service.listarRestaurantes();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurantes")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => RestauranteFormPage()));
          carregar();
        },
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: restaurantes.length,
        itemBuilder: (context, i) {
          final r = restaurantes[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: r.imageUrl.isNotEmpty ? Image.network(r.imageUrl, width: 60, height: 60, fit: BoxFit.cover) : const Icon(Icons.restaurant),
              title: Text(r.nome),
              subtitle: Text(r.endereco),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurante: r))),
            ),
          );
        },
      ),
    );
  }
}
