import 'package:flutter/material.dart';

class PersonagemView extends StatelessWidget {
  const PersonagemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: Text('Personagem'),
        backgroundColor: const Color(0xFF37474F), 
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'lib/assets/images/personagem.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            _buildCardInfoPersonagem(),
            SizedBox(height: 16),
            _buildCardAtributos(),
            SizedBox(height: 16),
            _buildCardVida(),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.grey.shade800),
              label: Text('Editar Ficha', style: TextStyle(color: Colors.grey.shade800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300, 
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfoPersonagem() {
    return Card(
      color: Color(0xFFCFD8DC), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Tharion, o Bravo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoTile(Icons.shield, 'Classe', 'Guerreiro'),
                _buildInfoTile(Icons.pets, 'Raça', 'Humano'),
                _buildInfoTile(Icons.stars, 'Nível', '5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardAtributos() {
    final atributos = {
      'Força': '16',
      'Destreza': '12',
      'Constituição': '14',
      'Inteligência': '10',
      'Sabedoria': '8',
      'Carisma': '13',
    };

    return Card(
      color: Color(0xFFCFD8DC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Atributos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                          Text(e.value),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardVida() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
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
                Text('38 / 45', style: TextStyle(fontSize: 18)),
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
        Icon(icon, size: 32, color: Color(0xFF546E7A)), 
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
