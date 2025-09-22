import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';
import 'package:school_management_system/Screen/Region/Departements/liste_des_departements.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/prinscription_service.dart';
import 'package:school_management_system/Screen/Region/regionService.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListeDesRegions extends StatefulWidget {
  const ListeDesRegions({super.key});

  @override
  _ListeDesRegionsState createState() => _ListeDesRegionsState();
}

class _ListeDesRegionsState extends State<ListeDesRegions> {
  late Future<List<Region>> futureRegions;
  bool isLoading = false;

  final TextEditingController _nomRegionController = TextEditingController();
  //Recuperation de la liste des Etudiants
  late Future<int> count;

  @override
  void initState() {
    super.initState();
    futureRegions = RegionService().getRegion();
  }

  Future<int> getEtudiantsCountByRegionId(int RegionId) async {
    return await PrinscriptionService().getEtudiantsCountByFiliereId(RegionId);
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
        
        onPressed: () {
          addDialog();
          _nomRegionController.clear();
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyAppbar(
                  title: "Listes des Regions",
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FutureBuilder<List<Region>>(
                      future: futureRegions,
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
                              "Aucune region trouvée",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        } else {
                          List<Region> items = snapshot.data!;
                          return GridView.builder(
                            padding: const EdgeInsets.all(30),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  250, // Largeur max d'une carte
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 25,
                              childAspectRatio: 1,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final region = items[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ListeDesDepartements(region: region),
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
                                              getAcronym(region.nomRegion),
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              region.nomRegion,
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
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Réduit la taille au minimum
                      children: [
                        TextFormField(
                          controller: _nomRegionController,
                          decoration: InputDecoration(
                              labelText: 'Nom de la Region',
                              prefixIcon:
                                  const Icon(Icons.location_city_rounded),
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
                          String regionName = _nomRegionController.text;
                          if (regionName.isNotEmpty) {
                            saveRegion(regionName).then((_) {
                              Navigator.pop(context);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Veuillez entrer un nom de Region")),
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

  // Dans ListeDesRegions.dart

  Future<void> saveRegion(String regionName) async {
    try {
      setState(() {
        isLoading = true;
      });
      // Vérification si la Region existe déjà
      bool exists = await RegionService().regionExists(regionName);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Une Region avec ce nom existe déjà"),
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      Region nouveauRegion = Region(nomRegion: regionName);
      print(nouveauRegion);
      await RegionService().createRegion(nouveauRegion);

      if (mounted) {
        setState(() {
          futureRegions = RegionService().getRegion();
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Region ajoutée avec succès",
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
      print('Echec lors de l\'ajout  de la Region : $error');
    }
  }

  //Supprimer une Region

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette Region ?"),
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
                RegionService().deleteRegion(id).then((_) {
                  // Rafraîchir la liste des Regions
                  setState(() {
                    futureRegions = RegionService().getRegion();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Region supprimée avec succès"),
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
