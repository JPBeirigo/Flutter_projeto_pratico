import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9DC), 
      appBar: AppBar(
        title: Text('Página Inicial'),
        backgroundColor: const Color(0xFF5D4037), 
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
          children: [
            _buildGridItem(context, icon: Icons.person, label: 'Personagem', routeName: 'personagem'),
            _buildGridItem(context, icon: Icons.onetwothree, label: 'Dados', routeName: 'dados'),
            _buildGridItem(context, icon: Icons.backpack, label: 'Inventário', routeName: 'inventario'),
            _buildGridItem(context, icon: Icons.book, label: 'Grimório', routeName: 'grimorio'),
            _buildGridItem(context, icon: Icons.hourglass_bottom_outlined, label: 'Turn Order', routeName: 'turn_order'),
            _buildGridItem(context, icon: Icons.bookmark, label: 'Journal', routeName: 'journal'),
            _buildGridItem(context, icon: Icons.info, label: 'Sobre', routeName: 'sobre'),
            _buildGridItem(
              context,
              icon: Icons.logout,
              label: 'Sair',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? routeName,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            }
          },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD7CCC8), 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.shade200,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Color(0xFF6D4C41)), 
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4E342E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
