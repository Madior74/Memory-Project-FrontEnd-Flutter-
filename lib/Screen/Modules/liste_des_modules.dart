import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Modules/moduleService.dart';
import 'package:school_management_system/Screen/Seance/seance_by_module.dart.dart';
import 'package:school_management_system/Screen/evaluation/evaluation_by_module.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class ListeDesModules extends StatefulWidget {
  const ListeDesModules({super.key});

  @override
  State<ListeDesModules> createState() => _ListeDesModulesState();
}

class _ListeDesModulesState extends State<ListeDesModules> {
  late Future<List<Module>> futureModules;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureModules = ModuleService().getAllModules();
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
        onPressed: () {},
      ),
      body: Row(
        children: [
          const MyDrawer(),
          Expanded(
            child: Column(
              children: [
                const MyAppbar(title: "Liste des Modules"),
                Expanded(
                    child: FutureBuilder<List<Module>>(
                  future: futureModules,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erreur :${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucun Module Trouvé",
                          style: TextStyle(color: Colors.grey),
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
                                    "UE",
                                    style: titleStyle,
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "Action",
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
                                    DataCell(Text(
                                      modul.nomUE ?? "inconnu",
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
                                          "Gestion des séances",
                                          style: tableauElementStyle,
                                        ))),
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
                                                    EvaluationByModule(
                                                  module: modul,
                                                
                                                ),
                                              ));
                                        },
                                        label: Text(
                                          "Gestion des Evalution",
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
          )
        ],
      ),
    );
  }
}
