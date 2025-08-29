import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/gestion_des_admissions.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/detail_prinscrit.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/inscription_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListInscriptions extends StatefulWidget {
  const ListInscriptions({super.key});

  @override
  State<ListInscriptions> createState() => _ListInscriptionsState();
}

class _ListInscriptionsState extends State<ListInscriptions> {
  late Future<List<Inscription>> futureInscriptions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureInscriptions = InscriptionService().getAllInscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GestionDesAdmissions(),
              ));
        },
      ),
      backgroundColor: Colors.grey.shade200,
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
              child: Column(
            children: [
              MyAppbar(
                title: "Listes des Inscriptions",
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FutureBuilder<List<Inscription>>(
                    future: futureInscriptions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print("Erreur : ${snapshot.error}");
                        return Center(
                          child: Text(
                            "Erreur : ${snapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Aucun étudiant trouvé",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      } else {
                        List<Inscription> items = snapshot.data!;

                        return Column(
                          children: [
                            // En-tête du tableau
                            buildTableHeader(),
                            const Divider(height: 1), // Ligne de séparation

                            // Liste des lignes de données
                            Expanded(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final inscription = items[index];
                                  return InscriptionTableRow(
                                    nomEtudiant:
                                        "${inscription.etudiant?.prenom} ${inscription.etudiant?.nom}",
                                    nomFiliere: inscription.filiere!.nomFiliere,
                                    nomNiveau: inscription.niveau!.nomNiveau,
                                    onEdit: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailEtudiant(
                                              etudiant: inscription.etudiant!),
                                        ),
                                      );
                                      // Rafraîchir la liste après modification
                                      futureInscriptions = InscriptionService()
                                          .getAllInscriptions();
                                    },
                                    onDelete: () =>
                                        _confirmDelete(inscription.id!),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  // Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "Êtes-vous sûr de vouloir supprimer cette Inscription ?"),
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
                InscriptionService().deleteInscription(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureInscriptions =
                        InscriptionService().getAllInscriptions();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Inscription supprimée avec succès"),
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

  Widget buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: Text("Étudiant",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Filière",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text("Niveau",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text("Actions",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
