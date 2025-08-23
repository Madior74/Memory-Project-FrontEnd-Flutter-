import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/semestre/semestres_by_niveau.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';
import 'package:school_management_system/Widgets/back_bouton.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListesNiveaux extends StatefulWidget {
  final Filiere filiere; // Recevez l'objet Filiere

  const ListesNiveaux({super.key, required this.filiere});

  @override
  State<ListesNiveaux> createState() => _ListesNiveauxState();
}

class _ListesNiveauxState extends State<ListesNiveaux> {
  late Future<List<Niveau>> futureNiveau;
  String? selectedNivel;

  final List<String> nivels = [
    'Licence 1',
    'Licence 2',
    'Licence 3',
    'Master 1',
    'Master 2'
  ];

  @override
  void initState() {
    super.initState();
    futureNiveau = NiveauService().getNiveauxByFiliere(widget.filiere.id!);
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
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "${widget.filiere.nomFiliere} Liste des Niveaux",
                ),
                Expanded(
                  child: FutureBuilder<List<Niveau>>(
                    future: futureNiveau,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Erreur: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Aucun niveau trouvé"));
                      } else {
                        List<Niveau> items = snapshot.data!;
                        return GridView.builder(
                          padding: const EdgeInsets.all(30),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250, // Largeur max d'une carte
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                            childAspectRatio: 1,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final niveau = items[index];

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SemestreByNiveau(niveau: niveau),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double fontSize =
                                          constraints.maxHeight / 5;

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    size: 24,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  _confirmDelete(
                                                      items[index].id!);
                                                },
                                              ),
                                            ],
                                          ),
                                          Text(
                                            getAcronym(
                                                widget.filiere.nomFiliere +
                                                    niveau.nomNiveau),
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            niveau.nomNiveau,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
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
          title: const Text("Nouveau Niveau"),
          content: SingleChildScrollView(
            // Permet le défilement si nécessaire
            child: SizedBox(
              width: 300, // Définissez une largeur maximale
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    // Choix du niveau
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Niveau",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      items: nivels.map((String profil) {
                        return DropdownMenuItem(
                          value: profil,
                          child: Text(profil),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedNivel = value;
                        });
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
                if (selectedNivel != null && selectedNivel!.isNotEmpty) {
                  saveNiveau(selectedNivel!).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Veuillez sélectionner un niveau"),
                    ),
                  );
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveNiveau(String niveauName) async {
    if (widget.filiere.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur : L'ID de la filière est manquant."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      bool exists =
          await NiveauService().niveauExist(niveauName, widget.filiere.id!);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Un niveau avec ce nom existe déjà dans cette filière."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await NiveauService().addNiveauToFiliere(widget.filiere.id!, niveauName);

      setState(() {
        futureNiveau = NiveauService().getNiveauxByFiliere(widget.filiere.id!);
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
          content: const Text("Êtes-vous sûr de vouloir supprimer ce niveau ?"),
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
                NiveauService().deleteNiveau(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureNiveau =
                        NiveauService().getNiveauxByFiliere(widget.filiere.id!);
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
