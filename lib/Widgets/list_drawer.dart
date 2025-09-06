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
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.isSelected || _tileColor.opacity > 0 && _tileColor != Colors.transparent;
    final Color baseHoverColor = Colors.white.withOpacity(0.10);
    final Color selectedColor = Colors.blue.withOpacity(0.20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
            _tileColor = baseHoverColor;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
            _tileColor = widget.isSelected ? selectedColor : Colors.transparent;
          });
        },
        child: AnimatedContainer
          (
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.isSelected
                ? selectedColor
                : _isHovering
                    ? baseHoverColor
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: (widget.isSelected || _isHovering) ? Colors.blueAccent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            horizontalTitleGap: 10,
            leading: Icon(
              widget.icon,
              color: (widget.isSelected || _isHovering) ? Colors.white : Colors.white70,
              size: 20,
            ),
            title: Text(
              widget.text,
              style: TextStyle(
                color: (widget.isSelected || _isHovering) ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: .2,
              ),
            ),
            onTap: () {
              setState(() {
                _tileColor = selectedColor;
              });
              widget.onTap();
            },
          ),
        ),
      ),
    );
  }
}
