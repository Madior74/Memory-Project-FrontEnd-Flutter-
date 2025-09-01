import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';
import 'package:school_management_system/Screen/Modules/module_by_ue.dart';
import 'package:school_management_system/Screen/UES/ue_service.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class ListeDesUES extends StatefulWidget {
  const ListeDesUES({super.key});

  @override
  State<ListeDesUES> createState() => _ListeDesUESState();
}

class _ListeDesUESState extends State<ListeDesUES> {
  late Future<List<UE>> futuresUES;

  late List<Niveau> niveaux = [];

  int? selectedFiliere;
  int? selectedNiveau;
  int? selectedSemestre;
  late List<Niveau> filteredNiveaux = [];
  late List<Niveau> allNiveaux = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futuresUES = UeService().getUes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackgroound,
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Liste des UE",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        futuresUES =
                            UeService().getUes(); // Recharger les données
                      });
                    },
                    child: FutureBuilder<List<UE>>(
                      future: futuresUES,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          print(
                              "Error de recuperation des Semestres:${snapshot.error}");
                          return Center(
                            child: Text("Erreur: ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Aucune UE trouvée"),
                          );
                        } else {
                          List<UE> items = snapshot.data!;
                          return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                UE ue = items[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 3,
                                    child: ListTile(
                                      title: Text(ue.nomUE),
                                      titleTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                      subtitle: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Nombre de Crédit:",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                "${ue.getTotalCredits()}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //Modifiere
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.info,
                                                color: Colors.blue.shade800,
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          //supprimer
                                          IconButton(
                                            onPressed: () {
                                              _confirmDelete(items[index].id!);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ModuleByUe(
                                              ue: ue,
                                            ),
                                          ),
                                        );

                                        if (result == true) {
                                          setState(() {
                                            futuresUES = UeService()
                                                .getUes(); // Recharge les données
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Êtes-vous sûr de vouloir supprimer cette UE ?"),
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
                    futuresUES = UeService().getUes();
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
}
