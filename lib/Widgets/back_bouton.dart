import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.maybePop(
            context); // Cela évite que l'app se ferme si aucune page précédente
      },
      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
    );
  }
}
