import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/theme/my_styles.dart';
import 'package:diacritic/diacritic.dart';

class AnneeAcademiqueCard extends StatelessWidget {
  final AnneeAcademique annee;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AnneeAcademiqueCard({
    Key? key,
    required this.annee,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 12,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Title and Year
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Année Académique", style: titleStyle),
                Text(
                  annee.nomAnnee,
                  style: TextStyle(
                    color: Colors.indigo.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date début
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date Début", style: titleStyle),
                Text(
                  '${annee.dateDebut!.day.toString().padLeft(2, '0')}/${annee.dateDebut!.month.toString().padLeft(2, '0')}/${annee.dateDebut!.year}',
                  style: valueStyle,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date fin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date Fin", style: titleStyle),
                Text(
                  '${annee.dateFin!.day.toString().padLeft(2, '0')}/${annee.dateFin!.month.toString().padLeft(2, '0')}/${annee.dateFin!.year}',
                  style: valueStyle,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // État
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status", style: titleStyle),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: getEtatColor(annee.etat).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    annee.etat,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Modifier button
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: Colors.indigo),
                  label: Text(
                    "Modifier",
                    style: TextStyle(color: Colors.indigo),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),

                const SizedBox(width: 12),

                // Supprimer button
                TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    "Supprimer",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getEtatColor(String etat) {
    final normalized =
        removeDiacritics(etat.toLowerCase()); // ex: "À venir" → "a venir"
    switch (normalized) {
      case "a venir":
        return Colors.blue;
      case "en cours":
        return Colors.green;
      case "terminee":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
