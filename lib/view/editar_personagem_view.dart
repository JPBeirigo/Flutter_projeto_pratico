import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarPersonagemView extends StatefulWidget {
  const EditarPersonagemView({super.key});

  @override
  State<EditarPersonagemView> createState() => _EditarPersonagemViewState();
}

class _EditarPersonagemViewState extends State<EditarPersonagemView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController classeController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController nivelController = TextEditingController();
  final TextEditingController vidaAtualController = TextEditingController();
  final TextEditingController vidaMaximaController = TextEditingController();

  final Map<String, TextEditingController> atributosControllers = {
    'Força': TextEditingController(),
    'Destreza': TextEditingController(),
    'Constituição': TextEditingController(),
    'Inteligência': TextEditingController(),
    'Sabedoria': TextEditingController(),
    'Carisma': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _carregarPersonagem();
  }

  Future<void> _carregarPersonagem() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('personagens').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      nomeController.text = data['nome'] ?? '';
      classeController.text = data['classe'] ?? '';
      racaController.text = data['raca'] ?? '';
      nivelController.text = data['nivel'] ?? '';
      vidaAtualController.text = data['vidaAtual'] ?? '';
      vidaMaximaController.text = data['vidaMaxima'] ?? '';

      final atributos = Map<String, dynamic>.from(data['atributos'] ?? {});
      atributosControllers.forEach((chave, controller) {
        controller.text = atributos[chave]?.toString() ?? '';
      });

      setState(() {}); // Atualiza a tela com os dados carregados
    }
  }

  Future<void> _salvarPersonagem() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final atributos = {
      for (var entry in atributosControllers.entries)
        entry.key: entry.value.text.trim(),
    };

    final personagemData = {
      'nome': nomeController.text.trim(),
      'classe': classeController.text.trim(),
      'raca': racaController.text.trim(),
      'nivel': nivelController.text.trim(),
      'vidaAtual': vidaAtualController.text.trim(),
      'vidaMaxima': vidaMaximaController.text.trim(),
      'atributos': atributos,
    };

    await FirebaseFirestore.instance
        .collection('personagens')
        .doc(uid)
        .set(personagemData);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Personagem')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nome', nomeController),
              _buildTextField('Classe', classeController),
              _buildTextField('Raça', racaController),
              _buildTextField('Nível', nivelController, keyboardType: TextInputType.number),
              Row(
                children: [
                  Expanded(child: _buildTextField('Vida Atual', vidaAtualController, keyboardType: TextInputType.number)),
                  SizedBox(width: 10),
                  Expanded(child: _buildTextField('Vida Máxima', vidaMaximaController, keyboardType: TextInputType.number)),
                ],
              ),
              SizedBox(height: 16),
              Text('Atributos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ...atributosControllers.entries.map(
                (entry) => _buildTextField(entry.key, entry.value, keyboardType: TextInputType.number),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarPersonagem,
                icon: Icon(Icons.save),
                label: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Preencha este campo' : null,
      ),
    );
  }
}
