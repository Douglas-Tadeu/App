import 'package:flutter/material.dart';
import '../models/restaurante.dart';
import '../models/usuario.dart';
import '../services/food_travel_service.dart';
import 'restaurante_form_screen.dart';
import 'prato_list_screen.dart';
import 'usuario_form_screen.dart';
import 'usuario_list_screen.dart';
import 'favorito_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final FoodTravelService service;

  const HomeScreen({super.key, required this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Restaurante> restaurantes;
  late List<Usuario> usuarios;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    setState(() {
      restaurantes = widget.service.listarRestaurantes();
      usuarios = widget.service.listarUsuarios();
    });
  }

  void _abrirPratos(Restaurante restaurante) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PratoListScreen(service: widget.service, restaurante: restaurante),
      ),
    ).then((_) => _carregarDados());
  }

  void _abrirFavoritos(Usuario usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FavoritoListScreen(service: widget.service, usuario: usuario),
      ),
    );
  }

  void _abrirUsuarios() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioListScreen(service: widget.service),
      ),
    ).then((_) => _carregarDados());
  }

  void _abrirRestauranteForm([Restaurante? restaurante]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestauranteFormScreen(
            service: widget.service, restaurante: restaurante),
      ),
    ).then((_) => _carregarDados());
  }

  void _abrirUsuarioForm([Usuario? usuario]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            UsuarioFormScreen(service: widget.service, usuario: usuario),
      ),
    ).then((_) => _carregarDados());
  }

  void _sair() {
    Navigator.pop(context); // volta para a tela anterior (login, por exemplo)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Travel - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            onPressed: _sair,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Usuários',
            onPressed: _abrirUsuarios,
          ),
          IconButton(
            icon: const Icon(Icons.restaurant),
            tooltip: 'Restaurantes',
            onPressed: () => _abrirRestauranteForm(),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Restaurantes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...restaurantes.map(
            (r) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: r.imageUrl.isNotEmpty
                    ? Image.network(r.imageUrl,
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.restaurant),
                title: Text(r.nome),
                subtitle: Text(r.endereco),
                onTap: () => _abrirPratos(r),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _abrirRestauranteForm(r),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        widget.service.removerRestaurante(r.id);
                        _carregarDados();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Usuários',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...usuarios.map(
            (u) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(u.nome),
                subtitle: Text(u.email),
                onTap: () => _abrirFavoritos(u),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _abrirUsuarioForm(u),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        widget.service.removerUsuario(u.id);
                        _carregarDados();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _abrirRestauranteForm(),
        tooltip: 'Adicionar Restaurante',
      ),
    );
  }
}
