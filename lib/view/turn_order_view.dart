import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TurnOrderView extends StatefulWidget {
  const TurnOrderView({super.key});

  @override
  State<TurnOrderView> createState() => _TurnOrderViewState();
}

class _TurnOrderViewState extends State<TurnOrderView> {
  List<Map<String, dynamic>> personagens = [];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _iniciativaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarPersonagens();
  }

  Future<void> carregarPersonagens() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('turnos')
        .doc(uid)
        .collection('personagens')
        .get();

    setState(() {
      personagens = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList()
        ..sort((a, b) => b['iniciativa'].compareTo(a['iniciativa']));
    });
  }

  Future<void> adicionarOuEditarPersonagem({String? id}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final nome = _nomeController.text.trim();
    final iniciativa = int.tryParse(_iniciativaController.text.trim()) ?? 0;
    if (nome.isEmpty) return;

    final data = {'nome': nome, 'iniciativa': iniciativa};

    final ref = FirebaseFirestore.instance
        .collection('turnos')
        .doc(uid)
        .collection('personagens');

    if (id == null) {
      await ref.add(data);
    } else {
      await ref.doc(id).update(data);
    }

    _nomeController.clear();
    _iniciativaController.clear();
    Navigator.pop(context);
    await carregarPersonagens();
  }

  Future<void> removerPersonagem(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('turnos')
        .doc(uid)
        .collection('personagens')
        .doc(id)
        .delete();

    await carregarPersonagens();
  }

  void proximoTurno() {
    if (personagens.isEmpty) return;
    setState(() {
      final atual = personagens.removeAt(0);
      personagens.add(atual);
    });
  }

  void abrirFormulario({Map<String, dynamic>? personagem}) {
    if (personagem != null) {
      _nomeController.text = personagem['nome'];
      _iniciativaController.text = personagem['iniciativa'].toString();
    } else {
      _nomeController.clear();
      _iniciativaController.clear();
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
              personagem != null ? 'Editar Personagem' : 'Novo Personagem',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _iniciativaController,
              decoration: const InputDecoration(labelText: 'Iniciativa'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
              onPressed: () =>
                  adicionarOuEditarPersonagem(id: personagem?['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Ordem de Turnos'),
        backgroundColor: Colors.blueGrey[200],
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => abrirFormulario(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: personagens.isEmpty
                ? const Center(child: Text('Sem personagens adicionados'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: personagens.length,
                    itemBuilder: (context, index) {
                      final personagem = personagens[index];
                      final isCurrent = index == 0;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isCurrent ? const Color(0xFFD6EAF8) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          title: Text(
                            personagem['nome'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            child: Text(
                              '${personagem['iniciativa']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => abrirFormulario(personagem: personagem),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removerPersonagem(personagem['id']),
                              ),
                              Text(
                                '#${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton.icon(
              onPressed: proximoTurno,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[300],
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.skip_next),
              label: const Text(
                'Próximo Turno',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
