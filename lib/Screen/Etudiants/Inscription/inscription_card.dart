import 'package:flutter/material.dart';
import 'package:school_management_system/theme/my_styles.dart';



class InscriptionTableRow extends StatelessWidget {
  final String nomEtudiant;
  final String nomFiliere;
  final String nomNiveau;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const InscriptionTableRow({
    super.key,
    required this.nomEtudiant,
    required this.nomFiliere,
    required this.nomNiveau,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(nomEtudiant),
          ),
          Expanded(
            flex: 2,
            child: Text(nomFiliere),
          ),
          Expanded(
            flex: 1,
            child: Text(nomNiveau),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: Colors.indigo),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
