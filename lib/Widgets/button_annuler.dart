import 'package:flutter/material.dart';

class ButtonAnnuler extends StatelessWidget {
  const ButtonAnnuler({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(
        "Annuler",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.maybePop(
            context); // Cela évite que l'app se ferme si aucune page précédente
      },
      icon: Icon(
        Icons.close,
        color: Colors.red,
      ),
    );
  }
}
