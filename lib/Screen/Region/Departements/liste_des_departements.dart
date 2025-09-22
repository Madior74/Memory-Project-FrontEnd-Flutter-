import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';
import 'package:school_management_system/Screen/Region/Departements/departementService.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListeDesDepartements extends StatefulWidget {
  final Region region;

  const ListeDesDepartements({super.key, required this.region});

  @override
  State<ListeDesDepartements> createState() => _ListeDesDepartementsState();
}

class _ListeDesDepartementsState extends State<ListeDesDepartements> {
  late Future<List<Departement>> futureDepartement;
  final _nomDepartementController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureDepartement =
        DepartementService().getDepartementByRegion(widget.region.id!);
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
    print(widget.region.nomRegion);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: myredColor,
        onPressed: () {
          addDialog();
          _nomDepartementController.clear();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Liste des Departements de ${widget.region.nomRegion}",
                ),
                Expanded(
                  child: FutureBuilder<List<Departement>>(
                    future: futureDepartement,
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
                          child: Text("Aucun Departement trouvé"),
                        );
                      } else {
                        List<Departement> items = snapshot.data!;
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
                            final dep = items[index];

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
                                              getAcronym(dep.nomDepartement),
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
                                                    dep.nomDepartement,
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
          title: const Text("Nouveau Departement"),
          content: SingleChildScrollView(
            // Permet le défilement si nécessaire
            child: SizedBox(
              width: 300, // Définissez une largeur maximale
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    // Choix du profil
                    TextFormField(
                      controller: _nomDepartementController,
                      decoration: InputDecoration(
                          labelText: 'Nom du Departement',
                          hintText: 'Entrez le nom du Departement',
                          prefixIcon: const Icon(Icons.home),
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
                      String nomdep = _nomDepartementController.text;
                      if (nomdep.isNotEmpty) {
                        saveDepartement(nomdep).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Veuillez entrer un nom de departement")),
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
  }

  Future<void> saveDepartement(String dpm) async {
    if (widget.region.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur : L'ID de la region est manquant."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      bool exists =
          await DepartementService().departementExist(dpm, widget.region.id!);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Un Departement avec ce nom existe déjà dans cette Region."),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      await DepartementService().addDepartementToRegion(widget.region.id!, dpm);

      if (mounted) {
        setState(() {
          futureDepartement =
              DepartementService().getDepartementByRegion(widget.region.id!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Département ajouté avec succès."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'ajout : $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce Departement ?"),
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
                DepartementService().deleteDepartement(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureDepartement = DepartementService()
                        .getDepartementByRegion(widget.region.id!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Departement supprimé avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : $error")),
                  );
                });
                Navigator.of(context).pop();
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
