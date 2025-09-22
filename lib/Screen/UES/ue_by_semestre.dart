import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/semestre/model_semestre.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';
import 'package:school_management_system/Screen/Modules/module_by_ue.dart';
import 'package:school_management_system/Screen/Modules/moduleService.dart';
import 'package:school_management_system/Screen/UES/ue_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/theme/colors.dart';

class UeBySemestre extends StatefulWidget {
  final Semestre semestre;
  const UeBySemestre({super.key, required this.semestre});

  @override
  State<UeBySemestre> createState() => _UeBySemestreState();
}

class _UeBySemestreState extends State<UeBySemestre> {
  late Future<List<UE>> futureUes;
  int? selectedUeId; // Stocke l'ID de l'UE sélectionnée
  late Future<List<Module>>
      futureModules; // Stocke les modules de l'UE sélectionnée
  final _formKey = GlobalKey<FormState>();
  final _codeUEController = TextEditingController();
  final _nomUEController = TextEditingController();
  late int? selectedSemestre = 0;
  late List<Niveau> filteredNiveaux = [];
  late List<Niveau> allNiveaux = [];
  bool isLoading = false;

  final List<int> credits = [4, 5, 6];

  @override
  void initState() {
    super.initState();
    futureUes = UeService().getUesBySemestre(widget.semestre.id!);
  }

  // Méthode pour charger les modules d'une UE
  Future<List<Module>> _loadModules(int ueId) async {
    try {
      return await ModuleService().getModulesByUE(ueId);
    } catch (e) {
      // Afficher un message convivial en cas d'erreur
      print("Erreur lors du chargement des modules: $e");
      return []; // Retourner une liste vide pour éviter un crash
    }
  }



// Future<void> _updateModule(int moduleId, String nomModule, int volumeHoraire, double creditModule) async {
//   await ModuleService().updateModule(moduleId, nomModule, volumeHoraire, creditModule);

//   // Rafraîchir les données
//   setState(() {
//     futureUes = UeService().getUesBySemestre(widget.semestre.id!);
//   });
// }

  Future<void> _deleteModule(int moduleId) async {
    await ModuleService().deleteModule(moduleId);

    // Rafraîchir les données
    setState(() {
      futureUes = UeService().getUesBySemestre(widget.semestre.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          " ${widget.semestre.nomSemestre} Liste des UES",
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myredColor,
        onPressed: () {
          addUE(semestre: widget.semestre);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<UE>>(
        future: futureUes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune UE trouvée"));
          } else {
            List<UE> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                UE ue = items[index];
                return ExpansionTile(
                  title: Text(
                    ue.nomUE,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  subtitle: Row(
                    children: [
                      const Text(
                        "Nombre de Crédit:",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "${ue.getTotalCredits()}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          updateUE(
                              semestre: widget.semestre, ue: ue, id: ue.id!);
                        },
                        icon: Icon(
                          Icons.info,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          _confirmDelete(ue.id!);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    FutureBuilder<List<Module>>(
                      future: _loadModules(ue.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Erreur: ${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Aucun module trouvé"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.indigo)),
                                    onPressed: () {
                                      _showAddModuleDialog(ue: ue);
                                    },
                                    child: const Text(
                                      "Ajouter un Module",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          List<Module> modules = snapshot.data!;
                          return Column(
                            children: [
                              ...modules.map((module) {
                                return ListTile(
                                  title: Text(module.nomModule),
                                  subtitle:
                                      Text("Crédits: ${module.creditModule}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _showEditModuleDialog(module);
                                        },
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _confirmDeleteModule(module.id!);
                                        },
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              ListTile(
                                title: ElevatedButton(
                                  onPressed: () {
                                    _showAddModuleDialog(ue: ue);
                                  },
                                  child: const Text("Ajouter un Module"),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  // Dialogue pour ajouter un module
  void _showAddModuleDialog({required UE ue}) {
    TextEditingController nomController = TextEditingController();
    TextEditingController volumeHoraireController = TextEditingController();
    List<double> creditModule = [
      1.5,
      2,
      2.5,
      3,
      3.5,
    ];
    double? selectedCredit;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un Module"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: "Nom du Module"),
              ),
              TextField(
                controller: volumeHoraireController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Volume Horaire"),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField<double>(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.format_list_numbered),
                    labelText: "Nombre de Crédit",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                value: selectedCredit,
                items: creditModule.map((credit) {
                  return DropdownMenuItem<double>(
                    value: credit,
                    child: Text(credit.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCredit = value;
                  });
                },
                validator: (value) {
                  value == null ? "Veuillez selectionner le credit" : null;
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                final module = Module(
                    creditModule: selectedCredit ?? 0,
                    ue: ue,
                    dateAjout: DateTime.now(),
                    nomModule: nomController.text,
                    volumeHoraire: int.parse(volumeHoraireController.text));
                await ModuleService().addModuleToUE(ue.id!, module);
                setState(() {
                  futureUes = UeService().getUesBySemestre(widget.semestre.id!);
                  _loadModules(ue.id!);
                });
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  // Dialogue pour modifier un module
  void _showEditModuleDialog(Module module) {
    TextEditingController nomController =
        TextEditingController(text: module.nomModule);
    TextEditingController volumeHoraireController =
        TextEditingController(text: module.volumeHoraire.toString());
    TextEditingController creditController =
        TextEditingController(text: module.creditModule.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier un Module"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: "Nom du Module"),
              ),
              TextField(
                controller: volumeHoraireController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Volume Horaire"),
              ),
              TextField(
                controller: creditController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Crédits"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // await ModuleService(). _updateModule(
                //   module.id!,
                //   nomController.text,
                //   int.parse(volumeHoraireController.text),
                //   double.parse(creditController.text),
                // );
                // Navigator.pop(context);
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  // Confirmation de suppression d'un module
  void _confirmDeleteModule(int moduleId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmer la Suppression"),
          content: const Text("Voulez-vous vraiment supprimer ce module ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // Attendre la fin de la suppression
                await _deleteModule(moduleId);

                // Rafraîchir les données
                setState(() {
                  futureUes = UeService().getUesBySemestre(widget.semestre.id!);
                });

                Navigator.pop(context);
              },
              child:
                  const Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void addUE({required Semestre semestre}) async {
    // Vérifiez si les valeurs nécessaires sont présentes
    if (semestre.id == null) {
      print("Erreur : le semestre sont null !");
      return; // Stopper l'exécution si une valeur est manquante
    }

    // Afficher une boîte de dialogue pour saisir les détails de l'UE
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Ajouter une nouvelle  UE"),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Champ de saisie du code de l'UE
                    TextFormField(
                      controller: _codeUEController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        labelText: "Code de l'UE",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer le code de l'UE";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Champ de saisie du nom de l'UE
                    TextFormField(
                      controller: _nomUEController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        labelText: "Nom de l'UE",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer le nom de l'UE";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // Bouton Annuler
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Annuler",
                  style: TextStyle(color: myredColor),
                ),
              ),

              // Bouton Ajouter
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          // Créer un objet UE avec les données saisies
                          final ue = UE(
                            nomUE: _nomUEController.text,
                            codeUE: _codeUEController.text,
                            semestre: semestre,
                            dateAjout: DateTime.now(),
                            modules: [],
                          );

                          // Envoyer l'UE à l'API Spring Boot
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            String ueName = _nomUEController.text;
                            bool exists =
                                await UeService().ueExist(ueName, semestre.id!);
                            if (exists) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: myredColor,
                                    content: const Text(
                                      "Une UE avec ce nom existe dèja 😔",
                                      style: TextStyle(color: Colors.white),
                                    )));
                              }
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }

                            await UeService()
                                .addUeToSemestre(semestre.id!, ue)
                                .then((_) {
                              if (mounted) {
                                setState(() {
                                  futureUes =
                                      UeService().getUesBySemestre(widget.semestre.id!);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text("UE ajoutée avec succès !")),
                                );
                                Navigator.of(context)
                                    .pop(); // Fermer la boîte de dialogue
                              }
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur : $e")),
                              );
                            }
                            print("Erreurrr:$e");
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Ajouter"),
              ),
            ],
          );
        });
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
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Appel à la méthode de suppression
                UeService().deleteUe(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureUes =
                        UeService().getUesBySemestre(widget.semestre.id!);
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

  void updateUE({required Semestre semestre, required UE ue, id}) async {
    // Vérifiez si les valeurs nécessaires sont présentes
    if (semestre.niveau!.id == null || semestre.id == null) {
      print("Erreur : La filière, le niveau ou le semestre sont null !");
      return; // Stopper l'exécution si une valeur est manquante
    }

    _codeUEController.text = ue.codeUE;
    _nomUEController.text = ue.nomUE;
    // Afficher une boîte de dialogue pour saisir les détails de l'UE
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle  UE"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ de saisie du code de l'UE
                  TextFormField(
                    controller: _codeUEController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Code de l'UE",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le code de l'UE";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Champ de saisie du nom de l'UE
                  TextFormField(
                    controller: _nomUEController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Nom de l'UE",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le nom de l'UE";
                      }
                      return null;
                    },
                  ),

                  //Volume Horaire
                ],
              ),
            ),
          ),
          actions: [
            // Bouton Annuler
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: TextStyle(color: myredColor),
              ),
            ),

            // Bouton Ajouter
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Créer un objet UE avec les données saisies
                  final uptadeUE = UE(
                    id: ue.id, // Assurez-vous que l'ID est passé

                    nomUE: _nomUEController.text,
                    codeUE: _codeUEController.text,

                    semestre: semestre,
                    dateAjout: DateTime.now(),
                    modules: [],
                  );

                  try {
                    await UeService().updateUE(uptadeUE);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("UE mise à jour avec succès !")),
                    );
                    Navigator.of(context).pop();
                    setState(() {
                      futureUes =
                          UeService().getUesBySemestre(widget.semestre.id!);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : $e")),
                    );
                    print("Erreur : $e");
                  }
                }
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }
}
