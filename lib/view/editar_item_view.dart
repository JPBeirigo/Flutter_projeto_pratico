import 'package:flutter/material.dart';
import '../model/item_model.dart';

class EditarItemView extends StatefulWidget {
  final Item? item;

  const EditarItemView({super.key, this.item});

  @override
  State<EditarItemView> createState() => _EditarItemViewState();
}

class _EditarItemViewState extends State<EditarItemView> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final descricaoController = TextEditingController();
  final pesoController = TextEditingController();
  final quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      final item = widget.item!;
      nomeController.text = item.nome;
      valorController.text = item.valor.toString();
      descricaoController.text = item.descricao ?? '';
      pesoController.text = item.peso?.toString() ?? '';
      quantidadeController.text = item.quantidade?.toString() ?? '';
    }
  }

  void _salvar() {
    if (_formKey.currentState?.validate() != true) return;

    final item = Item(
      nome: nomeController.text.trim(),
      valor: int.tryParse(valorController.text.trim()) ?? 0,
      descricao: descricaoController.text.trim(),
      peso: double.tryParse(pesoController.text.trim()) ?? 0.0,
      quantidade: int.tryParse(quantidadeController.text.trim()) ?? 1,
    );

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Adicionar Item' : 'Editar Item'),
        backgroundColor: const Color(0xFF6D4C41),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Item'),
                validator: (value) => value == null || value.isEmpty ? 'Digite um nome' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: valorController,
                decoration: InputDecoration(labelText: 'Valor (gp)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Digite o valor' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: pesoController,
                decoration: InputDecoration(labelText: 'Peso (lb)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvar,
                icon: Icon(Icons.save),
                label: Text('Salvar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
