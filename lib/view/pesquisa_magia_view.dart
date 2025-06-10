import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/magia_model.dart';

class PesquisaMagiaView extends StatefulWidget {
  const PesquisaMagiaView({super.key});

  @override
  State<PesquisaMagiaView> createState() => _PesquisaMagiaViewState();
}

class _PesquisaMagiaViewState extends State<PesquisaMagiaView> {
  String filtro = '';
  String ordenacao = 'nome';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      appBar: AppBar(
        title: const Text('Buscar Magias'),
        backgroundColor: Colors.brown[200],
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar magia por nome...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (valor) => setState(() => filtro = valor.toLowerCase()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: ordenacao,
              items: const [
                DropdownMenuItem(value: 'nome', child: Text('Nome')),
                DropdownMenuItem(value: 'nivel', child: Text('Nível')),
              ],
              onChanged: (valor) => setState(() => ordenacao = valor ?? 'nome'),
              decoration: const InputDecoration(labelText: 'Ordenar por'),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('grimorios')
                  .doc(uid)
                  .collection('magias')
                  .orderBy(ordenacao)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma magia encontrada'));
                }

                final magias = snapshot.data!.docs
                    .map((doc) => Magia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                    .where((magia) => magia.nome.toLowerCase().contains(filtro))
                    .toList();

                return ListView.builder(
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
