import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/list_inscriptions.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_service.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart'; // Pour formater les dates

class NouvelleInscriptions extends StatefulWidget {
  final DossierAdmission dossierAdmission;
  const NouvelleInscriptions({super.key, required this.dossierAdmission});

  @override
  State<NouvelleInscriptions> createState() => _NouvelleInscriptionsState();
}

class _NouvelleInscriptionsState extends State<NouvelleInscriptions> {
  final _formKey = GlobalKey<FormState>();

  // Données chargées depuis l'API
  List<CandidatPreInscrit> futuresEtudiants = [];
  List<DossierAdmission> futuresDossiers = [];
  List<Filiere> futuresFiliere = [];
  List<Niveau> futuresNiveau = [];
  List<AnneeAcademique> futuresAnnee = [];

  // Variables pour stocker les IDs sélectionnés
  int? _selectedEtudiantId;
  int? _selectedFiliereId;
  int? _selectedNiveauId;
  int? _selectedAnneeId;

  DateTime? _dateInscription;
  String _montantVerse = '';
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEtudiants();
    fetchDossier();
    fetchAnnee();
    fetchFiliere();

    if (widget.dossierAdmission != null) {
      _selectedEtudiantId = widget.dossierAdmission.candidat?.id;
      _selectedFiliereId =
          widget.dossierAdmission.candidat?.filiereSouhaitee?.id;
      _selectedNiveauId = widget.dossierAdmission.candidat?.niveauSouhaite?.id;

      if (_selectedFiliereId != null) {
        fetchNiveau(_selectedFiliereId!);
      }

      setState(() {});
    }
  }

  // Récupère tous les étudiants validés
  void _fetchEtudiants() async {
    try {
      List<CandidatPreInscrit> etudiantData =
          await PrinscriptionService().getAllEtudiant();
      List<DossierAdmission> dossiers =
          await DossierAdmissionService().getAllDossiers();

      final etudiantsAvecDossierValide = etudiantData.where((etudiant) {
        final dossier = dossiers.firstWhereOrNull(
          (d) => d.candidat?.id == etudiant.id,
        );
        return dossier != null && dossier.status == 'valide';
      }).toList();

      setState(() {
        futuresEtudiants = etudiantsAvecDossierValide;
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  // Récupère les dossiers
  void fetchDossier() async {
    try {
      List<DossierAdmission> dossiersData =
          await DossierAdmissionService().getAllDossiers();
      setState(() {
        futuresDossiers = dossiersData;
      });
    } catch (e) {
      print("$e");
    }
  }

  // Récupère les années académiques
  void fetchAnnee() async {
    try {
      List<AnneeAcademique> anneeData =
          await AnneeAcademiqueService().getSessions();
      setState(() {
        futuresAnnee = anneeData;
      });
    } catch (e) {
      print("$e");
    }
  }

  // Récupère les filières
  void fetchFiliere() async {
    try {
      List<Filiere> filieresData = await FiliereService().getFilieres();
      setState(() {
        futuresFiliere = filieresData;
      });
    } catch (e) {
      print("$e");
    }
  }

  // Récupère les niveaux en fonction de la filière
  void fetchNiveau(int filiereId) async {
    try {
      List<Niveau> niveauData =
          await NiveauService().getNiveauxByFiliere(filiereId);
      setState(() {
        futuresNiveau = niveauData;
      });
    } catch (e) {
      print("$e");
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown : Étudiant
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Étudiant'),
                  value: _selectedEtudiantId,
                  items: futuresEtudiants.map((etudiant) {
                    return DropdownMenuItem<int>(
                      value: etudiant.id,
                      child: Text("${etudiant.prenom} ${etudiant.nom}"),
                    );
                  }).toList(),
                  onChanged: widget.dossierAdmission.candidat != null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedEtudiantId = value;
                          });
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un étudiant';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Dropdown : Filière
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Filière'),
                  value: _selectedFiliereId,
                  items: futuresFiliere.map((filiere) {
                    return DropdownMenuItem<int>(
                      value: filiere.id,
                      child: Text(filiere.nomFiliere),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFiliereId = value;
                      _selectedNiveauId = null;
                      if (value != null) {
                        fetchNiveau(value);
                      }
                    });
                  },
                  validator: (value) => value == null
                      ? 'Veuillez sélectionner une filière'
                      : null,
                ),

                SizedBox(height: 16),

                // Dropdown : Niveau
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Niveau'),
                  value: _selectedNiveauId,
                  items: futuresNiveau.map((niveau) {
                    return DropdownMenuItem<int>(
                      value: niveau.id,
                      child: Text(niveau.nomNiveau),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNiveauId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Veuillez sélectionner un niveau' : null,
                ),

                SizedBox(height: 16),

                // Dropdown : Année Académique
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Année Académique'),
                  value: _selectedAnneeId,
                  items: futuresAnnee.map((annee) {
                    return DropdownMenuItem<int>(
                      value: annee.id,
                      child: Text(annee.nomAnnee),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAnneeId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Veuillez sélectionner une année' : null,
                ),

                SizedBox(height: 16),

                // Montant versé
                TextFormField(
                  decoration: InputDecoration(labelText: 'Montant Versé'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _montantVerse = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir le montant versé';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Bouton Soumettre
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Récupère les objets à partir des ID
                      final selectedEtudiant = futuresEtudiants
                          .firstWhereOrNull((e) => e.id == _selectedEtudiantId);

                      final selectedFiliere = futuresFiliere
                          .firstWhereOrNull((f) => f.id == _selectedFiliereId);

                      final selectedNiveau = futuresNiveau
                          .firstWhereOrNull((n) => n.id == _selectedNiveauId);

                      final selectedAnnee = futuresAnnee
                          .firstWhereOrNull((a) => a.id == _selectedAnneeId);

                      final data = Etudiant(
                        anneeAcademique: selectedAnnee!,
                        dossierAdmission: widget.dossierAdmission,
                        filiere: selectedFiliere,
                        montantVerse: double.tryParse(_montantVerse) ?? 0.0,
                        niveau: selectedNiveau,
                      );

                      final dataJson = data.toJson();
                      print(dataJson);

                      try {
                        // Vérifie si l'inscription existe déjà
                        bool inscriptionExists =
                            await InscriptionService().checkIfInscriptionExists(
                          etudiantId: _selectedEtudiantId!,
                          filiereId: _selectedFiliereId!,
                          anneeAcademiqueId: _selectedAnneeId!,
                        );
                        if (inscriptionExists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content:
                                  Text('Cet(e) Etudiant est dèja inscrit(e) '),
                            ),
                          );
                          return;
                        }
                        await InscriptionService()
                            .addInscription(inscriptionData: dataJson);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListInscriptions(),
                            ));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content:
                                Text('Etudiant(e) Inscrit(e)  avec succès'),
                          ),
                        );
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Erreur lors de l\'ajout : $e'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Erreur : $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Soumettre'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
