import 'package:flutter/material.dart';
import 'package:school_management_system/theme/colors.dart';

class PrinscriptionCard extends StatelessWidget {
  final String nomEudiant;
  final String filiereSouhaitee;
  final String niveauSouhaitee;
  final int? nbreDocument;
  final String statutAdmission;
  final void Function()? onTap;
  final void Function()? onDelete;

  const PrinscriptionCard({
    super.key,
    required this.nomEudiant,
    required this.filiereSouhaitee,
    required this.niveauSouhaitee,
    this.nbreDocument,
    required this.statutAdmission,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: myCardColor,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.person, "Étudiant", nomEudiant),
            const SizedBox(height: 10),
            _buildInfoRow(
                Icons.account_balance, "Filière souhaitée", filiereSouhaitee),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.stairs_sharp, "Niveau", niveauSouhaitee),
            const SizedBox(height: 10),

            // Documents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconLabel(Icons.library_books, "Documents"),
                Row(
                  children: [
                    Text(
                      "${nbreDocument ?? 0}",
                      style: TextStyle(
                        color: _getNumberColor(nbreDocument ?? 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("/3"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconLabel(Icons.mark_email_read, "Dossier"),
                Chip(
                  label: Text(
                    statutAdmission,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(statutAdmission),
                ),
              ],
            ),
            const Divider(height: 20),

            // Bouton Détial  et  supprimer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.info),
                  label: const Text("Détail"),
                  onPressed: onTap,
                ),

                //Bouton Supprimer
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text("Supprimer"),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconLabel(icon, label),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildIconLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade400, size: 20),
        const SizedBox(width: 5),
        Text(
          text + ":",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "incomplet":
        return Colors.red;
      case "complet":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Color _getNumberColor(int nbDoc) {
    return nbDoc < 3 ? Colors.red : Colors.green;
  }
}
