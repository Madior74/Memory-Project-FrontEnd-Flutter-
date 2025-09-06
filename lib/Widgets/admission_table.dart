import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/nouvelle_inscriptions.dart';

class DossierTable extends StatelessWidget {
  final List<DossierAdmission> dossiers;

  const DossierTable({super.key, required this.dossiers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        border: TableBorder.all(color: Colors.grey.shade300),
        columns: const [
          DataColumn(label: Text("Nom complet")),
          DataColumn(label: Text("Statut")),
          DataColumn(label: Text("Remarque")),
          DataColumn(label: Text("Actions")),
        ],
        rows: dossiers.map((dossier) {
          final statut = dossier.status.toUpperCase();
          return DataRow(
            cells: [
              DataCell(
                  Text("${dossier.candidat!.prenom} ${dossier.candidat!.nom}")),
              DataCell(Text(statut)),
              DataCell(Text(dossier.remarque ?? "")),
              DataCell(
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "modifier") {
                      // logiques de modification
                    } else if (value == "supprimer") {
                      // confirmation suppression
                    } else if (value == "achever") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NouvelleInscriptions(
                            dossierAdmission: dossier,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: "modifier",
                        child: Text("Modifier"),
                      ),
                      const PopupMenuItem(
                        value: "supprimer",
                        child: Text("Supprimer"),
                      ),
                      if (statut == "VALIDE")
                        const PopupMenuItem(
                          value: "achever",
                          child: Text("Achever inscription"),
                        ),
                    ];
                  },
                  child: const Icon(Icons.more_vert),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
