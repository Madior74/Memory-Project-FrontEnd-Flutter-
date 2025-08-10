import 'package:flutter/material.dart';
import 'package:school_management_system/theme/my_styles.dart';

class EtudiantCard extends StatelessWidget {
  final String nomEudiant;
  final String filiereSouhaitee;
  final String niveauSouhaitee;
  final int? nbreDocument;
  final String statutAdmission;
  final void Function()? onTap;

  const EtudiantCard({
    super.key,
    required this.nomEudiant,
    required this.filiereSouhaitee,
    required this.niveauSouhaitee,
    this.nbreDocument,
    required this.statutAdmission,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap, // Naviguer vers la page de détails
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom de l'étudiant
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue.shade200),
                      SizedBox(width: 5),
                      Text("Étudiant:", style: titleStyle),
                    ],
                  ),
                  Text(nomEudiant, style: valueStyle),
                ],
              ),
              SizedBox(height: 10),

              // Filière souhaitée
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.blue.shade200),
                      SizedBox(width: 5),
                      Text(
                        "Filière souhaitée:",
                        style: titleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(filiereSouhaitee, style: valueStyle),
                ],
              ),
              SizedBox(height: 10),

              // Niveau souhaité
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stairs_sharp, color: Colors.blue.shade200),
                      SizedBox(width: 5),
                      Text("Niveau:", style: titleStyle),
                    ],
                  ),
                  Text(niveauSouhaitee, style: valueStyle),
                ],
              ),
              SizedBox(height: 10),

              // Nombre de documents
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.library_books, color: Colors.blue.shade200),
                      SizedBox(width: 5),
                      Text("Documents:", style: titleStyle),
                    ],
                  ),
                  Row(
                    children: [
                      Text("$nbreDocument",
                          style: TextStyle(
                              color: _getNumberColor(nbreDocument ?? 0))),
                      Text("/3"),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),

              // Statut d'admission
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mark_email_read,
                        color: Colors.blue.shade200,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Dossier", style: titleStyle),
                    ],
                  ),
                  Chip(
                      label: Text(statutAdmission),
                      backgroundColor: _getStatusColor(statutAdmission)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//Couleur selon le Status
  Color _getStatusColor(String status) {
    switch (status) {
      case "Incomplet":
        return Colors.red;

      case "complet":
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  //Couleur selon  le nombre de document
  Color _getNumberColor(int nbDoc) {
    if (nbDoc < 3) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
