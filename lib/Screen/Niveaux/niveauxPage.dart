import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Provider/filiereProvider.dart';
import 'package:school_management_system/Screen/Niveaux/niveauxProvider.dart';
import 'package:school_management_system/Screen/semestre/semestres_by_niveau.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';

class NiveauxPage extends ConsumerWidget {
  final int filiereId;

  const NiveauxPage({required this.filiereId, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoutez le provider pour récupérer les niveaux
    final niveauxAsync = ref.watch(niveauxProvider(filiereId));

    // Écoutez le provider pour récupérer la filière
    final filiereAsync = ref.watch(filiereProvider(filiereId));

    // Utilisez le nom de la filière récupéré depuis filiereAsync
    final filiereName = filiereAsync.value?.nomFiliere ?? "Inconnu";

    return Scaffold(
      body: Row(
        children: [
          //Drawer
          MyDrawer(),
          Expanded(
            child: Column(
              //AppBar

              children: [
                MyAppbar(
                    title: " ${filiereName} Liste des Niveaux ",
                    onTap: () {
                      // addDialog();
                    },
                    boutonName: "Nouveau Niveau"),
                Expanded(
                  child: niveauxAsync.when(
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        Center(child: Text("Erreur : $error")),
                    data: (items) {
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
                                    double fontSize = constraints.maxHeight / 5;

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
                                                  size: 24, color: Colors.red),
                                              onPressed: () {
                                                // _confirmDelete(items[index].id!);
                                              },
                                            ),
                                          ],
                                        ),
                                        Text(
                                          getAcronym(
                                              filiereName + niveau.nomNiveau),
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
}
