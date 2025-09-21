import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_by_filiere.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Screen/Filieres/filiere_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListFilieres extends StatefulWidget {
  const ListFilieres({super.key});

  @override
  _ListFilieresState createState() => _ListFilieresState();
}

class _ListFilieresState extends State<ListFilieres> {
  late Future<List<Filiere>> futureFilieres;

  final TextEditingController _nomFiliereController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //Recuperation de la liste des Etudiants
  late Future<List<Candidat>> etudiants;
  late Future<int> count;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureFilieres = FiliereService().getFilieres();
  }

  Future<int> getEtudiantsCountByFiliereId(int filiereId) async {
    return await FiliereService().getEtudiantsCountByFiliereId(filiereId);
  }
  //Acronyme

  String getAcronym(String fullName) {
    List<String> words = fullName.split(' ');

    List<String> filteredWords = words.where((word) {
      return word.length > 2; // Ignore words like "de", "et", "le", etc.
    }).toList();

    String acronym = '';

    if (filteredWords.length > 1) {
      acronym = filteredWords[0][0] + filteredWords[1][0];
    } else if (filteredWords.isNotEmpty) {
      acronym = filteredWords[0][0];
    }

    return acronym.toUpperCase(); // Convert to uppercase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: myDrawerColol,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          addDialog();
          _nomFiliereController.clear();
        },
      ),
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyAppbar(
                  title: "Listes des Filieres",
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FutureBuilder<List<Filiere>>(
                      future: futureFilieres,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Erreur : ${snapshot.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "Aucune filière trouvée",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        } else {
                          List<Filiere> items = snapshot.data!;
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width *
                                              0.3, // Largeur max d'une carte
                                      mainAxisSpacing: 25,
                                      crossAxisSpacing: 25,
                                      childAspectRatio: 1,
                                      mainAxisExtent: 200),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final filiere = items[index];
                                return FutureBuilder<int>(
                                  future:
                                      getEtudiantsCountByFiliereId(filiere.id!),
                                  builder: (context, countSnapshot) {
                                    int nombreEtudiants =
                                        countSnapshot.data ?? 0;
                                    return FiliereCard(
                                      niveauTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ListesNiveaux(
                                                      filiere: filiere),
                                            ));
                                      },
                                      supprimeTap: () =>
                                          _confirmDelete(filiere.id!),
                                      accronyme: getAcronym(filiere.nomFiliere),
                                      nomFiliere: utf8
                                          .decode(filiere.nomFiliere.codeUnits),
                                      nobreEtudiant: nombreEtudiants,
                                      nbredeModule: 0,
                                    );
                                  },
                                );
                              });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Nouvelle Filière"),
              content: SingleChildScrollView(
                // Permet le défilement si nécessaire
                child: SizedBox(
                  width: 300, // Définissez une largeur maximale
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Réduit la taille au minimum
                      children: [
                        TextFormField(
                          controller: _nomFiliereController,
                          decoration: InputDecoration(
                              labelText: 'Nom de la Filière',
                              prefixIcon: const Icon(Icons.bookmarks),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Le champ ne doit pas etre vide";
                            }
                            return null;
                          },
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        //Description

                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              labelText: 'Description de la Filière',
                              prefixIcon: const Icon(Icons.chat),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Annuler",
                    style: TextStyle(color: myredColor),
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Filiere nouveauFiliere = Filiere(
                              nomFiliere: _nomFiliereController.text,
                              description: _descriptionController.text);
                          if (_formKey.currentState!.validate()) {
                            saveFiliere(nouveauFiliere).then((_) {
                              Navigator.pop(context);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Veuillez entrer un nom de Filiere")),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Ajouter'), 
                ),
              ],
            );
          },
        );
      },
    );
  }

  //SaveFiliere

  Future<void> saveFiliere(Filiere filiere) async {
    try {
      setState(() {
        isLoading = true;
      });
      // Vérification si la filière existe déjà
      bool exists = await FiliereService().filiereExists(filiere.nomFiliere);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Une filière avec ce nom existe déjà"),
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FiliereService().createFiliere(filiere);

      if (mounted) {
        setState(() {
          futureFilieres = FiliereService().getFilieres();
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Filière ajoutée avec succès",
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Erreur lors de l'ajout : $error",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
      print('Echec lors de l\'ajout de la Filiere : $error');
    }
  }
  //Supprimer une Filiere

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // 👈 Use distinct name to avoid confusion
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette Filière ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Keep dialog open during deletion
                try {
                  await FiliereService().deleteFiliere(id);

                  // Only proceed if widget is still alive
                  if (!mounted) return;

                  // Refresh list
                  setState(() {
                    futureFilieres = FiliereService().getFilieres();
                  });

                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Filière supprimée avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erreur lors de la suppression : $error"),
                      ),
                    );
                  }
                } finally {
                  // Always close dialog after operation (success or error)
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
              },
              child: Text(
                'Supprimer',
                style: TextStyle(color: myredColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
