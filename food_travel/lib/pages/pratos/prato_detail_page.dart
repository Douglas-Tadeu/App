import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../services/food_travel_service.dart';
import 'avaliar_prato_page.dart';

class PratoDetailPage extends StatefulWidget {
  final Prato prato;

  const PratoDetailPage({super.key, required this.prato});

  @override
  State<PratoDetailPage> createState() => _PratoDetailPageState();
}

class _PratoDetailPageState extends State<PratoDetailPage> {
  String? usuarioId;
  bool podeAvaliar = false;
  double media = 0;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    usuarioId = await FoodTravelService.getUsuarioLogadoStatic();
    media = FoodTravelService.mediaAvaliacoes(widget.prato.id);

    final service = FoodTravelService();
    final restaurante = service.buscarRestaurante(widget.prato.restauranteId);

    if (restaurante == null) {
      podeAvaliar = false;
    } else {
      podeAvaliar = usuarioId != null &&
      FoodTravelService.usuarioPodeAvaliar(usuarioId!, widget.prato.id) &&
      restaurante.usuarioId != usuarioId;
    }

    setState(() {
      podeAvaliar = usuarioId != null &&
          FoodTravelService.usuarioPodeAvaliar(usuarioId!, widget.prato.id) &&
          restaurante?.usuarioId != usuarioId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prato;

    return Scaffold(
      appBar: AppBar(title: Text(p.nome)),
      body: ListView(
        children: [
          p.imagemUrl.isNotEmpty
              ? Image.network(p.imagemUrl, height: 220, fit: BoxFit.cover)
              : Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood, size: 80),
                ),

          ListTile(
            title: const Text("Descrição"),
            subtitle: Text(p.descricao),
          ),

          ListTile(
            title: const Text("Preço"),
            subtitle: Text("R\$ ${p.preco.toStringAsFixed(2)}"),
          ),

          ListTile(
            title: const Text("Média de Avaliações"),
            subtitle: Text(media.toStringAsFixed(1)),
          ),

          if (podeAvaliar)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text("Avaliar Prato"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AvaliarPratoPage(prato: p),
                    ),
                  );
                  _carregar();
                },
              ),
            ),
        ],
      ),
    );
  }
}
