import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/restaurantes/restaurante_list_page.dart';
import '../pages/pratos/prato_list_page.dart';
import '../pages/favoritos/favoritos_usuario_page.dart';
import '../pages/usuario/usuario_list_page.dart';
import '../services/food_travel_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FoodTravelService();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Text("Food Travel", style: TextStyle(color: Colors.white, fontSize: 22))),
          ListTile(leading: const Icon(Icons.home), title: const Text("Home"), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()))),
          ListTile(leading: const Icon(Icons.restaurant), title: const Text("Restaurantes"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestauranteListPage()))),
          ListTile(leading: const Icon(Icons.fastfood), title: const Text("Pratos"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PratoListPage(service: service)))),
          ListTile(leading: const Icon(Icons.favorite), title: const Text("Favoritos"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritosUsuarioPage()))),
          ListTile(leading: const Icon(Icons.person), title: const Text("Usuários"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UsuarioListPage()))),
        ],
      ),
    );
  }
}
