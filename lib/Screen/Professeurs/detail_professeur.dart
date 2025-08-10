import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Professeurs/update_professeur.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';
import 'package:school_management_system/Screen/Specialite/specialiteService.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/theme/colors.dart';

class ProfesseurDetails extends StatefulWidget {
  final Professeur professeur;

  const ProfesseurDetails({super.key, required this.professeur});

  @override
  State<ProfesseurDetails> createState() => _ProfesseurDetailsState();
}

class _ProfesseurDetailsState extends State<ProfesseurDetails> {
  List<int> _selectedSpecialite = [];
  List<Specialite> _splt = [];

  Future<void> _loadSpecialite() async {
    try {
      final Specialites = await SpecialiteService().getAllSpecialites();
      setState(() {
        _splt = Specialites;
      });
    } catch (e) {
      print("Erreur lors recuperation des Specialites $e");
      throw Exception("Erreur lors de la recupération des Specialites");
    }
  }

  Future<void> _loadExistingSpecialitesForProf(int profId) async {
    try {
      final List<Specialite> existing =
          await ProfesseurService().getSpecialitesByProfesseurId(profId);
      setState(() {
        _selectedSpecialite = existing.map((s) => s.id!).toList();
      });
    } catch (e) {
      print("Erreur lors du chargement des spécialités existantes : $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSpecialite();
    _loadExistingSpecialitesForProf(widget.professeur.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myDrawerColol,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Professeur ${widget.professeur.prenom} ${widget.professeur.nom}',
          style: const TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: myDrawerColol,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      "Modifier",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateProfesseur(professeur: widget.professeur),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Section : Photo
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        widget.professeur.imagePath.startsWith('http')
                            ? NetworkImage(widget.professeur.imagePath)
                            : AssetImage(widget.professeur.imagePath)
                                as ImageProvider,
                  ),
                ],
              ),
            ),

            // Section : Informations personnelles
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations Personnelles',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: const Row(
                        children: [
                          Text('Prenom'),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Nom")
                        ],
                      ),
                      subtitle: Text(
                          '${widget.professeur.prenom} ${widget.professeur.nom}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.green),
                      title: const Text('Adresse'),
                      subtitle: Text(widget.professeur.adresse),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.orange),
                      title: const Text('Téléphone'),
                      subtitle: Text(widget.professeur.telephone),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.red),
                      title: const Text('Email'),
                      subtitle: Text(widget.professeur.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cake, color: Colors.purple),
                      title: const Text('Date de Naissance'),
                      subtitle: Text(widget.professeur.dateDeNaissance!
                          .toLocal()
                          .toString()
                          .split(' ')[0]),
                    ),
                    ListTile(
                      leading: const Icon(Icons.male, color: Colors.indigo),
                      title: const Text('Sexe'),
                      subtitle: Text(widget.professeur.sexe),
                    ),
                    ListTile(
                      leading: const Icon(Icons.public, color: Colors.teal),
                      title: const Text('Pays de Naissance'),
                      subtitle: Text(widget.professeur.paysDeNaissance),
                    ),
                  ],
                ),
              ),
            ),

            // Section : Informations académiques
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations Académiques',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.credit_card, color: Colors.blueGrey),
                      title: const Text('CNI'),
                      subtitle: Text(widget.professeur.cni.toString()),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.idCard,
                          color: Colors.deepOrange),
                      title: const Text('INE'),
                      subtitle: Text(widget.professeur.ine.toString()),
                    ),
                  ],
                ),
              ),
            ),

            // Section : Modules enseignés
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Diplômes ou Spécialités',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1),
                    if ((widget.professeur.specialites?.isNotEmpty ?? false))
                      ...widget.professeur.specialites!
                          .map((speci) => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(fixDoubleEncoding(speci.nom!)),
                                      IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _confirmerSuppression(
                                                widget.professeur.id!,
                                                speci.id!);

                                            setState(() {
                                              _loadExistingSpecialitesForProf(
                                                  widget.professeur.id!);
                                            });
                                          }),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ))
                          .toList()
                    else
                      const Text('Aucune spécialité assignée'),
                    //Bouton Ajouter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: myDrawerColol,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 17,
                            ),
                            label: Text(
                              "Ajouter",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            onPressed: () {
                              ajouterSpecialite(widget.professeur);
                              setState(() {
                                _loadExistingSpecialitesForProf(
                                    widget.professeur.id!);
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Ajouter un module
  void ajouterSpecialite(Professeur professeur) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setstate) {
            return AlertDialog(
              title: Text("Ajouter/Modifier Spécialités"),
              content: SingleChildScrollView(
                child: Column(
                  children: _splt.map((splt) {
                    return CheckboxListTile(
                      title: Text(fixDoubleEncoding(splt.nom!)),
                      value: _selectedSpecialite.contains(splt.id),
                      onChanged: (bool? selected) {
                        setstate(() {
                          if (selected == true) {
                            _selectedSpecialite.add(splt.id!);
                          } else {
                            _selectedSpecialite.remove(splt.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text("Annuler"),
                ),
                TextButton(
                  onPressed: () async {
                    // Envoyer les nouvelles spécialités au backend
                    await ProfesseurService().addSpecialiteToProfesseur(
                        professeur.id!, _selectedSpecialite.toList());
                    // Rafraîchir l'affichage
                    await _loadSpecialite();
final updatedSpecialites = await ProfesseurService().getSpecialitesByProfesseurId(professeur.id!);
setState(() {
  widget.professeur.specialites = updatedSpecialites;
  _selectedSpecialite = updatedSpecialites.map((s) => s.id!).toList();
});
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Spécialités ajoutées avec succès"),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Enregistrer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Fonction de Conversion
  String fixDoubleEncoding(String text) {
    return utf8.decode(text.runes.toList());
  }

  void _confirmerSuppression(int profId, int specialiteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              const Text("Voulez-vous Vraiment retirer cette Specialité  ??"),
          actions: [
            const ButtonAnnuler(),
            TextButton(
                onPressed: () async{
                  ProfesseurService()
                      .removeSpecialiteFromProfesseur(profId, specialiteId)
                      .then((_) async {
                  final updatedSpecialites = await ProfesseurService().getSpecialitesByProfesseurId(profId);
setState(() {
  widget.professeur.specialites = updatedSpecialites;
  _selectedSpecialite = updatedSpecialites.map((s) => s.id!).toList();
});


                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Specialité retiré avec Succès",
                          style: TextStyle(color: Colors.white),
                        )));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Erreur : $error")),
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Supprimer"))
          ],
        );
      },
    );
  }
 
}
