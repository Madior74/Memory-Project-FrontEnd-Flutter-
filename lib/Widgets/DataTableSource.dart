import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/detail_prinscrit.dart';


class InscriptionDataSource extends DataTableSource {
  final List<Inscription> inscriptions;
  final BuildContext context;

  InscriptionDataSource(this.inscriptions, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= inscriptions.length) return null;
    final inscription = inscriptions[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(inscription.etudiant!.nom ?? '')),
        DataCell(Text(inscription.etudiant!.prenom ?? '')),
        DataCell(Text(inscription.filiere!.nomFiliere)),
        DataCell(Text(inscription.niveau!.nomNiveau)),
        DataCell(Text(inscription.anneeAcademique!.nomAnnee ?? '')),
        DataCell(
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DetailEtudiant(etudiant: inscription.etudiant!),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inscriptions.length;

  @override
  int get selectedRowCount => 0;
}
