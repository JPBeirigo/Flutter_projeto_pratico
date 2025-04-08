import 'dart:math';
import 'package:flutter/material.dart';

class RolagemDadosView extends StatefulWidget {
  const RolagemDadosView({super.key});

  @override
  State<RolagemDadosView> createState() => _RolagemDadosViewState();
}

class _RolagemDadosViewState extends State<RolagemDadosView> {
  int? resultado;

  void rolarDado(int lados) {
    setState(() {
      final rng = Random();
      resultado = rng.nextInt(lados) + 1;
    });
  }

  final dados = [4, 6, 8, 10, 12, 20, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rolagem de Dados'),
        backgroundColor: Colors.red[300],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.red[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              resultado != null ? 'Resultado: $resultado' : 'Toque em um dado para rolar',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                itemCount: dados.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final dado = dados[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () => rolarDado(dado),
                    child: Text(
                      'D$dado',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
