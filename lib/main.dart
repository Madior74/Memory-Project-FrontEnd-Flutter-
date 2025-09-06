import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_management_system/Screen/Auth/login_screen.dart';
import 'package:school_management_system/Screen/Professeurs/professeur_screen.dart';
import 'package:school_management_system/Screen/Etudiants/etudiant_screen.dart';
import 'package:school_management_system/Screen/AnneeAcademique/list_annee_academique.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = '/';
  final pref = await SharedPreferences.getInstance();
  final userDataString = pref.getString('user');

  if (userDataString != null) {
    final user = jsonDecode(userDataString) as Map<String, dynamic>;
    final String role = user['role'];
    switch (role) {
      case 'ROLE_ADMIN':
        initialRoute = '/home-admin';
        break;
      case 'ROLE_ETUDIANT':
        initialRoute = '/home-etudiant';
        break;
      case 'ROLE_PROFESSEUR':
        initialRoute = '/home-professeur';
        break;
      default:
        initialRoute = '/';
    }
  }

  runApp(
    ProviderScope(
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(primary: Colors.tealAccent),
      ),
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: widget.initialRoute,
      routes: {
        '/': (context) => const LoginScreen(),
        '/home-etudiant': (context) => HomeEtudiantScreen(),
        '/home-professeur': (context) => HomeProfesseurScreen(),
        '/home-admin': (context) => const ListSession(),
      },
    );
  }
}
