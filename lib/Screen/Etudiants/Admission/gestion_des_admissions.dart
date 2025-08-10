import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/list_inscriptions.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/nouvelle_inscriptions.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/detail_prinscrit.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Document/documentScreen.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_service.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Widgets/back_bouton.dart';
import 'package:school_management_system/Widgets/admission_card.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/etudiant_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class GestionDesAdmissions extends StatefulWidget {
  const GestionDesAdmissions({Key? key}) : super(key: key);

  @override
  _GestionDesAdmissionsState createState() => _GestionDesAdmissionsState();
}

class _GestionDesAdmissionsState extends State<GestionDesAdmissions> {
  List<Etudiant> etudiantsAvecTroisDocuments = [];
  Etudiant? _selectedEudiant;
  List<Etudiant> futureEtudiants = [];
  final _formKey = GlobalKey<FormState>();

  // Liste des dossiers
  late Future<List<DossierAdmission>> futureDossiers;
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
      List<Etudiant> etudiantData =
          await EtudiantService().getEtudiantsAvecTroisDocuments();

      setState(() {
        futureEtudiants = etudiantData;
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
    futureDossiers = DossierAdmissionService().getAllDossiers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Gestion des Admissions",
                  onTap: () async {
                    bool success =
                        await addDossier(); // Attendre la fin de l'ajout
                    if (success) {
                      setState(() {
                        futureDossiers = DossierAdmissionService()
                            .getAllDossiers(); // Mettre à jour les données
                      });
                    }

                    _remarqueController.clear();
                  },
                  boutonName: "Nouveau Dossier",
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      // Le Scaffold interne est remplacé par une Column
                      children: [
                        TabBar(
                          tabs: [
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
      // Changed from Expanded to Column
      children: [
        // ... (votre code pour les boutons de filtre)
        Flexible(
          // Changed from Expanded to Flexible
          flex: 1,
          child: FutureBuilder(
            future: futureDossiers,
            builder: (context, snapshot) {
              // ... (votre code pour gérer les états de la future)
              if (snapshot.hasData && snapshot.data != null) {
                List<DossierAdmission> dossiers = snapshot.data!;
                if (statutActuel != "tous") {
                  dossiers = dossiers.where((d) {
                    final statut = d.statut?.toLowerCase() ?? "en_attente";
                    return statut == statutActuel;
                  }).toList();
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 190,
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

                    return DossierAdmissionCard(
                        detail: () {
                          final statut = dossier.statut?.toLowerCase();

                          if (statut == "valide") {
                            if (dossier.etudiant?.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NouvelleInscriptions(
                                    etudiantAInscrire: dossier.etudiant,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Erreur : étudiant introuvable")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Impossible d'inscrire un étudiant non validé."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        nomEtudiant:
                            '${dossier.etudiant!.prenom!} ${dossier.etudiant!.nom!}',
                        remarque: dossier.remarque,
                        status: statutAdmission.toUpperCase(),
                        supprimer: () => _confirmDelete(dossier!.id!),
                        modifier: () {
                          _admissionEditDialog(
                              dossier: dossier, id: dossier.etudiant!.id!);
                          setState(() {
                            futureDossiers =
                                DossierAdmissionService().getAllDossiers();
                          });
                        });
                  },
                );
              } else
                return const SizedBox.shrink();
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
                List<Etudiant> items = snapshot.data!
                    .where((etudiant) =>
                        (etudiant.documents?.length ?? 0) == 3 &&
                        etudiant.dossierAdmission == null)
                    .toList();
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 450, mainAxisExtent: 200),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final etudiant = items[index];
                    int nbreDocuments = etudiant.documents?.length ?? 0;
                    String statutAdmission = "En attente";

                    return EtudiantCard(
                      nomEudiant: '${etudiant.prenom} ${etudiant.nom}',
                      filiereSouhaitee: etudiant.filiereSouhaitee!.nomFiliere,
                      niveauSouhaitee: etudiant.niveauSouhaite!.nomNiveau,
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
                          _fetchEtudiants();
                        });
                      },
                      nbreDocument: nbreDocuments,
                    );
                  },
                );
              } else
                return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  ///Modifier

  Future<bool> editDossier(DossierAdmission dossier, int id) async {
    bool success = false;

    var _selectedEudiantId = dossier.etudiant!.id;
    var _copieCni = dossier.copieCni;
    var _releveNotes = dossier.releveNotes;
    var _diplome = dossier.diplome;
    var _statut = dossier.statut;
    var _remarqueController =
        TextEditingController(text: dossier.remarque ?? '');

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
                          DropdownButtonFormField<int>(
                            value: _selectedEudiantId,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: "Selectionner un Etudiant"),
                            validator: (value) => value == null
                                ? "Veuillez selectionner un etudiant"
                                : null,
                            items: futureEtudiants.map((etudiant) {
                              return DropdownMenuItem<int>(
                                child:
                                    Text('${etudiant.prenom} ${etudiant.nom}'),
                                value: etudiant.id,
                              );
                            }).toList(),
                            onChanged: _selectedEudiantId != null
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedEudiantId = value;
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
                          ElevatedButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.white.withOpacity(0.5)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final selectedEtudiant =
                                    futureEtudiants.firstWhereOrNull(
                                        (e) => e.id == _selectedEudiantId);
                                final updatedDossier = DossierAdmission(
                                  id: dossier.id!,
                                  copieCni: _copieCni,
                                  diplome: _diplome,
                                  etudiant: selectedEtudiant,
                                  releveNotes: _releveNotes,
                                  remarque: _remarqueController.text,
                                  statut: _statut,
                                );

                                final dossierJson = updatedDossier.toJson();

                                await DossierAdmissionService()
                                    .updateDossierAdmission(
                                        updatedDossier, updatedDossier!.id!);

                                setState(() {
                                  futureDossiers = DossierAdmissionService()
                                      .getAllDossiers();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Dossier d'Admission Mise à jour avec succès."),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                setState(() {
                                  futureDossiers = DossierAdmissionService()
                                      .getAllDossiers();
                                });

                                success = true;

                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Mettre à jour'),
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

  void _admissionEditDialog(
      {required DossierAdmission dossier, required int id}) {
    var _selectedEudiantId = dossier.etudiant!.id;
    var _copieCni = dossier.copieCni;
    var _releveNotes = dossier.releveNotes;
    var _diplome = dossier.diplome;
    var _statut = dossier.statut;
    var _remarqueController =
        TextEditingController(text: dossier.remarque ?? '');

    showDialog(
        context: context,
        builder: (context) {
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
                        DropdownButtonFormField<int>(
                          value: _selectedEudiantId,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              labelText: "Selectionner un Etudiant"),
                          validator: (value) => value == null
                              ? "Veuillez selectionner un etudiant"
                              : null,
                          items: futureEtudiants.map((etudiant) {
                            return DropdownMenuItem<int>(
                              child: Text('${etudiant.prenom} ${etudiant.nom}'),
                              value: etudiant.id,
                            );
                          }).toList(),
                          onChanged: _selectedEudiantId != null
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedEudiantId = value;
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
                        ElevatedButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white.withOpacity(0.5)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final selectedEtudiant =
                                  futureEtudiants.firstWhereOrNull(
                                      (e) => e.id == _selectedEudiantId);
                              final updatedDossier = DossierAdmission(
                                id: dossier.id!,
                                copieCni: _copieCni,
                                diplome: _diplome,
                                etudiant: selectedEtudiant,
                                releveNotes: _releveNotes,
                                remarque: _remarqueController.text,
                                statut: _statut,
                              );

                              final dossierJson = updatedDossier.toJson();

                              await DossierAdmissionService()
                                  .updateDossierAdmission(
                                      updatedDossier, updatedDossier!.id!);

                              setState(() {
                                futureDossiers =
                                    DossierAdmissionService().getAllDossiers();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Dossier d'Admission Mise à jour avec succès."),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              setState(() {
                                futureDossiers =
                                    DossierAdmissionService().getAllDossiers();
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Mettre à jour'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
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
                    futureDossiers = DossierAdmissionService().getAllDossiers();
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
                          DropdownButtonFormField<Etudiant>(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: "Selectionner un Etudiant"),
                            validator: (value) => value == null
                                ? "Veuillez selectionner un etudiant"
                                : null,
                            items: futureEtudiants.map((etudiant) {
                              return DropdownMenuItem<Etudiant>(
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
                                      copieCni: _copieCni,
                                      diplome: _diplome,
                                      etudiant: _selectedEudiant,
                                      releveNotes: _releveNotes,
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
                                    print(dossier.toJson());
                                    final dossierJson = dossier.toJson();

                                    await DossierAdmissionService()
                                        .createDossierAdmission(
                                            dossierAdmissionData: dossierJson);

                                    setState(() {
                                      futureDossiers = DossierAdmissionService()
                                          .getAllDossiers();
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
}
