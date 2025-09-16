import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_dto.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_service.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/prinscription_service.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/theme/colors.dart';

class NouvelleInscriptions extends StatefulWidget {
  final DossierAdmissionDto dossierAdmission;

  const NouvelleInscriptions({super.key, required this.dossierAdmission});

  @override
  State<NouvelleInscriptions> createState() => _NouvelleInscriptionsState();
}

class _NouvelleInscriptionsState extends State<NouvelleInscriptions> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _dateController = TextEditingController();

  // États de chargement
  bool _isLoading = true;
  bool _isSubmitting = false; // 👈 Ajouté pour gérer la soumission
  String _errorMessage = '';

  // Données récupérées depuis l'API
  List<Candidat> _candidatsAdmis = [];
  List<Filiere> _filiereList = [];
  List<Niveau> _niveauList = [];
  List<AnneeAcademique> _anneeList = [];

  // Sélections utilisateur
  int? _selectedEtudiantId;
  int? _selectedFiliereId;
  int? _selectedNiveauId;
  int? _selectedAnneeId;
  bool paye = false;

  // Récupère les candidats admis (dossiers validés)
  Future<void> _fetchCandidatsAdmis() async {
    try {
      final dossiers = await DossierAdmissionService().getAllDossiers();
      final admis = dossiers
          .where((d) => d.status == 'VALIDE')
          .map((d) => d.candidat!)
          .toList();

      if (!mounted) return;
      setState(() {
        _candidatsAdmis = admis;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erreur lors du chargement des étudiants admis : $e";
      });
    }
  }

  // Récupère les filières
  Future<void> _fetchFilieres() async {
    try {
      final filieres = await FiliereService().getFilieres();
      if (!mounted) return;
      setState(() {
        _filiereList = filieres;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erreur lors du chargement des filières : $e";
      });
    }
  }

  // Récupère les niveaux par filière
  Future<void> _fetchNiveaux(int filiereId) async {
    try {
      final niveaux = await NiveauService().getNiveauxByFiliere(filiereId);
      if (!mounted) return;
      setState(() {
        _niveauList = niveaux;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erreur lors du chargement des niveaux : $e";
      });
    }
  }

  // Récupère les années académiques
  Future<void> _fetchAnnees() async {
    try {
      final annees = await AnneeAcademiqueService().getSessions();
      if (!mounted) return;
      setState(() {
        _anneeList = annees;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erreur lors du chargement des années académiques : $e";
      });
    }
  }

  // Initialisation des données au démarrage
  @override
  void initState() {
    super.initState();
    _montantController.text = '';
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await Future.wait([
        _fetchCandidatsAdmis(),
        _fetchFilieres(),
        _fetchAnnees(),
      ]);

      // Si un dossier est fourni, on pré-remplit les champs
      if (widget.dossierAdmission.candidat != null) {
        final candidat = widget.dossierAdmission.candidat!;

        _selectedEtudiantId = candidat.id;
        _selectedFiliereId = widget.dossierAdmission.filiereAccepteeId;
        _selectedNiveauId = widget.dossierAdmission.niveauAccepteId;
        _selectedAnneeId = candidat.anneeAcademique?.id;

        // Charger les niveaux si la filière est connue
        if (_selectedFiliereId != null) {
          await _fetchNiveaux(_selectedFiliereId!);
        }
      }

      // Pré-remplir la date actuelle
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Échec de l'initialisation : $e";
      });
    }
  }

  @override
  void dispose() {
    _montantController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Inscription'),
        backgroundColor: myDrawerColol,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, size: 18),
                              onPressed: () =>
                                  setState(() => _errorMessage = ''),
                            ),
                          ],
                        ),
                      ),
                    _buildEtudiantField(),
                    SizedBox(height: 20),
                    _buildFiliereField(),
                    SizedBox(height: 20),
                    _buildNiveauField(),
                    SizedBox(height: 20),
                    _buildAnneeField(),
                    SizedBox(height: 20),
                    _buildPayementField(),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : _submitForm, // 👈 Désactive pendant soumission
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myDrawerColol,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Confirmer l’inscription',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEtudiantField() {
    if (widget.dossierAdmission.candidat != null) {
      final candidat = widget.dossierAdmission.candidat!;
      return Card(
        elevation: 2,
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.person, color: myDrawerColol, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${candidat.prenom} ${candidat.nom}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Email : ${candidat.email ?? 'Non renseigné'}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                    widget.dossierAdmission.status.toString().toUpperCase()),
                backgroundColor: Colors.green[200],
                labelStyle: TextStyle(color: Colors.green[800]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sélectionner un étudiant',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedEtudiantId,
          decoration: InputDecoration(
            labelText: 'Étudiant',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(Icons.person, color: myDrawerColol),
          ),
          items: _candidatsAdmis.map((etudiant) {
            return DropdownMenuItem<int>(
              value: etudiant.id,
              child: Text("${etudiant.prenom} ${etudiant.nom}"),
            );
          }).toList(),
          onChanged: _selectedAnneeId != null
              ? null
              : (value) {
                  setState(() {
                    _selectedEtudiantId = value;
                  });
                },
          validator: (value) =>
              value == null ? 'Veuillez sélectionner un étudiant' : null,
        ),
      ],
    );
  }

  Widget _buildFiliereField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filière',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedFiliereId,
          decoration: InputDecoration(
            labelText: 'Filière',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(Icons.school, color: myDrawerColol),
          ),
          items: _filiereList.map((filiere) {
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
                _fetchNiveaux(value);
              }
            });
          },
          validator: (value) =>
              value == null ? 'Veuillez sélectionner une filière' : null,
        ),
      ],
    );
  }

  Widget _buildNiveauField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Niveau',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedNiveauId,
          decoration: InputDecoration(
            labelText: 'Niveau',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(Icons.grade, color: myDrawerColol),
          ),
          items: _niveauList.map((niveau) {
            return DropdownMenuItem<int>(
              value: niveau.id,
              child: Text(niveau.nomNiveau),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedNiveauId = value);
          },
          validator: (value) =>
              value == null ? 'Veuillez sélectionner un niveau' : null,
        ),
      ],
    );
  }

  Widget _buildAnneeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Année Académique',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedAnneeId,
          decoration: InputDecoration(
            labelText: 'Année Académique',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(Icons.calendar_today, color: myDrawerColol),
          ),
          items: _anneeList.map((annee) {
            return DropdownMenuItem<int>(
              value: annee.id,
              child: Text(annee.nomAnnee),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedAnneeId = value);
          },
          validator: (value) =>
              value == null ? 'Veuillez sélectionner une année' : null,
        ),
      ],
    );
  }

  Widget _buildPayementField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Montant versé (FCFA)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        CheckboxListTile(
          title: const Text("Payement Efféctué"),
          value: paye,
          onChanged: (value) => setState(() => paye = value ?? false),
          activeColor: myDrawerColol,
        ),
        SizedBox(height: 8),
        FilterChip(
          label: const Text('Payement'),
          selected: paye,
          onSelected: (value) => setState(() => paye = value),
          checkmarkColor: Colors.white,
          selectedColor: myDrawerColol,
          labelStyle: TextStyle(color: paye ? Colors.white : Colors.black),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return; // Empêche les doubles clics

    setState(() => _isSubmitting = true);

    final selectedEtudiant = _candidatsAdmis.firstWhereOrNull(
      (c) => c.id == _selectedEtudiantId,
    );

    final selectedFiliere = _filiereList.firstWhereOrNull(
      (f) => f.id == _selectedFiliereId,
    );

    final selectedNiveau = _niveauList.firstWhereOrNull(
      (n) => n.id == _selectedNiveauId,
    );

    final selectedAnnee = _anneeList.firstWhereOrNull(
      (a) => a.id == _selectedAnneeId,
    );

    if (selectedEtudiant == null ||
        selectedFiliere == null ||
        selectedNiveau == null ||
        selectedAnnee == null) {
      if (!mounted) {
        setState(() => _isSubmitting = false);
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erreur : Données incomplètes'),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      final exists = await InscriptionService().checkIfInscriptionExists(
        etudiantId: _selectedEtudiantId!,
        filiereId: _selectedFiliereId!,
        anneeAcademiqueId: _selectedAnneeId!,
      );

      if (exists) {
        if (!mounted) {
          setState(() => _isSubmitting = false);
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
                'Cet étudiant est déjà inscrit dans cette filière et année.'),
          ),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      // Créer les données d'inscription dans le format attendu par le backend
      final dossEtudiant = DossierAdmission(
        id: widget.dossierAdmission.id,
        copieCni: widget.dossierAdmission.copieCni,
        releveNotes: widget.dossierAdmission.releveNotes,
        diplome: widget.dossierAdmission.diplome,
        noteTest: widget.dossierAdmission.noteTest,
        noteEntretien: widget.dossierAdmission.noteEntretien,
        status: widget.dossierAdmission.status,
      );

      final inscriptionData = Etudiant(
        paye: paye,
        anneeAcademique: selectedAnnee,
        filiere: selectedFiliere,
        niveau: selectedNiveau,
        dossierAdmission: dossEtudiant,
      );

      print("Inscription données envoyées: ${inscriptionData}");

      await InscriptionService()
          .addInscription(inscriptionData: inscriptionData.toJson());

      if (!mounted) {
        setState(() => _isSubmitting = false);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Inscription réussie !'),
        ),
      );

      // 👇 NAVIGATION SÉCURISÉE — retour simple en arrière
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        setState(() => _isSubmitting = false);
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erreur : $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
