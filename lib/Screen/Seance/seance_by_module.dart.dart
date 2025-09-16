import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Salle/model_salle.dart';
import 'package:school_management_system/Screen/Salle/salle_service.dart';
import 'package:school_management_system/Screen/Seance/seance_service.dart';
import 'package:school_management_system/Screen/Seance/model_seance.dart';
import 'package:school_management_system/Screen/assiduite/assiduite_by_seance.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class SeanceByModule extends StatefulWidget {
  final Module? module;
  const SeanceByModule({super.key, required this.module});

  @override
  State<SeanceByModule> createState() => _SeanceByModuleState();
}

class _SeanceByModuleState extends State<SeanceByModule> {
  late Future<List<Seance>> futureSeances;
  List<Professeur> futuresprofesseur = [];
  List<Salle> futureSalles = [];
  Duration heureDeroules = Duration.zero;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureSeances = SeanceService().getSeancesByModuleId(widget.module!.id!);
    fetchSalle();
    fetchProfesseurs();

    setState(() {});
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

  void fetchProfesseurs() async {
    try {
      List<Professeur> professeursData =
          await ProfesseurService().fetchprofesseurs();

      setState(() {
        futuresprofesseur = professeursData;
      });
    } catch (e) {
      print("Erreur lors de la recuperation des Professeurs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: myDrawerColol,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showOpenSeanceDialog(context: context);
        },
      ),
      body: Row(
        children: [
          const MyDrawer(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyAppbar(
                    title:
                        "Liste des Séance du Module ${widget.module?.nomModule}"),
                Expanded(
                    child: FutureBuilder(
                  future: futureSeances,
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
                      List<Seance> seances = snapshot.data!;
                      for (var i in seances) {
                        heureDeroules += i.duree;
                      }

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
                                  "Salle",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Date Séance",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Durée",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Heure de Début",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Heure de Fin",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Status",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Assiduité",
                                  style: titleStyle,
                                )),
                                DataColumn(
                                    label: Text(
                                  "Actions",
                                  style: titleStyle,
                                )),
                              ],
                              rows: seances.map((seance) {
                                //Format des heures
                                String formatTimeOfDay(TimeOfDay time) {
                                  final now = DateTime.now();
                                  final dt = DateTime(now.year, now.month,
                                      now.day, time.hour, time.minute);
                                  return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                                }

                                String? nomSalle;
                                if (seance.estEnLigne) {
                                  nomSalle = "En Ligne";
                                } else {
                                  nomSalle = seance.salle?.nomSalle;
                                }

                                return DataRow(cells: [
                                  DataCell(SizedBox(
                                    width: 150,
                                    child: Tooltip(
                                      message: seance.module.nomModule,
                                      child: Text(
                                        seance.module.nomModule,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )),
                                  DataCell(Text(
                                      '${seance.professeur.prenom}  ${seance.professeur.nom}')),
                                  DataCell(
                                    seance.estEnLigne
                                        ? const Row(
                                            children: [
                                              Icon(Icons.wifi,
                                                  color: Colors.green,
                                                  size: 20),
                                              SizedBox(width: 6),
                                              Text("En Ligne"),
                                            ],
                                          )
                                        : Text(nomSalle ?? "Salle Non Définie"),
                                  ),
                                  DataCell(Text(seance.dateSeance!
                                      .toIso8601String()
                                      .substring(0, 10))),
                                  DataCell(Text(seance.dureeHMin)),
                                  DataCell(
                                      Text(formatTimeOfDay(seance.heureDebut))),
                                  DataCell(
                                      Text(formatTimeOfDay(seance.heureFin))),
                                  DataCell(Text(seance.statut,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: statutColor(
                                            seance.statut,
                                          )))),
                                  DataCell(TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AssiduiteByModule(
                                                    seance: seance),
                                          ));
                                    },
                                    label: Text("Gérer"),
                                    icon:
                                        Icon(Icons.person_add_disabled_rounded),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      TextButton.icon(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              _showOpenSeanceDialog(
                                                  context: context,
                                                  seance: seance),
                                          label: const Text("Modifier")),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      TextButton.icon(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => showSupprimeDialog(
                                              context, seance.id!),
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
            ),
          ),
        ],
      ),
    );
  }
  //Le status

  Color statutColor(String status) {
    switch (status) {
      case 'Annulée':
        return Colors.red;

      case 'Déroulée':
        return Colors.grey;
      case 'Programmée':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  void _showOpenSeanceDialog(
      {required BuildContext context, Seance? seance}) async {
    List<Seance> seances = await futureSeances;
    Professeur? profParDefaut =
        SeanceService().getDernierProfesseurPourModule(widget.module!, seances);
   
    bool isEditMode = seance != null;
    int? seanceId = seance?.id;
    String title =
        isEditMode ? "Modification de la séance" : 'Ajouter un Cours';

    int? selectedModule;
    int? _selectedSalle;
    bool _estEnLigne = false;

    int? _selectedProfesseur;

    TimeOfDay? _heureDebut;
    TimeOfDay? _heureFin;
    DateTime? _selectedDate;

    if (isEditMode) {
      selectedModule = seance.module.id;

      _selectedProfesseur = seance.professeur.id;
      profParDefaut = seance.professeur;
      _selectedDate = seance.dateSeance;
      _heureFin = seance.heureFin;
      _heureDebut = seance.heureDebut;
      _estEnLigne = seance.estEnLigne;
    }

    if (isEditMode && !_estEnLigne) {
      _selectedSalle = seance.salle?.id;
    }
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext, setState) {
          return AlertDialog(
            title: Text(
              title,
              style: titleStyle,
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Filière

                      // Niveau

                      // Semestre

                      // UE

                      // Module

                      // Professeur

                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Professeur',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        value: profParDefaut?.id,
                        items: futuresprofesseur
                            .map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Text("${p.prenom} ${p.nom}")))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedProfesseur = value),
                        validator: (value) => value == null
                            ? 'Veuillez sélectionner un professeur'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Cours en ligne'),
                        value: _estEnLigne,
                        onChanged: (val) =>
                            setState(() => _estEnLigne = val ?? false),
                      ),
                      const SizedBox(height: 16),

                      // Champ Salle désactivé si cours en ligne
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
                        onChanged: _estEnLigne
                            ? null // désactive le champ
                            : (value) => setState(() => _selectedSalle = value),
                        validator: (value) {
                          if (_estEnLigne) {
                            _selectedSalle = null;
                            return null; // pas de validation si en ligne
                          }
                          return value == null
                              ? 'Veuillez sélectionner une salle'
                              : null;
                        },
                      ),

                      if (_estEnLigne)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Le champ salle est désactivé pour un cours en ligne.",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),

                      const SizedBox(height: 16),
                      // Sélection de la date
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

                      // Heure de début
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
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ButtonAnnuler(),
                  TextButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(isEditMode ? "Modifier" : 'Ajouter'),
                    onPressed: () async {
                      // Récupérer l’année académique en cours
                      final anneeEnCours =
                          await AnneeAcademiqueService().getAnneeEnCours();
                      // Vérification des champs obligatoires
                      if (!_formKey.currentState!.validate() ||
                          _selectedProfesseur == null ||
                          _heureDebut == null ||
                          _heureFin == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Veuillez remplir tous les champs")),
                        );
                        return;
                      }

                      if (heureDeroules.inHours >=
                          widget.module!.volumeHoraire) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Impossible d'ajouter une Séance Volume horaire total atteint")),
                        );
                        return;
                      }

                      // Création de la salle (ou null si cours en ligne)
                      final Salle? salle = _estEnLigne
                          ? null
                          : futureSalles
                              .firstWhere((s) => s.id == _selectedSalle);

                      // Création du cours
                      final cours = Seance(
                        salle: salle,
                        estEnLigne: _estEnLigne,
                        heureDebut: _heureDebut!,
                        heureFin: _heureFin!,
                        dateSeance: _selectedDate,
                        module: widget.module!,
                        professeur: futuresprofesseur
                            .firstWhere((p) => p.id == _selectedProfesseur),
                        anneeAcademique: anneeEnCours,

                        // semestre: futuresSemestre
                        //     .firstWhere((s) => s.id == selectedSemestre),
                      );
                      print("donnees envoyes:${cours.toJson()}");

                      if (isEditMode) {
                        updateSeance(seanceId!, cours).then((_) {
                          setState(() {
                            futureSeances = SeanceService()
                                .getSeancesByModuleId(widget.module!.id!);
                          });
                        });

                        Navigator.of(context).pop();
                      } else {
                        saveSeance(cours).then((_) {
                          setState(() {
                            futureSeances = SeanceService()
                                .getSeancesByModuleId(widget.module!.id!);
                          });
                        });

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

//Ajouter Seance
  Future<void> saveSeance(Seance cours) async {
    DateTime? dateCours =
        DateTime.parse(cours.dateSeance!.toIso8601String().substring(0, 10));

    try {
      bool existe = await SeanceService().seanceExists(context,
          cours.module.id!, dateCours, cours.heureDebut, cours.heureFin);
      if (existe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Cette séance existe déjà pour ce module",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
        );
        return;
      }
      // Enregistrement de la séance
      await SeanceService().createSeance(cours).then((_) {
        setState(() {
          futureSeances =
              SeanceService().getSeancesByModuleId(widget.module!.id!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Séance  ajoutée avec succès."),
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

  //Mettre A jour une seance
  Future<void> updateSeance(int seanceId, Seance seance) async {
    try {
      await SeanceService().updateSeance(seanceId, seance);
      setState(() {
        futureSeances =
            SeanceService().getSeancesByModuleId(widget.module!.id!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Séance  mise à jour avec succès."),
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

  //Supprimer la seance
  Future<void> deleteSeance(int seanceId) async {
    try {
      await SeanceService().deleteSeance(seanceId);
      setState(() {
        futureSeances = SeanceService().getAllSeances();
      });
    } catch (e) {
      print("Erreur lors de la suppression de la séance: $e");
    }
  }

  //Suppression de la seance
  Future<bool?> showSupprimeDialog(BuildContext context, int seanceId) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la séance'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cette séance?'),
          actions: [
            const ButtonAnnuler(),
            TextButton(
              onPressed: () async {
                await deleteSeance(seanceId);
                Navigator.of(context).pop(true); // Confirmer suppression
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
