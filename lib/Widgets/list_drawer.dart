import 'package:flutter/material.dart';

class MyDrawerListTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isSelected; // Ajout d'une propriété pour l'état sélectionné

  const MyDrawerListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isSelected = false, // Valeur par défaut
  });

  @override
  _MyDrawerListTileState createState() => _MyDrawerListTileState();
}

class _MyDrawerListTileState extends State<MyDrawerListTile> {
  Color _tileColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _tileColor = Colors.white.withOpacity(0.3); // Couleur au survol
          });
        },
        onExit: (_) {
          setState(() {
            _tileColor = widget.isSelected
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent; // Couleur par défaut ou sélectionnée
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _tileColor,
          ),
          child: ListTile(
            leading: Icon(
              widget.icon,
              color: Colors.white,
            ),
            title: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              setState(() {
                // Changez la couleur de l'élément sélectionné
                _tileColor = Colors.blue.withOpacity(0.5);
              });
              widget.onTap();
            },
          ),
        ),
      ),
    );
  }
}
