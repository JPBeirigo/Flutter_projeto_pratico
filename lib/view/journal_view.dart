import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Map<String, dynamic>> anotacoes = [];

  @override
  void initState() {
    super.initState();
    carregarAnotacoes();
  }

  Future<void> carregarAnotacoes() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('jornais')
        .doc(uid)
        .collection('anotacoes')
        .orderBy('data', descending: true)
        .get();

    setState(() {
      anotacoes = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  Future<void> adicionarOuEditarNota({String? id}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();
    if (titulo.isEmpty || descricao.isEmpty) return;

    final notaData = {
      'titulo': titulo,
      'descricao': descricao,
      'data': Timestamp.now(),
    };

    if (id == null) {
      // Nova anotação
      await FirebaseFirestore.instance
          .collection('jornais')
          .doc(uid)
          .collection('anotacoes')
          .add(notaData);
    } else {
      // Editar anotação existente
      await FirebaseFirestore.instance
          .collection('jornais')
          .doc(uid)
          .collection('anotacoes')
          .doc(id)
          .update(notaData);
    }

    _tituloController.clear();
    _descricaoController.clear();
    Navigator.pop(context); // Fecha o modal
    carregarAnotacoes();
  }

  Future<void> removerNota(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('jornais')
        .doc(uid)
        .collection('anotacoes')
        .doc(id)
        .delete();

    carregarAnotacoes();
  }

  void abrirFormulario({Map<String, dynamic>? nota}) {
    if (nota != null) {
      _tituloController.text = nota['titulo'];
      _descricaoController.text = nota['descricao'];
    } else {
      _tituloController.clear();
      _descricaoController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nota != null ? 'Editar Anotação' : 'Nova Anotação',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
              onPressed: () => adicionarOuEditarNota(id: nota?['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jornal de Aventuras'),
        backgroundColor: Colors.brown[200],
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => abrirFormulario(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: anotacoes.isEmpty
            ? const Center(child: Text('Sem anotações no momento'))
            : ListView.separated(
                itemCount: anotacoes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final nota = anotacoes[index];
                  return ListTile(
                    title: Text(nota['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(nota['descricao']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => abrirFormulario(nota: nota),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removerNota(nota['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
