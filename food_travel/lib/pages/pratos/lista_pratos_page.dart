import 'package:flutter/material.dart';
import '../../models/prato.dart';
import '../../services/food_travel_service.dart';
import 'prato_detail_page.dart';

class ListaPratosPage extends StatefulWidget {
  const ListaPratosPage({super.key});

  @override
  State<ListaPratosPage> createState() => _ListaPratosPageState();
}

class _ListaPratosPageState extends State<ListaPratosPage> {
  List<Prato> _pratos = [];

  @override
  void initState() {
    super.initState();
    _carregarPratos();
  }

  Future<void> _carregarPratos() async {
    final lista = FoodTravelService.listarPratos();
    setState(() {
      _pratos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pratos"),
      ),
      body: _pratos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum prato cadastrado.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _pratos.length,
              itemBuilder: (context, index) {
                final p = _pratos[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 3,
                  child: ListTile(
                    leading: p.imageUrl.isNotEmpty
                        ? Image.network(
                            p.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.fastfood, size: 40),
                    title: Text(
                      p.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "R\$ ${p.preco.toStringAsFixed(2)}",
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PratoDetailPage(prato: p),
                        ),
                      ).then((_) => _carregarPratos());
                    },
                  ),
                );
              },
            ),
    );
  }
}
