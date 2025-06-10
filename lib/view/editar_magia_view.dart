import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/magia_model.dart';

class EditarMagiaView extends StatefulWidget {
  final Magia? magia;

  const EditarMagiaView({super.key, this.magia});

  @override
  State<EditarMagiaView> createState() => _EditarMagiaViewState();
}

class _EditarMagiaViewState extends State<EditarMagiaView> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final nivelController = TextEditingController();
  final descricaoController = TextEditingController();
  final escolaController = TextEditingController();
  final tempoController = TextEditingController();
  final alcanceController = TextEditingController();
  final componentesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final magia = widget.magia;
    if (magia != null) {
      nomeController.text = magia.nome;
      nivelController.text = magia.nivel;
      descricaoController.text = magia.descricao;
      escolaController.text = magia.escola;
      tempoController.text = magia.tempoConjuracao;
      alcanceController.text = magia.alcance;
      componentesController.text = magia.componentes;
    }
  }

  Future<void> _salvarMagia() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final magiaData = {
      'nome': nomeController.text.trim(),
      'nivel': nivelController.text.trim(),
      'descricao': descricaoController.text.trim(),
      'escola': escolaController.text.trim(),
      'tempoConjuracao': tempoController.text.trim(),
      'alcance': alcanceController.text.trim(),
      'componentes': componentesController.text.trim(),
    };

    final docRef = FirebaseFirestore.instance
        .collection('grimorios')
        .doc(uid)
        .collection('magias');

    if (widget.magia == null) {
      await docRef.add(magiaData);
    } else {
      await docRef.doc(widget.magia!.id).set(magiaData);
    }

    Navigator.pop(context, true); // Retorna true para indicar atualização
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.magia == null ? 'Nova Magia' : 'Editar Magia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nome da Magia', nomeController),
              _buildTextField('Nível', nivelController),
              _buildTextField('Escola de Magia', escolaController),
              _buildTextField('Tempo de Conjuração', tempoController),
              _buildTextField('Alcance', alcanceController),
              _buildTextField('Componentes', componentesController),
              _buildTextField('Descrição', descricaoController, maxLines: 5),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvarMagia,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Preencha este campo' : null,
      ),
    );
  }
}
