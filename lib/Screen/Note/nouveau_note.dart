import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Note/Devoir/model_devoir.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Screen/Modules/moduleService.dart';
import 'package:school_management_system/Screen/Note/Devoir/devoir_service.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late Future<List<Devoir>> futureNotes;

  final DevoirService devoirService = DevoirService();
  final _formKey = GlobalKey<FormState>();

  CandidatPreInscrit? selectedEtudiant;
  Professeur? selectedProfesseur;
  Module? selectedModule;
  double noteDevoir = 0.0;
  double? noteExamen;
  DateTime? _selectedDate;
  List<CandidatPreInscrit> etudiants = [];
  List<Professeur> professeurs = [];
  List<Module> modules = [];

  bool isLoading = true;

  String? selectedTypeDevoir;
  final List<String> listeTypeDevoir = [
    'Normal',
    'Rattrapage',
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
    futureNotes = DevoirService().getAllDevoir();
  }

  void _fetchData() async {
    try {
      List<CandidatPreInscrit> etudiantData = await EtudiantService().getAllEtudiant();
      List<Professeur> professeurData =
          await ProfesseurService().fetchprofesseurs();
      List<Module> moduleData = await ModuleService().getAllModules();

      setState(() {
        etudiants = etudiantData;
        professeurs = professeurData;
        modules = moduleData;
        isLoading = false;
      }); 
    } catch (e) {
      print("Erreur: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedEtudiant == null ||
        selectedProfesseur == null ||
        selectedModule == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Veuillez sélectionner tous les champs requis")),
      );
      return;
    }

    final newNote = Devoir(
      id: 0,
      note: noteDevoir,
      etudiant: selectedEtudiant!,
      professeur: selectedProfesseur!,
      courseModule: selectedModule!,
      dateAttribution: _selectedDate ?? DateTime.now(),
    );

    final noteJson = newNote.toJson();
    debugPrint('Sending JSON: ${jsonEncode(noteJson)}');
    print('JSON envoyé: ${jsonEncode(noteJson)}');
    print('Final JSON being sent:');
    print(jsonEncode(noteJson));
    print('Date string: ${noteJson['dateAttribution']}');

    try {
      await devoirService.createdevoir(devoir: noteJson);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note ajoutée avec succès!")),
        );
        setState(() {
          _fetchData();
          futureNotes = DevoirService().getAllDevoir();
        });
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${e.toString()}")),
        );
      }
      print('Erreur détaillée: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une Note")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<CandidatPreInscrit>(
                      decoration: InputDecoration(
                          labelText: "Sélectionner un étudiant"),
                      items: etudiants.map((etudiant) {
                        return DropdownMenuItem(
                          value: etudiant,
                          child: Text("${etudiant.prenom}  ${etudiant.nom}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEtudiant = value;
                        });
                      },
                      validator: (value) => value == null
                          ? "Veuillez sélectionner un étudiant"
                          : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Session",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      items: listeTypeDevoir.map((String profil) {
                        return DropdownMenuItem(
                          value: profil,
                          child: Text(profil),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTypeDevoir = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    DropdownButtonFormField<Professeur>(
                      decoration: InputDecoration(
                          labelText: "Sélectionner un professeur"),
                      items: professeurs.map((prof) {
                        return DropdownMenuItem(
                          value: prof,
                          child: Text("${prof.prenom} ${prof.nom}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProfesseur = value;
                        });
                      },
                      validator: (value) => value == null
                          ? "Veuillez sélectionner un professeur"
                          : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Module>(
                      decoration:
                          InputDecoration(labelText: "Sélectionner un module"),
                      items: modules.map((mod) {
                        return DropdownMenuItem(
                          value: mod,
                          child: Text(mod.nomModule),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedModule = value;
                        });
                      },
                      validator: (value) => value == null
                          ? "Veuillez sélectionner un module"
                          : null,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Text(
                              _selectedDate == null
                                  ? 'Sélectionnez une date'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Note de devoir (30%)"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          noteDevoir = double.tryParse(value)!;
                        });
                      },
                      validator: (value) {
                        double? val = double.tryParse(value!);
                        if (val == null || val < 0 || val > 20) {
                          return "Entrez une note valide (0-20)";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // TextFormField(
                    //   decoration:
                    //       InputDecoration(labelText: "Note d'examen (70%)"),
                    //   keyboardType: TextInputType.number,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       noteExamen = double.tryParse(value);
                    //     });
                    //   },
                    //   validator: (value) {
                    //     double? val = double.tryParse(value!);
                    //     if (val == null || val < 0 || val > 20) {
                    //       return "Entrez une note valide (0-20)";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text("Ajouter la Note"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
