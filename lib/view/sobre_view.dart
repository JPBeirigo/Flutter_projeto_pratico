import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.info_outline,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sobre o Desenvolvedor',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Desenvolvedor: João Pedro Ferreira Beirigo. Código: 837199',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            Text(
              'Sobre o Aplicativo',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Este app foi criado com o objetivo de servir como uma ferramenta para ajudar com o andamento de mesas de RPG, oferecendo funções voltadas para organização, consulta e agilidade. Ele ainda está em seus estágios bem iniciais, portanto ainda há apenas o espoço de suas funções.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
