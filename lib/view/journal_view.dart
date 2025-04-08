import 'package:flutter/material.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final List<String> anotacoes = [];
  final TextEditingController _controller = TextEditingController();

  void adicionarNota() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        anotacoes.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }

  void removerNota(int index) {
    setState(() {
      anotacoes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jornal de Aventuras'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Escreva uma nova anotação...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: adicionarNota,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: anotacoes.isEmpty
                  ? Center(child: Text('Sem anotações no momento'))
                  : ListView.separated(
                      itemCount: anotacoes.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(anotacoes[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removerNota(index),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
