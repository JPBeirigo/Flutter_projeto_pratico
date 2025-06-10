import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/magia_model.dart';
import 'editar_magia_view.dart';
import 'pesquisa_magia_view.dart';

class GrimorioView extends StatefulWidget {
  const GrimorioView({super.key});

  @override
  State<GrimorioView> createState() => _GrimorioViewState();
}

class _GrimorioViewState extends State<GrimorioView> {
  List<Magia> magias = [];

  @override
  void initState() {
    super.initState();
    carregarMagias();
  }

  Future<void> carregarMagias() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('grimorios')
        .doc(uid)
        .collection('magias')
        .get();

    setState(() {
      magias = snapshot.docs
          .map((doc) => Magia.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> adicionarOuEditarMagia([Magia? magia]) async {
    final atualizou = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditarMagiaView(magia: magia)),
    );

    if (atualizou == true) {
      await carregarMagias();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            magia == null ? 'Magia adicionada com sucesso' : 'Magia atualizada com sucesso',
          ),
        ),
      );
    }
  }

  Future<void> removerMagia(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('grimorios')
          .doc(uid)
          .collection('magias')
          .doc(id)
          .delete();

      await carregarMagias();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Magia removida')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover magia: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      appBar: AppBar(
        title: const Text('Grimório'),
        backgroundColor: Colors.brown[200],
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PesquisaMagiaView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => adicionarOuEditarMagia(),
          ),
        ],
      ),
      body: magias.isEmpty
          ? const Center(child: Text('Nenhuma magia no grimório'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: magias.length,
              itemBuilder: (context, index) {
                final magia = magias[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      magia.nome,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Nível ${magia.nivel} | ${magia.escola}\n'
                        'Tempo: ${magia.tempoConjuracao} | Alcance: ${magia.alcance}\n'
                        'Componentes: ${magia.componentes}\n\n'
                        '${magia.descricao}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    onTap: () => adicionarOuEditarMagia(magia),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removerMagia(magia.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
