import 'package:flutter/material.dart';

class HomeAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil Administrateur")),
      body: Center(child: Text("Bienvenue, Administrateur !")),
    );
  }
}
