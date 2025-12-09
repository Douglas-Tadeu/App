import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../models/favorito.dart';
import '../../services/food_travel_service.dart';

class FavoritarPratoPage extends StatefulWidget {
  final Prato prato;

  const FavoritarPratoPage({super.key, required this.prato});

  @override
  State<FavoritarPratoPage> createState() => _FavoritarPratoPageState();
}

class _FavoritarPratoPageState extends State<FavoritarPratoPage> {
  bool _isLoading = false;
  bool _isFavorito = false;

  @override
  void initState() {
    super.initState();
    _carregarStatusFavorito();
  }

  Future<void> _carregarStatusFavorito() async {
    final user = FoodTravelService.usuarioLogado;

    if (user == null) return;

    final favoritos = await FoodTravelService.listarFavoritos();

    setState(() {
      _isFavorito = favoritos.any((f) =>
          f.pratoId == widget.prato.id &&
          f.usuarioId == user.id
      );
    });
  }

  Future<void> _alternarFavorito() async {
    final user = FoodTravelService.usuarioLogado;
    if (user == null) return;

    setState(() => _isLoading = true);

    if (_isFavorito) {
      // Remover favorito
      await FoodTravelService.removerFavorito(widget.prato.id, user.id);

      setState(() {
        _isFavorito = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Prato removido dos favoritos!"),
          backgroundColor: Colors.red,
        ),
      );

    } else {
      // Adicionar favorito
      final novoFavorito = Favorito(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        usuarioId: user.id,
        pratoId: widget.prato.id,
        data: DateTime.now(),
      );

      await FoodTravelService.salvarFavorito(novoFavorito);

      setState(() {
        _isFavorito = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Prato adicionado aos favoritos!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prato = widget.prato;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritar ${prato.nome}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              prato.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Icon(
              _isFavorito ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 80,
            ),

            const SizedBox(height: 20),

            Text(
              _isFavorito
                  ? "Este prato já está nos seus favoritos."
                  : "Deseja adicionar este prato aos seus favoritos?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _alternarFavorito,
                    child: Text(
                      _isFavorito
                          ? "Remover dos Favoritos"
                          : "Adicionar aos Favoritos",
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
