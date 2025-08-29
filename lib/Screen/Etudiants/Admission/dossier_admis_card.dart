import 'package:flutter/material.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class DossierAdmisCard extends StatelessWidget {
  final void Function()? supprimer;
  final void Function()? modifier;
  final String nomEtudiant;
  final String remarque;
  final String status;
  final double noteTest;
  final double noteEntretien;

  const DossierAdmisCard({
    super.key,
    this.supprimer,
    this.modifier,
    required this.nomEtudiant,
    required this.remarque,
    required this.status,
    required this.noteEntretien,
    required this.noteTest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: myCardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Etudiant :",
                      style: titleStyle,
                    ),
                  ],
                ),
                Text(
                  nomEtudiant,
                  style: valueStyle,
                ),
              ],
            ),
            const SizedBox(height: 12),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.edit_note,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Note Test :",
                      style: titleStyle,
                    ),
                  ],
                ),
                Text(
                  noteTest.toString(),
                  style: valueStyle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.record_voice_over,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Note Entretien :",
                      style: titleStyle,
                    ),
                  ],
                ),
                Text(
                  noteEntretien.toString(),
                  style: valueStyle,
                ),
              ],
            ),
            const SizedBox(height: 12),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.av_timer, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Statut :",
                      style: titleStyle,
                    ),
                  ],
                ),
                Text(
                  status,
                  style: TextStyle(
                      color: getStatusColors(status),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
    
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Modifier button
                TextButton.icon(
                  onPressed: modifier,
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
                  onPressed: supprimer,
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

  Color getStatusColors(String status) {
    if (status.toLowerCase() == 'refuse') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
