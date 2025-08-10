import 'package:flutter/material.dart';

class HomeEtudiantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil Étudiant")),
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bienvenue, Étudiant !"),
            ],
          ),
        ],
      ),
    );
  }
}
