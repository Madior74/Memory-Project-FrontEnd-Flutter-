import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Seance/seance_by_module.dart.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';
import 'package:school_management_system/Screen/Modules/moduleService.dart';
import 'package:school_management_system/Screen/UES/ue_service.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/module_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class ModuleByUe extends StatefulWidget {
  final UE ue;
  const ModuleByUe({super.key, required this.ue});

  @override
  State<ModuleByUe> createState() => _ModuleByUeState();
}

class _ModuleByUeState extends State<ModuleByUe> {
  late Future<List<Module>> futureModules;
  late Future<List<UE>> futureUEs;
  final _nomModuleController = TextEditingController();
  final _volumeHoraireController = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  List<double> creditModule = [1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5];
  double? selectedCredit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureModules = ModuleService().getModulesByUE(widget.ue.id!);
    futureUEs = UeService().getUes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addModule(ue: widget.ue);
          _nomModuleController.clear();
          _volumeHoraireController.clear();
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "UE ${widget.ue.nomUE} Listes des Modules",
                ),
                Expanded(
                    child: FutureBuilder(
                  future: futureModules,
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
                            const Text("Aucun module trouvé"),
                          ],
                        ),
                      );
                    } else {
                      List<Module> modules = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: 12,
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "Module",
                                    style: titleStyle,
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "Volume Horaire",
                                    style: titleStyle,
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "Crédit",
                                    style: titleStyle,
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "Action",
                                    style: titleStyle,
                                  )),
                                ],
                                rows: modules.map((modul) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      modul.nomModule,
                                    )),
                                    DataCell(Text(
                                      modul.volumeHoraire.toString(),
                                    )),
                                    DataCell(Text(
                                      modul.creditModule.toString(),
                                    )),
                                    DataCell(TextButton.icon(
                                        icon: const Icon(
                                          Icons.visibility,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeanceByModule(
                                                  module: modul,
                                                ),
                                              ));
                                        },
                                        label: Text(
                                          "Liste des séances",
                                          style: tableauElementStyle,
                                        )))
                                  ]);
                                }).toList()),
                          ),
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

  //Nouveau Module
  void addModule({required UE ue}) async {
    if (widget.ue.id == null) {
      print("Erreur l'UE est null");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nouveau Module"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Champ de Saisie Nom du Module
                  TextFormField(
                    controller: _nomModuleController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.file_copy_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        label: const Text("Nom du Module"),
                        hintText: "Ex:Anglais"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _volumeHoraireController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        label: const Text("Volume Horaire"),
                        hintText: "Ex:30 H"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le Volume Horaire";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            //Bouton annuler
            const ButtonAnnuler(),
            //Bouton Ajouter
            TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          //creation de l'objet Module avec les donnees entrees
                          final module = Module(
                              creditModule: selectedCredit ?? 0,
                              ue: widget.ue,
                              dateAjout: DateTime.now(),
                              nomModule: _nomModuleController.text,
                              volumeHoraire:
                                  int.parse(_volumeHoraireController.text));

                          //Envoyer les donnees
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            String moduleName = _nomModuleController.text;
                            bool exists =
                                await ModuleService().moduleExist(moduleName, ue.id!);
                            if (exists) {
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Un Module avec ce nom existe dèja ",
                                          style: TextStyle(color: Colors.white),
                                        )));
                              }
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                            await ModuleService().addModuleToUE(ue.id!, module);
                            if (mounted) {
                              setState(() {
                                futureModules = ModuleService().getModulesByUE(ue.id!);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text("Module ajouté avec succès !")),
                              );
                              await ModuleService().getModulesByUE(widget.ue.id!);
                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur : $e")),
                              );
                            }
                            print("Erreur:$e");
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        "Ajouter",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
          ],
        );
      },
    );
  }

  // Supprimer un Module
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Êtes-vous sûr de vouloir supprimer ce module ?"),
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
                ModuleService().deleteModule(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureModules =
                        ModuleService().getModulesByUE(widget.ue.id!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Module supprimé avec succès"),
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
}

/* 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_management_system/Provider/module_provider.dart';

class ModuleByUe extends ConsumerWidget {
  final int ueId;

  const ModuleByUe({Key? key, required this.ueId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(getModulesByUEProvider(ueId));

    return Scaffold(
      appBar: AppBar(title: Text('Modules de l\'UE $ueId')),
      body: modulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        
        error: (error, stackTrace) => Center(child: Text('Erreur : $error')),
        
        data: (modules) {
          return ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return ListTile(
                title: Text(module.nomModule),
                subtitle: Text('Crédits : ${module.creditModule}'),
              );
            },
          );
        },
      ),
    );
  }
}
 */
