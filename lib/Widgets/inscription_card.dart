import 'package:flutter/material.dart';
import 'package:school_management_system/theme/my_styles.dart';

// class InscriptionCard extends StatelessWidget {
//   final String nomFiliere;
//   final String nomNiveau;
//   final String nomEtudiant;
//   final void Function()? onEdit;
//   final void Function()? detail;
//   final void Function()? onDelete;
//   const InscriptionCard(
//       {super.key,
//       required this.nomFiliere,
//       required this.nomNiveau,
//       required this.nomEtudiant,
//       this.onDelete,
//       this.detail,
//       this.onEdit});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: detail,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Etudiant:",
//                     style: titleStyle,
//                   ),
//                   Text(nomEtudiant, style: valueStyle),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Filiere:",
//                     style: titleStyle,
//                   ),
//                   Text(
//                     nomFiliere,
//                     style: valueStyle,
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Niveau:",
//                     style: titleStyle,
//                   ),
//                   Text(nomNiveau, style: valueStyle)
//                 ],
//               ),

//               SizedBox(
//                 height: 15,
//               ),
//               // Buttons Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Modifier button
//                   TextButton.icon(
//                     onPressed: onEdit,
//                     icon: Icon(Icons.edit, color: Colors.indigo),
//                     label: Text(
//                       "Modifier",
//                       style: TextStyle(color: Colors.indigo),
//                     ),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.indigo.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 10),
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   // Supprimer button
//                   TextButton.icon(
//                     onPressed: onDelete,
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     label: Text(
//                       "Supprimer",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.red.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 10),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
