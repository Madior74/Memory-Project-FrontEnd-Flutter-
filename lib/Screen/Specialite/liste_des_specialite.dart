import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';

import 'package:school_management_system/Screen/Specialite/specialiteService.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListeDesSpecialite extends StatefulWidget {
  const ListeDesSpecialite({
    super.key,
  });

  @override
  State<ListeDesSpecialite> createState() => _ListeDesSpecialiteState();
}

class _ListeDesSpecialiteState extends State<ListeDesSpecialite> {
  late Future<List<Specialite>> futureSpecialites;
  String? selectedNivel;
  final _formKey = GlobalKey<FormState>();
  final _nomSpecialiteController = TextEditingController();
  final _descriptionSpecialiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureSpecialites = SpecialiteService().getAllSpecialites();
  }

  // Acronyme
  String getAcronym(String fullName) {
    List<String> words =
        fullName.split(' '); // Diviser la chaîne par des espaces

    // Filtrer les mots pour prendre en compte les chiffres
    List<String> filteredWords = words.where((word) {
      // Inclure les mots de longueur > 2 ou les chiffres
      return word.length > 2 || RegExp(r'^\d+$').hasMatch(word);
    }).toList();

    String acronym = '';

    // Assurer qu'il y a au moins deux mots valides pour former l'acronyme
    if (filteredWords.isNotEmpty) {
      for (String word in filteredWords) {
        // Prendre la première lettre ou le chiffre entier
        acronym += (word.length > 2) ? word[0] : word;
      }
    }

    return acronym.toUpperCase(); // Convertir en majuscules
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDialog();
          _nomSpecialiteController.clear();
          _descriptionSpecialiteController.clear();
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "  Liste des Specialites ",
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Specialite>>(
                    future: futureSpecialites,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Erreur: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Aucune Specialite trouvée"),
                        );
                      } else {
                        List<Specialite> items = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 35.0,
                            mainAxisSpacing: 35.0,
                            childAspectRatio: 1,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final sepci = items[index];

                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         SemestreByNiveau(niveau: niveau),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  elevation: 1,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double fontSize =
                                          constraints.maxHeight / 4;

                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      size: 25,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    _confirmDelete(
                                                        items[index].id!);
                                                  },
                                                ),
                                              ],
                                            ),
                                            // Acronyme
                                            Text(
                                              getAcronym(sepci.nom!),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    fontSize, // Utiliser la taille calculée
                                                height:
                                                    1, // Ajustez la hauteur de ligne si nécessaire
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2.0),
                                                  child: Text(
                                                    utf8.decode(
                                                        sepci.nom!.codeUnits),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
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
        return AlertDialog(
          title: const Text("Nouvelle Spécialité"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300, // Définissez une largeur maximale
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    TextFormField(
                      controller: _nomSpecialiteController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.psychology),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        labelText: "Spécialité",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer la Spécialité";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionSpecialiteController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        labelText: "Description",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer la description";
                        }
                        return null;
                      },
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
                if (_formKey.currentState!.validate()) {
                  final Specialite specialite = Specialite(
                    nom: _nomSpecialiteController.text,
                    description: _descriptionSpecialiteController.text,
                  );
                  saveSpecialite(specialite);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveSpecialite(Specialite specialite) async {
    try {
      bool exists = await SpecialiteService().specialiteExist(specialite.nom!);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Une Specialité existe déjà avec ce nom."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await SpecialiteService().addSpecialite(specialite);

      setState(() {
        futureSpecialites = SpecialiteService().getAllSpecialites();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Niveau ajouté avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'ajout : $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "Êtes-vous sûr de vouloir supprimer cette Specialité ?"),
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
                SpecialiteService().deleteSpecialite(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureSpecialites = SpecialiteService().getAllSpecialites();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Niveau supprimé avec succès"),
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
