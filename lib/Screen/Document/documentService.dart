import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:school_management_system/Screen/Document/model_document.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentService {
  final String baseUrl = 'http://192.168.1.15:9000/api/admin/documents';

  Future<void> uploadDocument(File file, String nom, int etudiantId) async {
    var uri = Uri.parse(
        'http://your-server-address/upload'); // Remplace 'your-server-address'

    var request = http.MultipartRequest('POST', uri)
      ..fields['nom'] = nom
      ..fields['etudiantId'] = etudiantId.toString()
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Document uploaded successfully');
    } else {
      print('Failed to upload document. Status code: ${response.statusCode}');
    }
  }

////
  Future<List<Document>> getDocumentsByEtudiant(int etudiantId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl/etudiant/$etudiantId'), headers: {
      "Authorization": "Bearer $token",
    });
    print("Recuperation des documents");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body); // Décodage JSON
      return data
          .map((json) => Document.fromJson(json))
          .toList(); // Conversion en objets `Document`
    } else {
      throw Exception(
          'Failed to load documents'); // Lance une exception en cas d'erreur
    }
  }

  Future<void> downloadDocument(int documentId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/$documentId'), headers: {
      "Content-Disposition":
          "attachment", // Indique que c'est un téléchargement
    });

    if (response.statusCode == 200) {
      // Sauvegarde le fichier localement
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/document_$documentId';
      File file = File(filePath);
      await file
          .writeAsBytes(response.bodyBytes); // Écriture des octets du fichier
      print("File saved at $filePath");
    } else {
      throw Exception(
          'Failed to download document'); // Lance une exception en cas d'erreur
    }
  }
}
