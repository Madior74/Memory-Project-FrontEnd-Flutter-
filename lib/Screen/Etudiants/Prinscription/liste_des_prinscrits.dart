import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/detail_prinscrit.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/nouvelle_priscription.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_management_system/Widgets/prinscription_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListeDesPrinscrits extends StatefulWidget {
  const ListeDesPrinscrits({super.key});

  @override
  State<ListeDesPrinscrits> createState() => _ListeDesPrinscritsState();
}

class _ListeDesPrinscritsState extends State<ListeDesPrinscrits> {
  late Future<List<CandidatPreInscrit>> futuresEtudiants;

  @override
  void initState() {
    super.initState();
    futuresEtudiants = EtudiantService().getAllEtudiant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                            "Aucun Etudiant Trouvé",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ));
                    } else {
                      List<CandidatPreInscrit> items = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 450, mainAxisExtent: 250),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final etudiant = items[index];

                          // Calcul du nombre de documents téléversés
                          int nbreDocuments = etudiant.documents?.length ?? 0;

                          // Récupération du statut d'admission
                          String statutAdmission = "Incomplet"; // Par défaut

                          if (nbreDocuments == 3) {
                            statutAdmission = "complet";
                          } else {
                            statutAdmission = "Incomplet";
                          }

                          return PrinscriptionCard(
                              nomEudiant: '${etudiant.prenom} ${etudiant.nom}',
                              filiereSouhaitee:
                                  etudiant.filiereSouhaitee!.nomFiliere,
                              niveauSouhaitee:
                                  etudiant.niveauSouhaite!.nomNiveau,
                              statutAdmission: statutAdmission,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailEtudiant(etudiant: etudiant),
                                  ),
                                );
                                setState(() {
                                  futuresEtudiants =
                                      EtudiantService().getAllEtudiant();
                                });
                              },
                              onDelete: () =>
                                  _confirmerSuppression(etudiant.id!),
                              nbreDocument: nbreDocuments);
                        },
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
                  EtudiantService().deleteEtudiant(id).then((_) {
                    setState(
                      () {
                        futuresEtudiants = EtudiantService().getAllEtudiant();
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
}
