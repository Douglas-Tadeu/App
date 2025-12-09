import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../models/favorito.dart';
import '../../services/food_travel_service.dart';

class FavoritoPage extends StatefulWidget {
  final FoodTravelService service;
  final Prato prato;

  const FavoritoPage({
    super.key,
    required this.service,
    required this.prato,
  });

  @override
  State<FavoritoPage> createState() => _FavoritoPageState();
}

class _FavoritoPageState extends State<FavoritoPage> {
  bool carregando = false;

  Future<void> _favoritar() async {
    setState(() => carregando = true);

    final usuario = widget.service.getUsuarioLogado();
    if (usuario == null) return;

    final favorito = Favorito(
      id: "",
      usuarioId: usuario.id,
      pratoId: widget.prato.id,
    );

    await widget.service.salvarFavorito(favorito);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoritar prato")),
      body: Center(
        child: carregando
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text("Adicionar aos favoritos"),
                onPressed: _favoritar,
              ),
      ),
    );
  }
}
