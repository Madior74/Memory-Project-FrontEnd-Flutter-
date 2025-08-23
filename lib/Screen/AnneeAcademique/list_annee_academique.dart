import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:school_management_system/Widgets/anneeAcademiqueCard.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListSession extends StatefulWidget {
  const ListSession({super.key});

  @override
  State<ListSession> createState() => _ListSessionState();
}

class _ListSessionState extends State<ListSession> {
  late Future<List<AnneeAcademique>> futureSessions;
  String? nomAnnee;
  DateTime? dateDebutChoisie;
  DateTime? dateFinChoisie;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    futureSessions = AnneeAcademiqueService().getSessions();
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
        onPressed: () => _openSessionDiaog(),
      ),
      backgroundColor: myBackgroound,
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Années Académiques",
                ),
                Expanded(
                  child: FutureBuilder<List<AnneeAcademique>>(
                      future: futureSessions,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Erreur:${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Aucune  Année Trouvée"),
                          );
                        } else {
                          List<AnneeAcademique> items = snapshot.data!;
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      mainAxisExtent: 260,
                                      maxCrossAxisExtent: 500),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                AnneeAcademique annees = items[index];
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnneeAcademiqueCard(
                                      annee: annees,
                                      onEdit: () {
                                        _openSessionDiaog(annee: annees);
                                      },
                                      onDelete: () =>
                                          _confirmDelete(annees.id!),
                                    ));
                              });
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateSession(int idSession, String sessionName,
      DateTime? dateDebut, DateTime? dateFin) async {
    try {
      //creation de l'instance
      AnneeAcademique anneeajour = AnneeAcademique(
          nomAnnee: sessionName, dateDebut: dateDebut, dateFin: dateFin);

      //Appel du service
      await AnneeAcademiqueService().updateSession(idSession, anneeajour);

      setState(() {
        futureSessions = AnneeAcademiqueService().getSessions();
      });
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Session Mise à jour avec succès")),
      );
    } catch (error) {
      print("Errors lors de la Mise a jour");
      print(error);
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise a jour  : $error")),
      );
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "Êtes-vous sûr de vouloir supprimer cette Année Académique ?"),
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
                AnneeAcademiqueService().deleteSession(id).then((_) {
                  // Rafraîchir la liste des sessions
                  setState(() {
                    futureSessions = AnneeAcademiqueService().getSessions();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Session supprimée avec succès"),
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

  Future<void> saveAnne(
      String sessionName, DateTime? dateDebut, DateTime? dateFin) async {
    try {
      // Créer une instance de Session avec le bon nom
      AnneeAcademique newSession = AnneeAcademique(
          dateFin: dateFin, dateDebut: dateDebut, nomAnnee: sessionName);

      //Verification de l'existence de l'annee
      bool exists = await AnneeAcademiqueService().anneeExists(sessionName);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Une Année avec ce nom existe déjà"),
          ),
        );
        return;
      }

      // Appeler le service pour ajouter la session
      await AnneeAcademiqueService().createSession(newSession);

      // Rafraîchir la liste des sessions après l'ajout
      setState(() {
        futureSessions = AnneeAcademiqueService().getSessions();
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Session ajoutée avec succès")),
      );
    } catch (error) {
      print("Errors lors de la creation");
      print(error);
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout : $error")),
      );
    }
  }

  //Methode d'ajout et de Modification
  void _openSessionDiaog({AnneeAcademique? annee}) {
    DateTime? _selectedDateDebut = annee?.dateDebut;
    DateTime? _selectedDateFin = annee?.dateFin;

    bool isEditMode = annee != null;

    int? sessionId = annee?.id;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEditMode
                  ? "Modification de l'Année"
                  : "Ajout d'une nouvelle Année"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Date de Debut
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDateDebut ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if (picked != null && picked != _selectedDateDebut) {
                            setStateDialog(() {
                              _selectedDateDebut = picked;
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
                                _selectedDateDebut == null
                                    ? 'Date de Début'
                                    : '${_selectedDateDebut!.day}/${_selectedDateDebut!.month}/${_selectedDateDebut!.year}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date de Fin
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDateFin ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if (picked != null && picked != _selectedDateFin) {
                            setStateDialog(() {
                              _selectedDateFin = picked;
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
                                _selectedDateFin == null
                                    ? 'Date de Fin'
                                    : '${_selectedDateFin!.day}/${_selectedDateFin!.month}/${_selectedDateFin!.year}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      if (_selectedDateDebut == null ||
                          _selectedDateFin == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Veuillez sélectionner les deux dates")));
                        return;
                      }

                      if (_selectedDateDebut!.isAfter(_selectedDateFin!)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "La date de Début ne peut pas être après la date de fin")));
                        return;
                      }
                      String sessionName =
                          '${_selectedDateDebut?.year}/${_selectedDateFin?.year}';

                      if (isEditMode) {
                        updateSession(sessionId!, sessionName,
                                _selectedDateDebut, _selectedDateFin)
                            .then((_) {
                          Navigator.of(context).pop();
                        });
                      } else {
                        saveAnne(sessionName, _selectedDateDebut,
                                _selectedDateFin)
                            .then((_) {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text(isEditMode ? "Modifier" : "Enregistrer"))
              ],
            );
          });
        });
  }
}
