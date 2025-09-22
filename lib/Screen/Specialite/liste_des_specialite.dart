import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';

import 'package:school_management_system/Screen/Specialite/specialiteService.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureSpecialites = SpecialiteService().getAllSpecialites();
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
          _openDialog();
        },
      ),
      body: Row(
        children: [
          const MyDrawer(),
          Expanded(
            child: Column(
              children: [
                const MyAppbar(
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
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final speci = items[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    speci.nom ?? "Nom introuvable",
                                    style: valueStyle,
                                  ),
                                  subtitle: Text(speci.description ??
                                      "Aucune description"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              _openDialog(specialite: speci),
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          onPressed: () =>
                                              _confirmDelete(speci.id!),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
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

  void _openDialog({Specialite? specialite}) {
    bool isEditMode = specialite != null;
    int? specialiteId = specialite?.id;

    final nomController = TextEditingController(text: specialite?.nom ?? '');
    final descriptionController =
        TextEditingController(text: specialite?.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditMode
              ? "Mettre à jour la spécialité"
              : "Nouvelle Spécialité"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300, // Définissez une largeur maximale
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    TextFormField(
                      controller: nomController,
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
                      controller: descriptionController,
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
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        final Specialite specialite = Specialite(
                          nom: nomController.text,
                          description: descriptionController.text,
                        );

                        if (isEditMode) {
                          updateSpecialite(specialiteId!, specialite).then((_) {
                            Navigator.of(context).pop();
                          });
                        } else {
                          saveSpecialite(specialite).then((_) {
                            Navigator.of(context).pop();
                          });
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text(isEditMode ? "Mettre à jour" : "Ajouter"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveSpecialite(Specialite specialite) async {
    try {
      setState(() {
        isLoading = true;
      });
      bool exists = await SpecialiteService().specialiteExist(specialite.nom!);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Une Specialité existe déjà avec ce nom."),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      await SpecialiteService().addSpecialite(specialite);

      if (mounted) {
        setState(() {
          futureSpecialites = SpecialiteService().getAllSpecialites();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Spécialité ajoutée avec succès."),
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

  //Mettre a jour
  Future<void> updateSpecialite(int specialiteId, Specialite speci) async {
    try {
      await SpecialiteService().updateSpecialite(specialiteId, speci);

      setState(() {
        futureSpecialites = SpecialiteService().getAllSpecialites();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Spécialité mis à jour avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (e) {
      throw Exception("Erreur lors de la mise a jour de la spécialité $e");
    }
  }
}
