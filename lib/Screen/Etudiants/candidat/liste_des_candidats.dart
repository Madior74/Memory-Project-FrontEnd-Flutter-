import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription_dto.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/detail_prinscrit.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/nouveau_candidat.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/prinscription_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_management_system/Widgets/prinscription_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class ListeDesCandidats extends StatefulWidget {
  const ListeDesCandidats({super.key});

  @override
  State<ListeDesCandidats> createState() => _ListeDesCandidatsState();
}

class _ListeDesCandidatsState extends State<ListeDesCandidats> {
  late Future<List<Candidat>> futuresEtudiants;

  List<InscriptionDTO> _etudiant = [];

  //initiale
  String getInitials(String name) {
    var parts = name.split(' ');
    return parts.length > 1 ? '${parts[0][0]}${parts[1][0]}' : parts[0][0];
  }

  Future<void> fetchEtudiants() async {
    try {
      final dejaInscrit = await InscriptionService().getAllInscriptions();
      setState(() {
        _etudiant = dejaInscrit.cast<InscriptionDTO>();
        print("Etudiants prinscrit");
        print(_etudiant.toList());
      });
    } catch (e) {
      setState(() {
        throw Exception("Erreur lors du chargement des étudiants admis : $e");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEtudiants();
    futuresEtudiants = PrinscriptionService().getAllEtudiant();
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NouvellePriscription(),
              ));
        },
      ),
      backgroundColor: myBackgroound,
      // appBar: MyAppbar(title: "Liste des Etudiants"),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Etudiants Prinscrits",
                ),
                Expanded(
                    child: FutureBuilder(
                  future: futuresEtudiants,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Erreur :${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/sorry.svg"),
                          const Text(
                            "Aucun Candiddat Trouvé",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ));
                    } else {
                      List<Candidat> prinscrits = snapshot.data!;
                      // Filtrer les candidats en retirant ceux déjà inscrits
                      final filteredCandidats = prinscrits.where((candidat) {
                        return !_etudiant.any((et) =>
                            et.dossierAdmissionDto?.candidat?.id ==
                            candidat.id);
                      }).toList();

                      if (filteredCandidats.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/sorry.svg"),
                            const Text(
                              "Aucun Candiddat Trouvé",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text("Accronyme", style: titleStyle)),
                              DataColumn(
                                  label:
                                      Text("Etudiant(e)", style: titleStyle)),
                              DataColumn(
                                  label: Text("Filière", style: titleStyle)),
                              DataColumn(
                                  label: Text("Niveau", style: titleStyle)),
                              DataColumn(
                                  label: Text("Année Académique",
                                      style: titleStyle)),
                              DataColumn(
                                  label: Text("Documents", style: titleStyle)),
                              DataColumn(
                                  label: Text("Status Dossier",
                                      style: titleStyle)),
                              DataColumn(
                                  label: Text("Actions", style: titleStyle)),
                            ],
                            rows: filteredCandidats.map((prinscrit) {
                              //  Calcul du nombre de documents téléversés
                              int nbreDocuments =
                                  prinscrit.documents?.length ?? 0;

                              // Récupération du statut d'admission
                              String statutAdmission =
                                  "Incomplet"; // Par défaut

                              if (nbreDocuments == 3) {
                                statutAdmission = "complet";
                              } else {
                                statutAdmission = "Incomplet";
                              }
                              final String etudiant =
                                  '${prinscrit.prenom} ${prinscrit.nom}';
                              return DataRow(
                                cells: [
                                  DataCell(CircleAvatar(
                                    backgroundColor: Colors.indigo[400],
                                    child: Text(
                                      getInitials(etudiant).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                  DataCell(Text(etudiant)),
                                  DataCell(Text(
                                      prinscrit.filiereSouhaitee?.nomFiliere ??
                                          "N/A")),
                                  DataCell(Text(
                                      (prinscrit.niveauSouhaite?.nomNiveau) ??
                                          "N/A")),
                                  DataCell(Text(
                                      (prinscrit.anneeAcademique?.nomAnnee) ??
                                          "N/A")),
                                  DataCell(Text(
                                    nbreDocuments.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _getNumberColor(nbreDocuments)),
                                  )),
                                  DataCell(Text(
                                    statutAdmission,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _getStatusColor(statutAdmission)),
                                  )),
                                  DataCell(
                                    Row(
                                      children: [
                                        TextButton.icon(
                                          icon: Icon(Icons.visibility,
                                              color: Colors.blue),
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailEtudiant(
                                                        etudiant: prinscrit),
                                              ),
                                            );
                                          },
                                          label: Text("Détail"),
                                        ),
                                        TextButton.icon(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _confirmerSuppression(
                                                  prinscrit.id!),
                                          label: Text("Supprimer"),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Supprimer un Etudiant

  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Voulez-vous Vraiment supprimer cet Etudiant ?"),
          actions: [
            const ButtonAnnuler(),
            TextButton(
                onPressed: () {
                  PrinscriptionService().deleteEtudiant(id).then((_) {
                    setState(
                      () {
                        futuresEtudiants =
                            PrinscriptionService().getAllEtudiant();
                      },
                    );

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Etudiant supprimé avec Succès",
                          style: TextStyle(color: Colors.white),
                        )));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Erreur : $error")),
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Supprimer"))
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "incomplet":
        return Colors.red;
      case "complet":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Color _getNumberColor(int nbDoc) {
    return nbDoc < 3 ? Colors.red : Colors.green;
  }
}
