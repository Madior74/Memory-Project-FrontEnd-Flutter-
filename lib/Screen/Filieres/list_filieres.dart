import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/list_niveau.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/filiere_caard.dart';
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
  late Future<List<CandidatPreInscrit>> etudiants;
  late Future<int> count;

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
                                    return FiliereCaard(
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
                  onPressed: () {
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
                            content: Text("Veuillez entrer un nom de Filiere")),
                      );
                    }
                  },
                  child: const Text('Ajouter'),
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
      // Vérification si la filière existe déjà
      bool exists = await FiliereService().filiereExists(filiere.nomFiliere);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Une filière avec ce nom existe déjà"),
          ),
        );
        return;
      }

      await FiliereService().createFiliere(filiere);

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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Erreur lors de l'ajout : $error",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
      print('Echec lors de l\'ajout  de la Filiere : $error');
    }
  }

  //Supprimer une Filiere

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette Filiere ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Appel à la méthode de suppression
                FiliereService().deleteFiliere(id).then((_) {
                  // Rafraîchir la liste des Filieres
                  setState(() {
                    futureFilieres = FiliereService().getFilieres();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Filiere supprimée avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : $error")),
                  );
                });
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
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
