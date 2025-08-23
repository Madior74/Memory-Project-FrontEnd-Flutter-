import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_attente_card.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/nouvelle_inscriptions.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_service.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/dossier_admis_card.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class GestionDesAdmissions extends StatefulWidget {
  const GestionDesAdmissions({Key? key}) : super(key: key);

  @override
  _GestionDesAdmissionsState createState() => _GestionDesAdmissionsState();
}

class _GestionDesAdmissionsState extends State<GestionDesAdmissions> {
  List<CandidatPreInscrit> etudiantsAvecTroisDocuments = [];
  CandidatPreInscrit? _selectedEudiant;
  List<CandidatPreInscrit> futureEtudiants = [];
  final _formKey = GlobalKey<FormState>();

  String _noteEntretien = '';
  String _notetest = '';

  // Liste des dossiers
  List<DossierAdmission> futureDossiers = [];
  // Contrôleurs pour le formulaire

  final TextEditingController _remarqueController = TextEditingController();
  String statutActuel = "tous";

  // Variables pour le formulaire
  bool _copieCni = false;
  bool _releveNotes = false;
  bool _diplome = false;
  String _statut = 'refuse';

  void _fetchEtudiants() async {
    try {
      List<CandidatPreInscrit> etudiantData =
          await EtudiantService().getEtudiantsAvecTroisDocuments();

      setState(() {
        futureEtudiants = etudiantData;
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  //Recupérations des dossiers

  void _fetchDossierss() async {
    try {
      List<DossierAdmission> dossiersData =
          await DossierAdmissionService().getAllDossiers();

      setState(() {
        futureDossiers = dossiersData;
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchEtudiants();
    _fetchDossierss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackgroound,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: myDrawerColol,
        onPressed: () async {
          bool success = await addDossier(); // Attendre la fin de l'ajout
          if (success) {
            setState(() {
              _fetchDossierss();
            });
          }

          _remarqueController.clear();
        },
      ),
      body: Row(
        children: [
          const MyDrawer(),
          Expanded(
            child: Column(
              children: [
                const MyAppbar(
                  title: "Gestion des Admissions",
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      // Le Scaffold interne est remplacé par une Column
                      children: [
                        TabBar(
                          tabs: const [
                            Tab(
                              text: "Dossiers ",
                            ),
                            Tab(
                              text: "Dossiers en Attentes ",
                            )
                          ],
                          indicatorColor: myDrawerColol,
                          labelColor: myredColor,
                          labelStyle: valueStyle,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              //Listed des Admissions
                              builtListeDossier(context),
                              buildListeEnAttente(context)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget builtListeDossier(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: FutureBuilder(
            future: DossierAdmissionService().getAllDossiers(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<DossierAdmission> dossiers = snapshot.data!;
                // if (statutActuel != "tous") {
                //   dossiers = dossiers.where((d) {
                //     final statut = d.statut?.toLowerCase() ?? "en_attente";
                //     return statut == statutActuel;
                //   }).toList();
                // }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 210,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: dossiers.length,
                  itemBuilder: (context, index) {
                    final dossier = dossiers[index];
                    String statutAdmission = "En attente";

                    if (dossier.statut != null) {
                      statutAdmission = dossier.statut;
                    }

                    return DossierAdmisCard(
                        detail: () {
                          final statut = dossier.statut?.toLowerCase();

                          if (statut == "valide") {
                            if (dossier.candidat?.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NouvelleInscriptions(
                                    etudiantAInscrire: dossier.candidat,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Erreur : étudiant introuvable")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Impossible d'inscrire un étudiant non validé."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        nomEtudiant:
                            '${dossier.candidat!.prenom!} ${dossier.candidat!.nom!}',
                        remarque: dossier.remarque,
                        status: statutAdmission.toUpperCase(),
                        supprimer: () => _confirmDelete(dossier!.id!),
                        noteEntretien: dossier.noteEntretien,
                        noteTest: dossier.noteTest,
                        modifier: () {
                          // _admissionEditDialog(
                          //     dossier: dossier, id: dossier.candidat!.id!);
                          // setState(() {
                          //   _fetchDossierss();
                          // });
                        });
                  },
                );
              } else {
                return Center(child: Text("Aucun Dossier trouvé"));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildListeEnAttente(BuildContext context) {
    return Column(
      // Changed from Expanded to Column
      children: [
        Flexible(
          // Changed from Expanded to Flexible
          flex: 1,
          child: FutureBuilder(
            future: EtudiantService().getEtudiantsAvecTroisDocuments(),
            builder: (context, snapshot) {
              // ... (votre code pour gérer les états de la future)
              if (snapshot.hasData && snapshot.data != null) {
                // Filtrage ici
                List<CandidatPreInscrit> items = snapshot.data!
                    .where((etudiant) =>
                        (etudiant.documents?.length ?? 0) == 3 &&
                        etudiant.dossierAdmission == null)
                    .toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisExtent: 200,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3 / 2),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final etudiant = items[index];
                    int nbreDocuments = etudiant.documents?.length ?? 0;
                    String statutAdmission = "En attente";

                    return AdmissionEnAttenteCard(
                      nomEudiant: '${etudiant.prenom} ${etudiant.nom}',
                      filiereSouhaitee: etudiant.filiereSouhaitee!.nomFiliere,
                      niveauSouhaitee: etudiant.niveauSouhaite!.nomNiveau,
                      statutAdmission: statutAdmission,
                      nbreDocument: nbreDocuments,
                    );
                  },
                );
              } else
                return Center(child: Text("Aucun Dossier en Attente trouvé"));
            },
          ),
        ),
      ],
    );
  }

  //Liste des dossiers

  Future<bool> addDossier() async {
    bool success = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Nouveau Doosier"),
              content: Container(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //choix de l'etudiant
                          DropdownButtonFormField<CandidatPreInscrit>(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: "Selectionner un Etudiant"),
                            validator: (value) => value == null
                                ? "Veuillez selectionner un etudiant"
                                : null,
                            items: futureEtudiants.map((etudiant) {
                              return DropdownMenuItem<CandidatPreInscrit>(
                                child:
                                    Text('${etudiant.prenom} ${etudiant.nom}'),
                                value: etudiant,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedEudiant = value;
                              });
                            },
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          CheckboxListTile(
                            title: const Text('Copie CNI'),
                            value: _copieCni,
                            onChanged: (value) =>
                                setState(() => _copieCni = value!),
                          ),
                          CheckboxListTile(
                            title: const Text('Relevé de notes'),
                            value: _releveNotes,
                            onChanged: (value) =>
                                setState(() => _releveNotes = value!),
                          ),
                          CheckboxListTile(
                            title: const Text('Diplôme'),
                            value: _diplome,
                            onChanged: (value) =>
                                setState(() => _diplome = value!),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Note Test d\'admission',
                                prefixIcon: Icon(Icons.edit_note),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onChanged: (value) {
                              setState(() {
                                _notetest = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir la note de Test d\'admission';
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Note Entretien',
                                prefixIcon: Icon(Icons.record_voice_over),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onChanged: (value) {
                              setState(() {
                                _noteEntretien = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir la note d\entretien";
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            value: _statut,
                            decoration: InputDecoration(
                                labelText: 'Statut',
                                prefixIcon: Icon(Icons.view_timeline_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            items: const [
                              DropdownMenuItem(
                                  value: 'valide', child: Text('Validé')),
                              DropdownMenuItem(
                                  value: 'refuse', child: Text('Refusé')),
                            ],
                            onChanged: (value) =>
                                setState(() => _statut = value!),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: _remarqueController,
                            decoration: InputDecoration(
                                labelText: 'Remarque',
                                prefixIcon: Icon(Icons.chat),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonAnnuler(),
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final dossier = DossierAdmission(
                                      id: _selectedEudiant!.id,
                                      copieCni: _copieCni,
                                      diplome: _diplome,
                                      candidat: _selectedEudiant,
                                      releveNotes: _releveNotes,
                                      noteTest: double.tryParse(_notetest) ?? 0,
                                      noteEntretien:
                                          double.tryParse(_noteEntretien) ?? 0,
                                      remarque: _remarqueController.text,
                                      statut: _statut,
                                    );

                                    bool exists =
                                        await DossierAdmissionService()
                                            .dissierExist(
                                                _selectedEudiant!.id!);
                                    if (exists) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Un dossier existe déjà avec cet Etudiant."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    final dossierJson = dossier.toJson();
                                    print("donnees envoyés:${dossierJson}");

                                    await DossierAdmissionService()
                                        .createDossierAdmission(
                                            dossierAdmissionData: dossierJson);

                                    setState(() {
                                      _fetchDossierss();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Dossier d'Admission ajouté avec succès."),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    success = true;

                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Ajouter'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
    return success;
  }

  // ===== Bouton de filtre personnalisé =====
  //Sans effet
  Widget filtreButton(String value, String label) {
    final isActive = statutActuel == value;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.grey[300],
        foregroundColor: isActive ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        setState(() {
          statutActuel = value;
        });
      },
      child: Text(label),
    );
  }

  // / Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce Dossier ?"),
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
                DossierAdmissionService().deleteDossier(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    _fetchDossierss();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Dossier supprimé avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : $error")),
                  );
                });
                Navigator.pop(context, true);
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
