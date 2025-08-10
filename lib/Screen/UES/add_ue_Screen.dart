import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/semestre/model_semestre.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';
import 'package:school_management_system/Screen/UES/listes_ue.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';
import 'package:school_management_system/Screen/semestre/semestre_service.dart';

import 'package:school_management_system/Screen/UES/ue_service.dart';

class AddUEPage extends StatefulWidget {
  const AddUEPage({super.key});

  @override
  _AddUEPageState createState() => _AddUEPageState();
}

class _AddUEPageState extends State<AddUEPage> {
  late Future<List<UE>> futures;
  late Future<List<Filiere>> futureFilieres;

  final _formKey = GlobalKey<FormState>();

  String _nomUE = '';
  String _codeUE = '';
  Filiere? _filiereSelectionnee;
  Niveau? _niveauSelectionne;
  Semestre? _semestreSelectionne;

  List<Filiere> _filieres = [];
  List<Niveau> _niveaux = [];
  List<Semestre> _semestres = [];

  final List<int> credits = [4, 5, 6];

  @override
  void initState() {
    super.initState();
    _loadFilieres();
    futureFilieres = FiliereService().getFilieres();
    futures = UeService().getUes();
  }

  // Méthodes pour récupérer les données depuis l'API
  Future<void> _loadFilieres() async {
    try {
      final filieres = await FiliereService().getFilieres();
      setState(() {
        _filieres = filieres;
      });
    } catch (e) {
      print("Erreur lors du chargement des filières : $e");
      // Gérer l'erreur (afficher un message à l'utilisateur, etc.)
    }
  }

  Future<void> _loadNiveaux(int filiereId) async {
    try {
      final niveaux = await NiveauService().getNiveauxByFiliere(filiereId);
      setState(() {
        _niveaux = niveaux;
        // Réinitialiser les semestres lorsque le niveau change
        _semestres = [];
        _niveauSelectionne = null;
        _semestreSelectionne = null;
      });
    } catch (e) {
      print("Erreur lors du chargement des niveaux : $e");
      // Gérer l'erreur
    }
  }

  Future<void> _loadSemestres(int niveauId) async {
    try {
      final semestres = await SemestreService().getSemestreByNiveau(niveauId);
      setState(() {
        _semestres = semestres;
        _semestreSelectionne = null;
      });
    } catch (e) {
      print("Erreur lors du chargement des semestres : $e");
      // Gérer l'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Ajouter une UE',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //choix de la filiere

              DropdownButtonFormField<Filiere>(
                decoration: const InputDecoration(labelText: 'Filière'),
                value: _filiereSelectionnee,
                items: _filieres.map((filiere) {
                  return DropdownMenuItem<Filiere>(
                    value: filiere,
                    child: Text(filiere.nomFiliere),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _filiereSelectionnee = value;
                    // Charger les niveaux lorsque la filière change
                    if (value != null) {
                      _loadNiveaux(value.id!);
                    } else {
                      // Réinitialiser les niveaux et semestres si aucune filière n'est sélectionnée
                      _niveaux = [];
                      _semestres = [];
                      _niveauSelectionne = null;
                      _semestreSelectionne = null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner une filière' : null,
              ),
              DropdownButtonFormField<Niveau>(
                decoration: const InputDecoration(labelText: 'Niveau'),
                value: _niveauSelectionne,
                items: _niveaux.map((niveau) {
                  return DropdownMenuItem<Niveau>(
                    value: niveau,
                    child: Text(niveau.nomNiveau),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _niveauSelectionne = value;
                    // Charger les semestres lorsque le niveau change
                    if (value != null) {
                      _loadSemestres(value.id!);
                    } else {
                      // Réinitialiser les semestres si aucun niveau n'est sélectionné
                      _semestres = [];
                      _semestreSelectionne = null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un niveau' : null,
              ),
              DropdownButtonFormField<Semestre>(
                decoration: const InputDecoration(labelText: 'Semestre'),
                value: _semestreSelectionne,
                items: _semestres.map((semestre) {
                  return DropdownMenuItem<Semestre>(
                    value: semestre,
                    child: Text(semestre.nomSemestre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _semestreSelectionne = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un semestre' : null,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom de l\'UE'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'UE';
                  }
                  return null;
                },
                onSaved: (value) => _nomUE = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Code de l\'UE'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le code de l\'UE';
                  }
                  return null;
                },
                onSaved: (value) => _codeUE = value!,
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Créer l'objet UE
                    final newUE = UE(
                      nomUE: _nomUE,
                      codeUE: _codeUE,
                      semestre: _semestreSelectionne,
                      dateAjout: DateTime.now(),
                    );

                    try {
                      bool exists = await UeService()
                          .ueExist(_nomUE, _semestreSelectionne!.id);
                      if (exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Un Module avec ce nom existe déjà dans cette UE."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      await UeService()
                          .addUeToSemestre(_semestreSelectionne!.id, newUE);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey.shade300,
                            content: const Text('UE ajouté avec succès'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ListeDesUES()),
                                  );
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erreur lors de l'ajout : $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    // Envoyer l'objet UE à votre API (à implémenter)
                    print(newUE.toJson());
                    // Pour le débogage
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
