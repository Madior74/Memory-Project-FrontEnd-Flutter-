import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_management_system/Screen/Document/document_screen.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/gestion_des_admissions.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/update_prinscrit.dart';
import 'package:school_management_system/Widgets/image_help.dart';
import 'package:school_management_system/theme/colors.dart';

class DetailEtudiant extends StatelessWidget {
  final Candidat etudiant;

  const DetailEtudiant({super.key, required this.etudiant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myDrawerColol,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextButton.icon(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 25,
                  ),
                  label: Text(
                    "Modifier",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdatePrinscription(etudiant: etudiant),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
        title: Text(
          'Etudiant ${etudiant.prenom} ${etudiant.nom}',
          style: const TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //Pour la photo

            CircleAvatar(
              radius: 90,
              backgroundImage: ImageHelper.getImageProvider(etudiant.imagePath),
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
                      subtitle: Text('${etudiant.prenom} ${etudiant.nom}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.green),
                      title: const Text('Adresse'),
                      subtitle: Text(
                          utf8.decode(etudiant.adresse.toString().codeUnits)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.orange),
                      title: const Text('Téléphone'),
                      subtitle: Text(etudiant.telephone!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.red),
                      title: const Text('Email'),
                      subtitle: Text(etudiant.email ?? 'niang@gmail.com'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cake, color: Colors.purple),
                      title: const Text('Date de Naissance'),
                      subtitle: etudiant.dateDeNaissance != null
                          ? Text(etudiant.dateDeNaissance!
                              .toLocal()
                              .toString()
                              .split(' ')[0])
                          : const Text(
                              'Date non spécifiée'), // Ou un message par défaut
                    ),
                    ListTile(
                      leading: const Icon(Icons.male, color: Colors.indigo),
                      title: const Text('Sexe'),
                      subtitle: Text(etudiant.sexe!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.public, color: Colors.teal),
                      title: const Text('Pays de Naissance'),
                      subtitle: Text(etudiant.paysDeNaissance!),
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
                      subtitle: Text(etudiant.cni.toString()),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.idCard,
                          color: Colors.deepOrange),
                      title: const Text('INE'),
                      subtitle: Text(etudiant.ine.toString()),
                    ),
                  ],
                ),
              ),
            ),

            //
            // Section : Actions
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
                      'Actions',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1),

                    // Gérer les documents
                    ListTile(
                      leading:
                          const Icon(Icons.upload_file, color: Colors.blue),
                      title: const Text('Gérer les documents'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Documentscreen(
                              student: etudiant,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // Gérer l'admission
                    ListTile(
                      leading: const Icon(Icons.assignment_turned_in,
                          color: Colors.green),
                      title: const Text('Gérer l\'admission'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GestionDesAdmissions(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
