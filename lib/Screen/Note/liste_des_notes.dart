import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Note/Devoir/model_devoir.dart';
import 'package:school_management_system/Screen/Note/nouveau_note.dart';
import 'package:school_management_system/Screen/Note/Devoir/devoir_service.dart';
import 'package:school_management_system/Widgets/devoir_card.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final DevoirService devoirService = DevoirService();
  late Future<List<Devoir>> futureNotes;

  @override
  void initState() {
    super.initState();
    futureNotes = DevoirService().getAllDevoir();
  }

  Future<double?> _showNoteDialog() async {
    double? value;
    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Entrer la note"),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (val) => value = double.tryParse(val),
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Valider"),
              onPressed: () => Navigator.pop(context, value),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNoteScreen(),
              ));
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyAppbar(
                  title: "Liste des Notes ",
                ),
                Expanded(
                  child: FutureBuilder<List<Devoir>>(
                    future: futureNotes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Erreur: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("Aucune note disponible"));
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisExtent: 150, maxCrossAxisExtent: 600),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Devoir note = snapshot.data![index];
                            return DevoirCard(
                              note: note.note,
                              moduleName: note.courseModule.nomModule,
                              studentName: note.etudiant.prenom!,
                              professorName: note.professeur.prenom,
                              onDelete: () => _confirmDelete(note.id!),
                            );
                            //
                            // Card
                            //   child: ListTile(
                            //     title: Text(
                            //         "Module: ${note.courseModule?.nomModule ?? 'N/A'}"),
                            //     subtitle: Text(
                            //       "Étudiant: ${note.etudiant!.nom} | Prof: ${note.professeur!.nom}\n"
                            //       "Devoir: ${note.note ?? 'N/A'} ",
                            //     ),
                            //     trailing: Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         // IconButton(
                            //         //   icon: Icon(Icons.edit, color: Colors.blue),
                            //         //   onPressed: () => _updateNoteDevoir(note.id),
                            //         // ),
                            //         IconButton(
                            //           icon:
                            //               Icon(Icons.delete, color: Colors.red),
                            //           onPressed: () => _confirmDelete(note.id!),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Supprimer une note
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette note ?"),
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
                DevoirService().deleteDevoir(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureNotes = DevoirService().getAllDevoir();
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
