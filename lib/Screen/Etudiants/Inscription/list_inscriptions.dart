import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/gestion_des_admissions.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription_dto.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';

import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class ListInscriptions extends StatefulWidget {
  const ListInscriptions({super.key});

  @override
  State<ListInscriptions> createState() => _ListInscriptionsState();
}

class _ListInscriptionsState extends State<ListInscriptions> {
  late Future<List<InscriptionDTO>> futureInscriptions;
  late Future<List<Filiere>> futureFilieres;
  late Future<List<Niveau>> futureNiveaux;
  late Future<List<AnneeAcademique>> futureAnnees;

  @override
  void initState() {
    super.initState();
    futureInscriptions = InscriptionService().getAllInscriptions();
    futureFilieres = FiliereService().getFilieres();
    futureNiveaux = NiveauService().getNiveaux();
    futureAnnees = AnneeAcademiqueService().getSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Card(
        color: Colors.white,
        child: Row(
          children: [
            MyDrawer(),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20),
                        child: Text(
                          "Listes des Inscriptions",
                          style: firstTitleStyle,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: FutureBuilder<List<InscriptionDTO>>(
                        future: futureInscriptions,
                        builder: (context, inscriptionSnapshot) {
                          if (inscriptionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (inscriptionSnapshot.hasError) {
                            return Center(
                              child: Text(
                                  "Erreur : ${inscriptionSnapshot.error}",
                                  style: const TextStyle(color: Colors.red)),
                            );
                          } else if (!inscriptionSnapshot.hasData ||
                              inscriptionSnapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("Aucun étudiant trouvé",
                                    style: TextStyle(color: Colors.grey)));
                          } else {
                            return FutureBuilder<List<Filiere>>(
                              future: futureFilieres,
                              builder: (context, filiereSnapshot) {
                                return FutureBuilder<List<Niveau>>(
                                  future: futureNiveaux,
                                  builder: (context, niveauSnapshot) {
                                    return FutureBuilder<List<AnneeAcademique>>(
                                      future: futureAnnees,
                                      builder: (context, anneeSnapshot) {
                                        // Check if all data is loaded
                                        if (filiereSnapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            niveauSnapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            anneeSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        if (filiereSnapshot.hasError ||
                                            niveauSnapshot.hasError ||
                                            anneeSnapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                "Erreur de chargement des données",
                                                style: const TextStyle(
                                                    color: Colors.red)),
                                          );
                                        }

                                        final List<InscriptionDTO>
                                            inscriptions =
                                            inscriptionSnapshot.data!;
                                        final List<Filiere> filieres =
                                            filiereSnapshot.data ?? [];
                                        final List<Niveau> niveaux =
                                            niveauSnapshot.data ?? [];
                                        final List<AnneeAcademique> annees =
                                            anneeSnapshot.data ?? [];

                                        Filiere? getFiliereById(int id) {
                                          try {
                                            return filieres
                                                .firstWhere((f) => f.id == id);
                                          } catch (e) {
                                            return null;
                                          }
                                        }

                                        Niveau? getNiveauById(int id) {
                                          try {
                                            return niveaux
                                                .firstWhere((n) => n.id == id);
                                          } catch (e) {
                                            return null;
                                          }
                                        }

                                        AnneeAcademique? getAnneeById(int id) {
                                          try {
                                            return annees.firstWhere(
                                                (an) => an.id == id);
                                          } catch (e) {
                                            return null;
                                          }
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: DataTable(
                                              columns: [
                                                DataColumn(
                                                    label: Text("Etudiant(e)",
                                                        style: titleStyle)),
                                                DataColumn(
                                                    label: Text("Filière",
                                                        style: titleStyle)),
                                                DataColumn(
                                                    label: Text("Niveau",
                                                        style: titleStyle)),
                                                DataColumn(
                                                    label: Text(
                                                        "Année Académique",
                                                        style: titleStyle)),
                                                DataColumn(
                                                    label: Text("Actions",
                                                        style: titleStyle)),
                                              ],
                                              rows: inscriptions
                                                  .map((inscription) {
                                                final String etudiant =
                                                    '${inscription.dossierAdmissionDTO.candidat.prenom} ${inscription.dossierAdmissionDTO.candidat.nom}';
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text(etudiant)),
                                                    DataCell(Text(getFiliereById(
                                                                inscription
                                                                    .filiereId)
                                                            ?.nomFiliere ??
                                                        "N/A")),
                                                    DataCell(Text(getNiveauById(
                                                                inscription
                                                                    .niveauId)
                                                            ?.nomNiveau ??
                                                        "N/A")),
                                                    DataCell(Text(getAnneeById(
                                                                inscription
                                                                    .anneeAcademiqueId)
                                                            ?.nomAnnee ??
                                                        "N/A")),
                                                    DataCell(
                                                      TextButton.icon(
                                                        icon: Icon(Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () =>
                                                            _confirmDelete(
                                                                inscription
                                                                    .id!),
                                                        label:
                                                            Text("Supprimer"),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
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
}
