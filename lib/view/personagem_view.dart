import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editar_personagem_view.dart';

class PersonagemView extends StatefulWidget {
  const PersonagemView({super.key});

  @override
  State<PersonagemView> createState() => _PersonagemViewState();
}

class _PersonagemViewState extends State<PersonagemView> {
  Map<String, dynamic>? dadosPersonagem;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('personagens')
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        dadosPersonagem = doc.data();
      });
    }
  }

  void _abrirTelaEdicao() async {
    final atualizado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditarPersonagemView()),
    );
    if (atualizado == true) {
      _carregarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    final personagem = dadosPersonagem ?? {
      'nome': '',
      'classe': '',
      'raca': '',
      'nivel': '',
      'vidaAtual': '',
      'vidaMaxima': '',
      'atributos': {
        'Força': '', 'Destreza': '', 'Constituição': '',
        'Inteligência': '', 'Sabedoria': '', 'Carisma': ''
      },
    };

    return Scaffold(
      appBar: AppBar(title: Text('Personagem')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCardInfoPersonagem(personagem),
            SizedBox(height: 16),
            _buildCardAtributos(personagem['atributos']),
            SizedBox(height: 16),
            _buildCardVida(personagem['vidaAtual'], personagem['vidaMaxima']),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _abrirTelaEdicao,
              icon: Icon(Icons.edit),
              label: Text('Editar Ficha'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfoPersonagem(Map<String, dynamic> personagem) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(personagem['nome'] ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoTile(Icons.shield, 'Classe', personagem['classe'] ?? ''),
                _buildInfoTile(Icons.pets, 'Raça', personagem['raca'] ?? ''),
                _buildInfoTile(Icons.stars, 'Nível', personagem['nivel'] ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardAtributos(Map atributos) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Atributos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2,
              children: atributos.entries
                  .map((e) => Column(
                        children: [
                          Text(e.key, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(e.value.toString()),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardVida(String atual, String maximo) {
    return Card(
      color: Colors.red.shade100,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.favorite, color: Colors.red.shade700, size: 32),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pontos de Vida', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('$atual / $maximo', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
