import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Professeurs/detail_professeur.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Professeurs/nouveau_professeur.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/Screen/Professeurs/professeur_card.dart';

class ListeDesProfesseurs extends StatefulWidget {
  const ListeDesProfesseurs({super.key});

  @override
  State<ListeDesProfesseurs> createState() => _ListeDesProfesseursState();
}

class _ListeDesProfesseursState extends State<ListeDesProfesseurs> {
  late Future<List<Professeur>> futurProfesseurs;

  @override
  void initState() {
    super.initState();
    futurProfesseurs = ProfesseurService().fetchprofesseurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NouveauProfesseur(),
              ));
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Professeurs",
                ),
                Expanded(
                  child: FutureBuilder<List<Professeur>>(
                    future: futurProfesseurs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("Erreur : ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/sorry.svg"),
                              const Text(
                                "Aucun professeur trouvé",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        );
                      } else {
                        List<Professeur> items = snapshot.data!;
                        //la taille de l'écran
                        double screenWidth = MediaQuery.of(context).size.width;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: screenWidth *
                                      0.35 // Largeur max d'une carte
                                  , // Largeur max d'une carte
                                  mainAxisSpacing: 25,
                                  crossAxisSpacing: 25,
                                  childAspectRatio: 1,
                                  mainAxisExtent: 251),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final prof = items[index];
                            String statutProf;
                            if (prof.status == null) {
                              statutProf = "Vacataire";
                            } else {
                              statutProf = prof.status;
                            }

                            return ProfesseurCard(
                              onDelete: () {
                                _confirmerSuppression(prof.id!);
                              },
                              adresse: prof.adresse,
                              departement: prof.departement!.nomDepartement,
                              email: prof.email,
                              prenomEtNom: "${prof.prenom} ${prof.nom}",
                              status: statutProf,
                              detail: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfesseurDetails(
                                            professeur: prof)));

                                // Recharger les données du professeur depuis le backend après retour
                                final updatedProf = await ProfesseurService()
                                    .getSpecialitesByProfesseurId(prof.id!);
                                setState(() {
                                  futurProfesseurs =
                                      ProfesseurService().fetchprofesseurs();
                                });
                              },
                              region: prof.region!,
                              specialites: prof.specialites,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Supprimer un professeur

  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              const Text("Voulez-vous Vraiment supprimer cet professeur ??"),
          actions: [
            const ButtonAnnuler(),
            TextButton(
                onPressed: () {
                  ProfesseurService().deleteProfesseur(id).then((_) {
                    setState(
                      () {
                        futurProfesseurs =
                            ProfesseurService().fetchprofesseurs();
                      },
                    );

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "professeur supprimé avec Succès",
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
