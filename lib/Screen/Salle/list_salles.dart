import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Salle/model_salle.dart';
import 'package:school_management_system/Screen/Salle/salle_service.dart';

import 'package:school_management_system/Screen/Specialite/specialiteService.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class ListSalles extends StatefulWidget {
  const ListSalles({
    super.key,
  });

  @override
  State<ListSalles> createState() => _ListSallesState();
}

class _ListSallesState extends State<ListSalles> {
  late Future<List<Salle>> futureSalles;
  String? selectedNivel;
  final _formKey = GlobalKey<FormState>();
  final List<String> listEquipements = ["Aucune", "Télévision", "Projecteur"];

  String? selectedEquipement;
  @override
  void initState() {
    super.initState();
    futureSalles = SalleService().getAllSalles();
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
                  title: "  Liste des Salles ",
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Salle>>(
                    future: futureSalles,
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
                          child: Text("Aucune Salle trouvée"),
                        );
                      } else {
                        List<Salle> salles = snapshot.data!;
                        return DataTable(
                          columns: [
                            DataColumn(label: Text("Salle", style: titleStyle)),
                            DataColumn(
                                label: Text("Equipements", style: titleStyle)),
                            DataColumn(
                                label: Text("Actions", style: titleStyle)),
                          ],
                          rows: salles.map((salle) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                    salle.nomSalle ?? "Sallle Non Définie")),
                                DataCell(Text(
                                    salle.equipements ?? "Aucun équipement")),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(salle.id!),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
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

  void _openDialog({Salle? salle}) {
    bool isEditMode = salle != null;
    int? salleId = salle?.id;

    final nomController = TextEditingController(text: salle?.nomSalle ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditMode ? "Mettre à jour la salle" : "Nouvelle salle"),
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
                        labelText: "Salle",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer la Spécialité";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          hintText: "Equipement",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      value: selectedEquipement,
                      items: listEquipements
                          .map((equipement) => DropdownMenuItem(
                              value: equipement, child: Text(equipement)))
                          .toList(),
                      onChanged: (value) {
                        selectedEquipement = value;
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
                  final Salle nouvelleSalle = Salle(
                    nomSalle: nomController.text,
                    equipements: selectedEquipement,
                  );

                  if (isEditMode) {
                    updateSpecialite(salleId!, nouvelleSalle).then((_) {
                      Navigator.of(context).pop();
                    });
                  } else {
                    saveSalle(nouvelleSalle).then((_) {
                      Navigator.of(context).pop();
                    });
                  }
                }
              },
              child: Text(isEditMode ? "Mettre à jour" : "Ajouter"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveSalle(Salle salle) async {
    try {
      bool exists = await SalleService().salleExist(salle.nomSalle!);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Une Salle existe déjà avec ce nom."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await SalleService().addSpecialite(salle);

      setState(() {
        futureSalles = SalleService().getAllSalles();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salle ajoutée avec succès."),
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
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette Salle ?"),
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
                SalleService().deleteSalle(id).then((_) {
                  setState(() {
                    futureSalles = SalleService().getAllSalles();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Salle supprimé avec succès"),
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

  //Mettre a jour
  Future<void> updateSpecialite(int salleId, Salle salle) async {
    try {
      await SalleService().updateSpecialite(salleId, salle);

      setState(() {
        futureSalles = SalleService().getAllSalles();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Spécialité mis à jour avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (e) {
      throw Exception("Erreur lors de la mise a jour de la Salle $e");
    }
  }
}
