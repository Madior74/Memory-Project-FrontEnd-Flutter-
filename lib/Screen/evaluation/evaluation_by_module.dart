import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Note/note_by_evaluation.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Salle/model_salle.dart';
import 'package:school_management_system/Screen/Salle/salle_service.dart';
import 'package:school_management_system/Screen/Seance/model_seance.dart';
import 'package:school_management_system/Screen/Seance/seance_service.dart';
import 'package:school_management_system/Screen/evaluation/evaluation_dto.dart';
import 'package:school_management_system/Screen/evaluation/evaluation_service.dart';
import 'package:school_management_system/Screen/evaluation/model_evaluation.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class EvaluationByModule extends StatefulWidget {
  final Module module;
  const EvaluationByModule({super.key, required this.module});

  @override
  State<EvaluationByModule> createState() => _EvaluationByModuleState();
}

class _EvaluationByModuleState extends State<EvaluationByModule> {
  List<Salle> futureSalles = [];
  List<Professeur> futureProfs = [];
  List<Etudiant> futureEtudiant = [];

  late Future<List<EvaluationDto>> futuresEvaluations;
  late Future<List<Seance>> futureSeances;
  Seance? lastSeancen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recupererDerniereSeance();
    fetchSalle();
    fetchprof();
    fetchEtudiants();
    futuresEvaluations =
        EvaluationService().getEvaluationByModuleWithDTO(widget.module.id!);
    futureSeances = SeanceService().getSeancesByModuleId(widget.module!.id!);
  }

  void fetchSalle() async {
    try {
      List<Salle> sallesData = await SalleService().getAllSalles();

      setState(() {
        futureSalles = sallesData;
      });
    } catch (e) {
      print("Erreur lors de la recuperation des Salles de Classe: $e");
    }
  }

  void fetchprof() async {
    try {
      List<Professeur> profList = await ProfesseurService().fetchprofesseurs();
      setState(() {
        futureProfs = profList;
      });
    } catch (e) {
      print("Erreur lors de la recuperation des Profs: $e");
    }
  }

//Recuperer les etudiants
  void fetchEtudiants() async {
    try {
      List<Etudiant> etudiantList =
          await InscriptionService().getAllInscriptionWDTO();
      setState(() {
        futureEtudiant = etudiantList;
      });
    } catch (e) {
      print("Erreur lors de la recuperation des Profs: $e");
    }
  }

  Future<void> recupererDerniereSeance() async {
    final seances =
        await SeanceService().getSeancesByModuleId(widget.module!.id!);

    if (seances.isEmpty) {
      print("Aucune séance trouvée.");
      return;
    }

    final derniereSeance = seances.last;
    lastSeancen = derniereSeance;

    print(
        "Dernière séance : ${derniereSeance.dateSeance} à ${derniereSeance.heureDebut}");
    // Utilise-la comme tu veux
  }

  final List<String> listType = ["Devoir", "Examen", "Projet", "Exposé", "TP"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: myDrawerColol,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => showEvaluationDialog(),
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
              child: Column(
            children: [
              MyAppbar(
                  title: "${widget.module.nomModule} Liste des Evaluations"),
              Expanded(
                  child: FutureBuilder(
                future: futuresEvaluations,
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
                          const Text("Aucune Seance trouvée"),
                        ],
                      ),
                    );
                  } else {
                    List<EvaluationDto> evalues = snapshot.data!;

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                "Module",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Professeur",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Type",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Durée(H)",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Date Evaluation",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Salle",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Heure De Début",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Heure de Fin",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Notes",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Actions",
                                style: titleStyle,
                              )),
                            ],
                            rows: evalues.map((ev) {
                              //Format des heures
                              String formatTimeOfDay(TimeOfDay time) {
                                final now = DateTime.now();
                                final dt = DateTime(now.year, now.month,
                                    now.day, time.hour, time.minute);
                                return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                              }

                              final moduleName = ev.moduleId == widget.module.id
                                  ? widget.module.nomModule
                                  : "N/A";

                              final prof = futureProfs.firstWhereOrNull(
                                  (prof) => prof.id == ev.professeurId);

                              final salleC = futureSalles.firstWhereOrNull(
                                  (sl) => sl.id == ev.salleId);
                              return DataRow(cells: [
                                DataCell(SizedBox(
                                  width: 150,
                                  child: Tooltip(
                                    message: moduleName,
                                    child: Text(
                                      moduleName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                                DataCell(Text('${prof?.prenom}  ${prof?.nom}')),
                                DataCell(
                                  Text(ev.type),
                                ),
                                DataCell(
                                  Text(ev.getDureeEnHeur().toString()),
                                ),
                                DataCell(Text(ev.dateEvaluation!
                                    .toIso8601String()
                                    .substring(0, 10))),
                                DataCell(Text(salleC?.nomSalle ?? "N/A")),
                                DataCell(Text(formatTimeOfDay(ev.heureDebut))),
                                DataCell(Text(formatTimeOfDay(ev.heureFin))),
                                DataCell(TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NoteByEvaluation(evaluationId: ev.id),
                                        ));
                                  },
                                  label: Text("Gérer"),
                                  icon: Icon(Icons.person_add_disabled_rounded),
                                )),
                                DataCell(Row(
                                  children: [
                                    TextButton.icon(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {},
                                        label: const Text("Modifier")),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextButton.icon(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            showSupprimeDialog(context, ev.id!),
                                        label: const Text("Supprimer"))
                                  ],
                                ))
                              ]);
                            }).toList()),
                      ),
                    );
                  }
                },
              )),
            ],
          ))
        ],
      ),
    );
  }

  Future<void> showEvaluationDialog({
    Evaluation? evaluation, // Pass null pour ajouter, un objet pour modifier
  }) async {
    final _formKey = GlobalKey<FormState>();
    String? selectedType =
        (evaluation?.type != null && listType.contains(evaluation?.type))
            ? evaluation?.type
            : listType.isNotEmpty
                ? listType[0]
                : null;
    int? _selectedSalle;

    // Date et heure
    TimeOfDay? _heureDebut;
    TimeOfDay? _heureFin;
    DateTime? _selectedDate;
    if (evaluation != null) {
      _selectedDate = evaluation.dateEvaluation;
      _heureFin = evaluation.heureFin;
      _heureDebut = evaluation.heureDebut;
      selectedType = evaluation.type;
    }

    // //prof

    final defaultProf = lastSeancen?.professeur;
    print("Id Prof");
    print(defaultProf?.toJson());
    print(lastSeancen?.toJson());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(evaluation == null
                  ? "Ajouter une évaluation"
                  : "Modifier l'évaluation"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.view_timeline_rounded,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          labelText: "Type de l'Evaluation",
                        ),
                        items: listType.map((String type) {
                          return DropdownMenuItem<String>(
                              value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Veuillez sélectionner le type d'évaluation";
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 12),

                      // Date
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 10),
                              Text(
                                _selectedDate == null
                                    ? 'Sélectionnez une date'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Heure début
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _heureDebut ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _heureDebut = pickedTime;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Heure de début',
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          child: Text(
                            _heureDebut == null
                                ? 'Sélectionner...'
                                : "${_heureDebut!.hour.toString().padLeft(2, '0')}:${_heureDebut!.minute.toString().padLeft(2, '0')}",
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Heure de fin
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _heureFin ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _heureFin = pickedTime;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Heure de fin',
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          child: Text(
                            _heureFin == null
                                ? 'Sélectionner...'
                                : "${_heureFin!.hour.toString().padLeft(2, '0')}:${_heureFin!.minute.toString().padLeft(2, '0')}",
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      //Salle
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Salle',
                          prefixIcon: const Icon(Icons.meeting_room),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        value: _selectedSalle,
                        items: futureSalles
                            .map((s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.nomSalle ?? 'Non spécifié')))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedSalle = value),
                        validator: (value) {
                          if (value == null) {
                            return "Veuillez sélectionner la salle ";
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ButtonAnnuler(),
                TextButton.icon(
                  onPressed: () async {
                    final salleCorrespondante = futureSalles
                        .firstWhereOrNull((sc) => sc.id == _selectedSalle);
                    if (_formKey.currentState!.validate()) {
                      // Création ou mise à jour de l'évaluation
                      Evaluation newEval = Evaluation(
                        id: evaluation?.id,
                        type: selectedType ?? "Devoir",
                        dateEvaluation: _selectedDate,
                        heureDebut: _heureDebut ?? TimeOfDay.now(),
                        heureFin: _heureFin ?? TimeOfDay.now(),
                        module: widget.module, // Utilise le module actuel
                        professeur: defaultProf,
                        salle: salleCorrespondante,
                        notes: evaluation?.notes,
                      );

                      try {
                        if (evaluation == null) {
                          // Ajout
                          saveEvaluation(newEval);
                        } else {
                          updateEvaluation(newEval);
                        }

                        // Rafraîchir la liste
                        setState(() {
                          futuresEvaluations = EvaluationService()
                              .getEvaluationByModuleWithDTO(widget.module.id!);
                        });

                        Navigator.of(context).pop(); // Ferme le dialogue
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erreur : $e")),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    evaluation == null ? Icons.add : Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    evaluation == null ? "Ajouter" : "Modifier",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myDrawerColol,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

//Ajouter Seance
  Future<void> saveEvaluation(Evaluation evaluation) async {
    DateTime? dateCours = DateTime.parse(
        evaluation.dateEvaluation!.toIso8601String().substring(0, 10));

    try {
      bool existe = await EvaluationService().evaluationExist(
          evaluation.module!.id!,
          evaluation.type,
          evaluation.dateEvaluation,
          evaluation.heureDebut);
      if (existe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Cette evaluation existe déjà pour ce module",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
        );
        return;
      }
      // Enregistrement evaluation
      await EvaluationService().addEvaluation(evaluation).then((_) {
        setState(() {
          futuresEvaluations = EvaluationService()
              .getEvaluationByModuleWithDTO(widget.module!.id!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Evaluation  ajoutée avec succès."),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (error) {
      print("Erreur lors de l'ajout : $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'ajout : $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool?> showSupprimeDialog(BuildContext context, int seanceId) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer l\'evaluation'),
          content: const Text(
              'Êtes-vous sûr de vouloir supprimer cette evaluation?'),
          actions: [
            const ButtonAnnuler(),
            TextButton(
              onPressed: () async {
                await deleteSeance(seanceId);
                Navigator.of(context).pop(true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  //update
  Future<void> updateEvaluation(Evaluation evaluation) async {
    print("donnees envoyés:${evaluation.toJson()}");

    try {
      // Enregistrement evaluation
      await EvaluationService()
          .updateEvaluation(evaluation.id!, evaluation)
          .then((_) {
        setState(() {
          futuresEvaluations = EvaluationService()
              .getEvaluationByModuleWithDTO(widget.module!.id!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Evaluation  Mise à jour avec succès."),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (error) {
      print("Erreur lors du mise à jour : $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'ajout : $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //Supprimer la evaluation
  Future<void> deleteSeance(int evaluId) async {
    try {
      await EvaluationService().deleteEvaluation(evaluId);
      setState(() {
        futuresEvaluations =
            EvaluationService().getEvaluationByModuleWithDTO(widget.module.id!);
      });
    } catch (e) {
      print("Erreur lors de la suppression de la séance: $e");
    }
  }
}
