import 'package:flutter/material.dart';
import '../../models/restaurante.dart';
import '../../models/prato.dart';
import '../../services/food_travel_service.dart';
import '../pratos/prato_list_page.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurante restaurante;
  const RestaurantDetailPage({super.key, required this.restaurante});

  @override
  Widget build(BuildContext context) {
    final service = FoodTravelService();

    return Scaffold(
      appBar: AppBar(title: Text(restaurante.nome)),
      body: FutureBuilder<List<Prato>>(
        future: service.listarPratosPorRestaurante(restaurante.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar pratos: ${snapshot.error}'));
          }

          final pratos = snapshot.data ?? <Prato>[];

          if (pratos.isEmpty) {
            return const Center(child: Text('Nenhum prato neste restaurante'));
          }

          return ListView.builder(
            itemCount: pratos.length,
            itemBuilder: (context, i) {
              final p = pratos[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading: p.imagemUrl.isNotEmpty
                      ? Image.network(p.imagemUrl, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.fastfood))
                      : const Icon(Icons.fastfood),
                  title: Text(p.nome),
                  subtitle: Text(
                    p.descricao.length > 60 ? '${p.descricao.substring(0, 60)}...' : p.descricao,
                  ),
                  onTap: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PratoListPage(
                          service: service,
                          initialPratos: List<Prato>.from(pratos),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
