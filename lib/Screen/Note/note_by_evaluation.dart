import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/InscriptionService.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant_dto.dart';
import 'package:school_management_system/Screen/Note/note_dto.dart';
import 'package:school_management_system/Screen/Note/note_service.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/evaluation/evaluation_dto.dart';
import 'package:school_management_system/Screen/evaluation/evaluation_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class NoteByEvaluation extends StatefulWidget {
  final int evaluationId;
  const NoteByEvaluation({super.key, required this.evaluationId});

  @override
  State<NoteByEvaluation> createState() => _NoteByEvaluationState();
}

class _NoteByEvaluationState extends State<NoteByEvaluation> {
  late Future<List<NoteDTO>> futuresNotes;
  List<EvaluationDto> futuresEvaluations = [];
  List<Professeur> futureProfs = [];
  List<EtudiantDTO> futureEtudiant = [];

  @override
  void initState() {
    super.initState();
    futuresNotes = NoteService().getNoteByEvaluation(widget.evaluationId);
    fetchEvaluation();
    fetchprof();
    fetchEtudiants();
  }

//Recuperer les etudiants
  void fetchEtudiants() async {
    try {
      List<EtudiantDTO> etudiantList =
          await InscriptionService().getAllInscriptions();
      setState(() {
        futureEtudiant = etudiantList;
      });
    } catch (e) {
      print("Erreur lors de la recuperation des Profs: $e");
    }
  }

  //prof
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

  void fetchEvaluation() async {
    try {
      List<EvaluationDto> listeEv =
          await EvaluationService().getAllEvaluationsWithDto();

      setState(() {
        futuresEvaluations = listeEv;
      });
    } catch (e) {
      print("Erreur lors de la recuperation des evaluation $e");
    }
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
        onPressed: () => showNoteDialog(),
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
              child: Column(
            children: [
              MyAppbar(title: "Liste des Notes"),
              Expanded(
                  child: FutureBuilder(
                future: futuresNotes,
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
                          const Text("Aucune Note trouvée"),
                        ],
                      ),
                    );
                  } else {
                    List<NoteDTO> notes = snapshot.data!;

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                "Type",
                                style: titleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                "Etudiant",
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
                            rows: notes.map((note) {
                              //Format des heures
                              final evaluation =
                                  futuresEvaluations.firstWhereOrNull(
                                      (ev) => ev.id == note.evaluationId);
                              final pro = futureProfs.firstWhereOrNull(
                                  (p) => p.id == evaluation?.professeurId);

                              final prenom = note.prenomEtudiant;
                              final nom = note.nomEtudiant;

                              //Table
                              return DataRow(cells: [
                                //Type Evaluation
                                DataCell(SizedBox(
                                  width: 150,
                                  child: Text(
                                    evaluation?.type ?? "N/A",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),

                                DataCell(Text(
                                  '${prenom} ${nom}',
                                )),

                                DataCell(Text(note.valeur.toString())),
                                DataCell(Row(
                                  children: [
                                    TextButton.icon(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            showNoteDialog(note: note),
                                        label: const Text("Modifier")),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextButton.icon(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
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

  //

  Future<void> showNoteDialog({
    NoteDTO? note,
  }) async {
    final _formKey = GlobalKey<FormState>();
    int? _selectedEtudiant;
    final TextEditingController noteController =
        TextEditingController(text: note?.valeur.toString() ?? '');
    if (note != null) {
      _selectedEtudiant = note.etudiantId;
      print("etudiantId");
      print(_selectedEtudiant);
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:
                  Text(note == null ? "Ajouter une note" : "Modifier l'note"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Etudiants
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Etudiant',
                          prefixIcon: const Icon(Icons.meeting_room),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        value: _selectedEtudiant,
                        items: futureEtudiant
                            .map((e) => DropdownMenuItem(
                                value: e.dossierAdmissionDto.candidat.id,
                                child: Text(
                                    '${e.prenom} ${e.nom}' ?? 'Non spécifié')))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedEtudiant = value),
                        validator: (value) {
                          if (value == null) {
                            return "Veuillez sélectionner un Etudiant ";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: noteController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            hintText: "Ex:12.5",
                            labelText: "Valeur de la Note",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        validator: (value) {
                          if (value == null) {
                            return "Veuillez attribuer une note ";
                          }

                          return null;
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                ButtonAnnuler(),
                TextButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Création ou mise à jour de l'évaluation
                      NoteDTO newNote = NoteDTO(
                          id: note?.id,
                          etudiantId: _selectedEtudiant!,
                          evaluationId: widget.evaluationId,
                          valeur: double.tryParse(noteController.text.trim()) ??
                              0.0);
                      print("donnee envoyee:${newNote.toJson()}");

                      try {
                        if (note == null) {
                          // Ajout
                          saveNote(newNote);
                        } else {
                          updateNote(newNote.id!, newNote);
                        }

                        // Rafraîchir la liste
                        setState(() {
                          fetchEtudiants();
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
                    note == null ? Icons.add : Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    note == null ? "Ajouter" : "Modifier",
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

  //Save
  Future<void> saveNote(NoteDTO note) async {
    try {
      bool existe =
          await NoteService().noteExist(note.etudiantId, note.evaluationId);
      if (existe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Cette Note existe déjà pour cette Evaluation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
        );
        return;
      }
      // Enregistrement de la séance
      await NoteService().addNote(note).then((_) {
        if (mounted) {
          setState(() {
            futuresNotes =
                NoteService().getNoteByEvaluation(widget.evaluationId);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Note  ajoutée avec succès."),
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

  //updateNote
  Future<void> updateNote(int noteId, NoteDTO note) async {
    try {
      await NoteService().updateNote(noteId, note);
      setState(() {
        futuresNotes = NoteService().getNoteByEvaluation(widget.evaluationId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note  mise à jour avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la mise a jour : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
