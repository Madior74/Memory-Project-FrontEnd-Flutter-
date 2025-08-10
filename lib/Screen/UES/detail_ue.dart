import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';

class DetailUE extends StatefulWidget {
  final UE ue;
  const DetailUE({super.key, required this.ue});

  @override
  State<DetailUE> createState() => _DetailUEState();
}

class _DetailUEState extends State<DetailUE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "DETAILS DE L'UE ${widget.ue.nomUE} ",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildInfoRow(Icons.discount, "Nom de l'UE", widget.ue.nomUE),
            buildInfoRow(Icons.code, "Code de l'UE", widget.ue.codeUE),
          ],
        ),
      ),
    );
  }
}

Widget buildInfoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
