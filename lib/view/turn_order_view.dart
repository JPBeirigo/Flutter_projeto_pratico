import 'package:flutter/material.dart';

class TurnOrderView extends StatefulWidget {
  const TurnOrderView({super.key});

  @override
  State<TurnOrderView> createState() => _TurnOrderViewState();
}

class _TurnOrderViewState extends State<TurnOrderView> {
  final List<Map<String, dynamic>> personagens = [
    {'nome': '🧝 Lyris', 'iniciativa': 18},
    {'nome': '🧙 Zorbin', 'iniciativa': 9},
    {'nome': '🪓 Gorak', 'iniciativa': 12},
    {'nome': '👹 Goblin 1', 'iniciativa': 15},
    {'nome': '👹 Goblin 2', 'iniciativa': 7},
  ];

  @override
  void initState() {
    super.initState();
    _ordenarLista();
  }

  void _ordenarLista() {
    personagens.sort((a, b) => b['iniciativa'].compareTo(a['iniciativa']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Ordem de Turnos'),
        backgroundColor: Colors.blueGrey[200],
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: personagens.length,
              itemBuilder: (context, index) {
                final personagem = personagens[index];
                final isCurrent = index == 0;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent ? Color(0xFFD6EAF8) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(
                      personagem['nome'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(
                        '${personagem['iniciativa']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                // ação futura aqui
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[300],
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.skip_next),
              label: Text(
                'Próximo Turno',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
