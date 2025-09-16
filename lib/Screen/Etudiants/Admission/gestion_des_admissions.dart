import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_dto.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription_dto.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/nouvelle_inscriptions.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/candidat_request_dto.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/admission_service.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/prinscription_service.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';
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
  List<CandidatRequestDto> etudiantsAvecTroisDocuments = [];
  List<Candidat> futureCandidats = [];
  List<CandidatRequestDto> futureCandidatsDocs = [];
  List<Filiere> futuresFiliere = [];
  List<Niveau> futuresNiveau = [];
  List<DossierAdmissionDto> futureDossiers = [];
  List<InscriptionDTO> futureInscriptions = [];

  // Variables pour le chargement et les erreurs
  bool _isLoadingDossiers = true;
  bool _isLoadingEtudiants = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    fetchInscrits();
  }

  void _fetchData() async {
    setState(() {
      _isLoadingDossiers = true;
      _isLoadingEtudiants = true;
      _errorMessage = '';
    });

    try {
      await Future.wait([
        _fetchEtudiants(),
        _fetchDossiers(),
        fetchFiliere(),
      ]);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Erreur de chargement: $e";
        });
      }
    }
  }

  Future<void> fetchInscrits() async {
    try {
      List<InscriptionDTO> listeEtudiantInscrits =
          await InscriptionService().getAllInscriptions();
      setState(() {
        futureInscriptions = listeEtudiantInscrits;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors du chargement des Inscrits: $e";
        _isLoadingEtudiants = false;
      });
    }
  }

  Future<void> _fetchEtudiants() async {
    try {
      List<CandidatRequestDto> etudiantData =
          await PrinscriptionService().getEtudiantsAvecTroisDocuments();

      setState(() {
        futureCandidatsDocs = etudiantData;
        _isLoadingEtudiants = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors du chargement des étudiants: $e";
        _isLoadingEtudiants = false;
      });
    }
  }

  Future<void> _fetchDossiers() async {
    try {
      List<DossierAdmissionDto> dossiersData =
          await DossierAdmissionService().getAllDossiers();

      setState(() {
        futureDossiers = dossiersData;
        _isLoadingDossiers = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        print(_errorMessage);

        _errorMessage = "Erreur lors du chargement des dossiers: $e";
        _isLoadingDossiers = false;
      });
    }
  }

  Future<void> fetchFiliere() async {
    try {
      List<Filiere> filieresData = await FiliereService().getFilieres();
      setState(() {
        futuresFiliere = filieresData;
      });
    } catch (e) {
      print("$e");
    }
  }

  Future<void> fetchNiveau(int filiereId) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: myDrawerColol,
        onPressed: () async {
          bool success = await openDossier();
          if (success) {
            _fetchData();
          }
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
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.red[100],
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_errorMessage)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _errorMessage = '';
                            });
                          },
                        ),
                      ],
                    ),
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
                                text: "Dossiers Évalués",
                              ),
                              Tab(
                                text: "Dossiers en Attentes ",
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
    if (_isLoadingDossiers) {
      return const Center(child: CircularProgressIndicator());
    }
    // final filterdDossier = futureDossiers.where((candat) {
    //   return !futureInscriptions
    //       .any((ins) => ins.dossierAdmissionDto.candidat.id == candat.id);
    // }).toList();

    final inscritIds = {
      for (var ins in futureInscriptions) ins.dossierAdmissionDto?.candidat?.id
    }.whereType<int>().toSet(); // Ne garde que les IDs non nuls

    final filteredDossiers = futureDossiers.where((dossier) {
      return !inscritIds.contains(dossier.id);
    }).toList();
    if (filteredDossiers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Aucun dossier trouvé", style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columnSpacing: 20,
          columns: [
            DataColumn(
              label: Text("Etudiant",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Filière Acceptée",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Niveau Accepté",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Note Test",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Note Entretien",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Status",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Actions",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Inscrire",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
          ],
          rows: filteredDossiers.map((dossier) {
            String? statutAdmission;

            if (dossier.status == null) {
              statutAdmission = 'REFUSE';
            } else {
              statutAdmission = dossier!.status;
            }

            return DataRow(
              cells: [
                DataCell(
                  Text("${dossier.candidat?.prenom} ${dossier.candidat?.nom}"),
                ),
                DataCell(Text(dossier.filiereAcceptee.toString())),
                DataCell(Text(dossier.niveauAccepte.toString())),
                DataCell(
                  Center(child: Text(dossier.noteTest.toStringAsFixed(2))),
                ),
                DataCell(
                  Center(child: Text(dossier.noteEntretien.toStringAsFixed(2))),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: getStatusColors(statutAdmission.toString())
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      statutAdmission.toString().split('.').last,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getStatusColors(statutAdmission.toString()),
                      ),
                    ),
                  ),
                ),
                DataCell(TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NouvelleInscriptions(dossierAdmission: dossier),
                          ));
                    },
                    label: Text("Inscrire"))),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => openDossier(dossieradmission: dossier),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: "Modifier",
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _confirmDelete(dossier.id!),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: "Supprimer",
                      ),
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

  Widget buildListeEnAttente(BuildContext context) {
    if (_isLoadingEtudiants) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtrage des étudiants avec 3 documents et sans dossier
    List<CandidatRequestDto> items = futureCandidatsDocs.where((etudiant) {
      // Vérifier que l'étudiant a 3 documents
      bool hasThreeDocuments = etudiant.documentCount == 3;

      // Vérifier que l'étudiant n'a pas déjà un dossier
      bool hasNoDossier =
          !futureDossiers.any((dossier) => dossier.candidat?.id == etudiant.id);

      return hasThreeDocuments && hasNoDossier;
    }).toList();

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Aucun dossier en attente", style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columnSpacing: 20,
          columns: [
            DataColumn(
              label: Text("Etudiant",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Filière Visée",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Niveau Visé",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
            DataColumn(
              label: Text("Status",
                  style: titleStyle.copyWith(color: myDrawerColol)),
            ),
          ],
          rows: items.map((attente) {
            return DataRow(
              cells: [
                DataCell(Text("${attente.prenom} ${attente.nom}")),
                DataCell(Text(attente.nomFiliere)),
                DataCell(Text(attente.nomNiveau)),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "En attente",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<bool> openDossier({DossierAdmissionDto? dossieradmission}) async {
    List<CandidatRequestDto> filtredEtudiant =
        futureCandidatsDocs.where((etudiant) {
      // Vérifier que l'étudiant a 3 documents
      bool hasThreeDocuments = etudiant.documentCount == 3;

      // Vérifier que l'étudiant n'a pas déjà un dossier
      bool hasNoDossier =
          !futureDossiers.any((dossier) => dossier.candidat?.id == etudiant.id);

      return hasThreeDocuments && hasNoDossier;
    }).toList();
    bool isEditMode = dossieradmission != null;
    int? dossieradmissionId = dossieradmission?.id;
    bool success = false;

    // Initialisation des contrôleurs
    final _remarqueController =
        TextEditingController(text: dossieradmission?.remarque ?? '');
    final _noteEntretien = TextEditingController(
        text: dossieradmission?.noteEntretien.toString() ?? '');
    final _notetest = TextEditingController(
        text: dossieradmission?.noteTest.toString() ?? '');

    // Variables d'état
    bool _copieCni = dossieradmission?.copieCni ?? false;
    bool _releveNotes = dossieradmission?.releveNotes ?? false;
    bool _diplome = dossieradmission?.diplome ?? false;
    String _statut = dossieradmission?.status ?? 'REFUSE';

    Candidat? _selectedEudiant = dossieradmission?.candidat;
    int? etudiantId = _selectedEudiant?.id;

    int? _selectedFiliereId = _selectedEudiant?.filiereSouhaitee?.id;
    int? _selectedNiveauId = _selectedEudiant?.niveauSouhaite?.id;

    final _formKey = GlobalKey<FormState>();

    // Charger les niveaux si une filière est déjà sélectionnée
    if (_selectedFiliereId != null) {
      await fetchNiveau(_selectedFiliereId!);
    }
    final validation = isEditMode ? "Modifier" : 'Ajouter';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isEditMode ? "Mise à jour du dossier" : "Nouveau Dossier",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Choix de l'étudiant
                    DropdownButtonFormField<int>(
                      value: etudiantId,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Sélectionner un étudiant",
                      ),
                      items: filtredEtudiant.map((etudiant) {
                        return DropdownMenuItem<int>(
                          value: etudiant.id,
                          child: Text('${etudiant.prenom} ${etudiant.nom}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          etudiantId = value;
                          final selectedEtudiantDto =
                              filtredEtudiant.firstWhere((e) => e.id == value);

                          // Pour les filières et niveaux, on utilisera les noms du DTO
                          // et on cherchera les objets correspondants dans les listes
                          final filiere = futuresFiliere.firstWhereOrNull((f) =>
                              f.nomFiliere == selectedEtudiantDto.nomFiliere);
                          final niveau = futuresNiveau.firstWhereOrNull((n) =>
                              n.nomNiveau == selectedEtudiantDto.nomNiveau);

                          // Créer un objet Candidat temporaire à partir du DTO
                          _selectedEudiant = Candidat(
                            id: selectedEtudiantDto.id,
                            prenom: selectedEtudiantDto.prenom,
                            nom: selectedEtudiantDto.nom,
                            filiereSouhaitee: filiere,
                            niveauSouhaite: niveau,
                          );

                          _selectedFiliereId = filiere?.id;
                          _selectedNiveauId = niveau?.id;

                          if (_selectedFiliereId != null) {
                            fetchNiveau(_selectedFiliereId!).then((_) {
                              setState(() {});
                            });
                          }
                        });
                      },
                      validator: (value) => value == null
                          ? "Veuillez sélectionner un étudiant"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Documents
                    const Text("Documents requis:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilterChip(
                            label: const Text('Copie CNI'),
                            selected: _copieCni,
                            onSelected: (value) =>
                                setState(() => _copieCni = value),
                            checkmarkColor: Colors.white,
                            selectedColor: myDrawerColol,
                            labelStyle: TextStyle(
                                color: _copieCni ? Colors.white : Colors.black),
                          ),
                        ),
                        Expanded(
                          child: FilterChip(
                            label: const Text('Relevé de notes'),
                            selected: _releveNotes,
                            onSelected: (value) =>
                                setState(() => _releveNotes = value),
                            checkmarkColor: Colors.white,
                            selectedColor: myDrawerColol,
                            labelStyle: TextStyle(
                                color:
                                    _releveNotes ? Colors.white : Colors.black),
                          ),
                        ),
                        Expanded(
                          child: FilterChip(
                            label: const Text('Diplôme'),
                            selected: _diplome,
                            onSelected: (value) =>
                                setState(() => _diplome = value),
                            checkmarkColor: Colors.white,
                            selectedColor: myDrawerColol,
                            labelStyle: TextStyle(
                                color: _diplome ? Colors.white : Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filière et Niveau
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'Filière',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
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
                                  fetchNiveau(value).then((_) {
                                    setState(() {});
                                  });
                                }
                              });
                            },
                            validator: (value) => value == null
                                ? 'Veuillez sélectionner une filière'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'Niveau',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
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
                            validator: (value) => value == null
                                ? 'Veuillez sélectionner un niveau'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _notetest,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Note Test',
                              prefixIcon: const Icon(Icons.edit_note),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir la note';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Veuillez saisir un nombre valide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _noteEntretien,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Note Entretien',
                              prefixIcon: const Icon(Icons.record_voice_over),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir la note";
                              }
                              if (double.tryParse(value) == null) {
                                return 'Veuillez saisir un nombre valide';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Statut et Remarque
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _statut,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                  Icons.view_timeline_rounded,
                                  color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Statut du dossier",
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'VALIDE', child: Text('Validé')),
                              DropdownMenuItem(
                                  value: 'REFUSE', child: Text('Refusé')),
                            ],
                            onChanged: (value) =>
                                setState(() => _statut = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _remarqueController,
                            decoration: InputDecoration(
                              labelText: 'Remarque',
                              prefixIcon: const Icon(Icons.chat),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Boutons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Annuler',
                              style: TextStyle(color: Colors.grey[600])),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedEudiant == null ||
                                  etudiantId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Veuillez sélectionner un candidat."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final selectedFiliere =
                                  futuresFiliere.firstWhereOrNull(
                                      (f) => f.id == _selectedFiliereId);
                              final selectedNiveau =
                                  futuresNiveau.firstWhereOrNull(
                                      (n) => n.id == _selectedNiveauId);

                              if (selectedFiliere == null ||
                                  selectedNiveau == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Veuillez sélectionner une filière et un niveau valides."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final dossier = DossierAdmission(
                                niveauAccepte: selectedNiveau,
                                id: dossieradmissionId,
                                copieCni: _copieCni,
                                diplome: _diplome,
                                candidat: _selectedEudiant!,
                                filiereAcceptee: selectedFiliere,
                                releveNotes: _releveNotes,
                                noteTest: double.tryParse(_notetest.text) ?? 0,
                                noteEntretien:
                                    double.tryParse(_noteEntretien.text) ?? 0,
                                remarque: _remarqueController.text,
                                status: _statut,
                              );

                              if (isEditMode) {
                                await updateDossier(
                                    dossieradmissionId!, dossier);
                              } else {
                                await saveDossier(dossier);
                              }

                              success = true;
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            validation,
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myDrawerColol,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );

    return success;
  }

  Future<void> saveDossier(DossierAdmission dossier) async {
    try {
      if (dossier.candidat?.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aucun candidat associé à ce dossier."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print("candidat Id ${dossier.candidat!.id}");
      bool exists =
          await DossierAdmissionService().dissierExist(dossier.candidat!.id!);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Un dossier existe déjà avec cet Etudiant."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final dossierJson = dossier.toJson();
      print("donnees envoyés:${dossierJson}");

      await DossierAdmissionService()
          .createDossierAdmission(dossierAdmissionData: dossierJson);

      setState(() {
        _fetchData();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dossier d'Admission ajouté avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (error) {
      print("Echec de la creation decdossier d'admission:$error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'ajout du dossier : $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //Update Dossier

  Future<void> updateDossier(int dossierId, DossierAdmission dossier) async {
    try {
      await DossierAdmissionService()
          .updateDossierAdmission(dossier, dossierId);

      setState(() {
        _fetchData();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dossier d'Admission mis à jour avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors du mis à jour du dossier : $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    _fetchData();
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

  Color getStatusColors(String status) {
    if (status.toLowerCase() == 'refuse') {
      return Colors.red;
    } else if (status.toLowerCase() == "en attente") {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
