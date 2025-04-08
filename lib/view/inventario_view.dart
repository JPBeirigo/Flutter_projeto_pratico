import 'package:flutter/material.dart';
import '../items_lista.dart';
import '../model/item_model.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({super.key});

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  late List<Item> itens;

  @override
  void initState() {
    super.initState();
    itens = List.from(listaItens);
  }

  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removido do inventário')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE9), // fundo bege claro
      appBar: AppBar(
        title: Text('Inventário'),
        backgroundColor: const Color(0xFF6D4C41), // marrom escuro
      ),
      body: itens.isEmpty
          ? Center(
              child: Text(
                'Nenhum item no inventário',
                style: TextStyle(color: Colors.brown[800]),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: itens.length,
              separatorBuilder: (_, __) => Divider(height: 16, color: Colors.brown[200]),
              itemBuilder: (context, index) {
                final item = itens[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.brown[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.shade200,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: ListTile(
                    title: Text(item.nome, style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.valor} gp', style: TextStyle(color: Colors.brown[700])),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[400]),
                      onPressed: () => removerItem(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
