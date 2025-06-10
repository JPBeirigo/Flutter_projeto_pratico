import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/item_model.dart';
import 'editar_item_view.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({super.key});

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  List<Item> itens = [];

  @override
  void initState() {
    super.initState();
    carregarItens();
  }

  Future<void> carregarItens() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance.collection('inventarios').doc(uid).get();

    if (snapshot.exists) {
      final List<dynamic> dados = snapshot.data()?['itens'] ?? [];
      setState(() {
        itens = dados.map((e) => Item.fromMap(Map<String, dynamic>.from(e))).toList();
      });
    }
  }

  Future<void> salvarItens() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final dados = itens.map((e) => e.toMap()).toList();
    await FirebaseFirestore.instance.collection('inventarios').doc(uid).set({'itens': dados});
  }

  Future<void> removerItem(int index) async {
    setState(() {
      itens.removeAt(index);
    });

    try {
      await salvarItens();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removido do inventário'),
          backgroundColor: Colors.green[600],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover item: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  Future<void> adicionarItem() async {
    final novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (_) => const EditarItemView()),
    );

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });

      try {
        await salvarItens();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item adicionado com sucesso!'),
            backgroundColor: Colors.green[600],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar item: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  Future<void> editarItem(int index) async {
    final itemEditado = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (_) => EditarItemView(item: itens[index])),
    );

    if (itemEditado != null) {
      setState(() {
        itens[index] = itemEditado;
      });

      try {
        await salvarItens();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item atualizado com sucesso!'),
            backgroundColor: Colors.green[600],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar item: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE9),
      appBar: AppBar(
        title: Text('Inventário'),
        backgroundColor: const Color(0xFF6D4C41),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: adicionarItem,
            tooltip: 'Adicionar item',
          ),
        ],
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
                    title: Text(
                      item.nome,
                      style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.valor} gp - ${item.quantidade}x - ${item.peso} lb',
                            style: TextStyle(color: Colors.brown[700])),
                        if (item.descricao != null && item.descricao!.isNotEmpty)
                          Text(item.descricao!, style: TextStyle(color: Colors.brown[600])),
                      ],
                    ),
                    onTap: () => editarItem(index),
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
