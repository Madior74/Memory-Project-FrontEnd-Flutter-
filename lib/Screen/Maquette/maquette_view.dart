import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Maquette/MaquetteSemestreDTO.dart';

class MaquetteView extends StatefulWidget {
  final String semestreId;

  const MaquetteView({Key? key, required this.semestreId}) : super(key: key);

  @override
  _MaquetteViewState createState() => _MaquetteViewState();
}

class _MaquetteViewState extends State<MaquetteView> {
  late Future<MaquetteSemestre> _maquetteFuture;

  @override
  void initState() {
    super.initState();
    _maquetteFuture = fetchMaquette(widget.semestreId);
  }

  Future<MaquetteSemestre> fetchMaquette(String semestreId) async {
    final response = await http.get(
      Uri.parse('http://localhost:9000/api/maquettes/semestre/$semestreId'),
    );

    print("Récupération de la maquette...");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Convertir la réponse JSON en un objet Map<String, dynamic>
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      // Mapper directement l'objet JSON à votre modèle MaquetteSemestre
      return MaquetteSemestre.fromJson(jsonResponse);
    } else {
      throw Exception('Échec du chargement de la maquette');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maquette Semestre'),
      ),
      body: FutureBuilder<MaquetteSemestre>(
        future: _maquetteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Erreur : ${snapshot.error}");
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final maquette = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  //Column pour les Codes UEs
                  Column(
                    children: [
                      //Code des UES
                      Text("Code UE"),
                      SizedBox(
                        height: 15,
                      ),
                      Text(maquette.ues[0].codeUE),
                    ],
                  ),

                  //SizedBox pour l'espacement
                  SizedBox(
                    width: 20,
                  ),

                  //Column pour les Noms UEs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        //Nom des UES
                        Text("Nom UE"),
                        SizedBox(
                          height: 15,
                        ),
                        Text(maquette.ues[0].nomUE),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  //Column pour afficher les modules de L'UE
                  Column(
                    children: [
                      //Nom des modules
                      Text("Nom Module"),
                      SizedBox(
                        height: 15,
                      ),
                      // Afficher les noms des modules de l'UE
                      Column(
                        children: [
                          Row(
                            spacing: 10,
                            children: maquette.ues[0].modules
                                .map((module) => Text(
                                      module.nomModule,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            );
            //
            // SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       ListTile(
            //         title: Text('Filière'),
            //         subtitle: Text(maquette.filiere),
            //       ),
            //       ListTile(
            //         title: Text('Niveau'),
            //         subtitle: Text(maquette.niveau.nomNiveau),
            //       ),
            //       ListTile(
            //         title: Text('Numéro Semestre'),
            //         subtitle: Text(maquette.nomSemestre),
            //       ),
            //       ListTile(
            //         title: Text('Volume Horaire Total'),
            //         subtitle: Text('${maquette.totalVolumeHoraire} heures'),
            //       ),
            //       ListTile(
            //         title: Text('Total Crédits'),
            //         subtitle: Text('${maquette.totalCredits} crédits'),
            //       ),
            //       ListTile(
            //         title: Text('Nombre de Modules'),
            //         subtitle: Text('${maquette.nombreModules} modules'),
            //       ),
            //       ...maquette.ues
            //           .map((ue) => ExpansionTile(
            //                 title: Text(ue.nomUE),
            //                 subtitle: Text('Code UE: ${ue.codeUE}'),
            //                 children: ue.modules
            //                     .map((module) => ListTile(
            //                           title: Text(module.nomModule),
            //                           subtitle: Text(
            //                               '${module.volumeHoraire} heures | ${module.creditModule} crédits'),
            //                         ))
            //                     .toList(),
            //               ))
            //           .toList(),
            //     ],
            //   ),
            // );
          } else {
            return Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }
}
