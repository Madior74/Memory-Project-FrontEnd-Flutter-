import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant_dto.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/prinscription_service.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/semestre/model_semestre.dart';
import 'package:school_management_system/Screen/UES/ue_by_semestre.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';
import 'package:school_management_system/Screen/semestre/semestre_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/Widgets/semestre_card.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class SemestreByNiveau extends StatefulWidget {
  final Niveau niveau;

  const SemestreByNiveau({super.key, required this.niveau});

  @override
  State<SemestreByNiveau> createState() => _SemestreByNiveauState();
}

class _SemestreByNiveauState extends State<SemestreByNiveau> {
  late Future<List<EtudiantDTO>> futureEtudiants;

  late Future<List<Semestre>> futureSemestres;
  // late Future<List<Etudiant>> futureEtudiants;
  String? selectedSemestre;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.niveau.id != null) {
      futureSemestres =
          SemestreService().getSemestreByNiveau(widget.niveau.id!);
    } else {
      futureSemestres = Future.error("ID du niveau est null");
    }

    futureEtudiants =
        InscriptionService().getEtudiantsByNiveauId(widget.niveau.id!);
  }

  final List<String> semestres = [
    'Semestre 1',
    'Semestre 2',
    'Semestre 3',
    'Semestre 4',
    'Semestre 5',
    'Semestre 6',
  ];
  //Recuperation des Etudiants de ce Niveau

  // Acronyme
  String getAcronym(String fullName) {
    List<String> words = fullName.split(' ');

    List<String> filteredWords = words.where((word) {
      return word.length > 2 || RegExp(r'^\d+$').hasMatch(word);
    }).toList();

    String acronym = '';

    if (filteredWords.isNotEmpty) {
      for (String word in filteredWords) {
        acronym += (word.length > 2) ? word[0] : word;
      }
    }

    return acronym.toUpperCase();
  }

  Future<void> saveSemestre(String nomSemestre) async {
    if (widget.niveau.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur : ID du niveau manquant."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      // Récupérer la filière associée au niveau
      Filiere? filiere =
          await NiveauService().getFiliereByNiveauId(widget.niveau.id!);

      if (filiere == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Erreur : La filière associée au niveau est manquante."),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Vérifier si le semestre existe déjà
      bool exists =
          await SemestreService().semestreExist(nomSemestre, widget.niveau.id!);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Un Semestre avec ce nom existe déjà."),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Ajouter le semestre au niveau avec la filière récupérée
      await SemestreService().addSemestreToNiveau(
        widget.niveau.id!,
        nomSemestre, // Passe la filière récupérée ici
      );

      if (mounted) {
        setState(() {
          futureSemestres =
              SemestreService().getSemestreByNiveau(widget.niveau.id!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Semestre ajouté avec succès."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSemestre();
        },
      ),
      backgroundColor: myBackgroound,
      body: Row(
        children: [
          //MyDrawer
          const MyDrawer(),
          Expanded(
              child: Column(children: [
            MyAppbar(
              title: "${widget.niveau.nomNiveau}  Liste des Semestres",
            ),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(8),
                        child: TabBar(
                          tabs: const [
                            Tab(
                              text: "Liste des Semestres ",
                            ),
                            Tab(
                              text: "Liste des Etudiants ",
                            )
                          ],
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: myDrawerColol,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Liste des Admissions
                            buildListeSemestres(context),
                            buildListesEtudiants(context)
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ])),
        ],
      ),
    );
  }

  Widget buildListeSemestres(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<List<Semestre>>(
          future: futureSemestres,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print("Erreur FutureBuilder: ${snapshot.error}");
              return Center(
                child: Text("Erreur: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Aucun Semestre trouvé"),
              );
            } else {
              List<Semestre> items = snapshot.data!;
              return Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 30.0,
                      mainAxisSpacing: 30.0,
                      childAspectRatio: 1,
                      mainAxisExtent: 360),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final semes = items[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: SemestreCard(
                          totalModules: semes.getTotalModules(),
                          ontapBouton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UeBySemestre(
                                  semestre: semes,
                                ),
                              ),
                            );
                          },
                          supprimeBouton: () {
                            _confirmDelete(items[index].id!);
                          },
                          title: '${semes.nomSemestre}',
                          nbreUE: semes.ues.length,
                          totalCredits: semes.getTotalCredits()),
                    );
                  },
                ),
              );
            }
          },
        )
      ],
    );
  }

  // //Liste des Etudiants
  Widget buildListesEtudiants(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ajouté pour éviter le conflit de hauteur
        children: [
          FutureBuilder<List<EtudiantDTO>>(
            future: futureEtudiants,
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
                List<EtudiantDTO> inscriptions = snapshot.data!;

                return SizedBox(
                  width: double.infinity,
                  child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text(
                          "Prénom",
                          style: titleStyle,
                        )),
                        DataColumn(
                            label: Text(
                          "Nom",
                          style: titleStyle,
                        )),
                        DataColumn(
                            label: Text(
                          "Email",
                          style: titleStyle,
                        )),
                        DataColumn(
                            label: Text(
                          "Actions",
                          style: titleStyle,
                        )),
                      ],
                      rows: inscriptions.map((inscription) {
                        final prenom =
                            inscription.dossierAdmissionDto?.candidat?.prenom;
                        final nom =
                            inscription.dossierAdmissionDto?.candidat?.nom;
                        final email =
                            inscription.dossierAdmissionDto?.candidat?.email;
                        return DataRow(cells: [
                          DataCell(Text(
                            prenom.toString(),
                          )),
                          DataCell(Text(
                            nom.toString(),
                          )),
                          DataCell(Text(
                            email.toString(),
                          )),
                          DataCell(TextButton.icon(
                              onPressed: () => _confirmDelete(inscription.id!),
                              label: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )))
                        ]);
                      }).toList()),
                );
              }
            },
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
          content: const Text("Voulez-vous Vraiment supprimer cet Etudiant ??"),
          actions: [
            const ButtonAnnuler(),
            TextButton(
                onPressed: () {
                  PrinscriptionService().deleteEtudiant(id).then((_) {
                    setState(
                      () {
                        futureEtudiants = InscriptionService()
                            .getEtudiantsByNiveauId(widget.niveau.id!);
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

  // Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce Semestre ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                SemestreService().deleteSemestre(id).then((_) {
                  setState(() {
                    futureSemestres = SemestreService()
                        .getSemestreByNiveau(widget.niveau.id!);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Semestre supprimé avec succès"),
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

  void addSemestre() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nouveau Semestre"),
          content: SingleChildScrollView(
            // Permet le défilement si nécessaire
            child: SizedBox(
              width: 300, // Définissez une largeur maximale
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    // Choix du profil
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Semestre",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      items: semestres.map((String profil) {
                        return DropdownMenuItem(
                          value: profil,
                          child: Text(profil),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSemestre = value;
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
              onPressed: isLoading
                  ? null
                  : () {
                      if (selectedSemestre != null && selectedSemestre!.isNotEmpty) {
                        saveSemestre(selectedSemestre!).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Veuillez sélectionner un Semestre"),
                          ),
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
  }
}
