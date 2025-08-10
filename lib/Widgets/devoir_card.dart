import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class DevoirCard extends StatelessWidget {
  final String moduleName;
  final String studentName;
  final String professorName;
  final double? note;
  final VoidCallback onDelete;

  const DevoirCard({
    Key? key,
    required this.moduleName,
    required this.studentName,
    required this.professorName,
    this.note,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightGreenAccent,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          "Module: $moduleName",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Étudiant: $studentName | Prof: $professorName",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "Devoir:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${note?.toStringAsFixed(2) ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: note! >= 9 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
