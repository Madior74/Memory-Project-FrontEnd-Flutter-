import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:school_management_system/Screen/Document/model_document.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentService {
  final String baseUrl = AppConfig.baseUrl;

  //Uploader un document
  Future<Document> uploadDocument(File file, String nom, int etudiantId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/documents/upload'));

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['nom'] = nom;
    request.fields['etudiantId'] = etudiantId.toString();

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
   
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Document.fromJson(json.decode(responseData));
    } else {
      print("Erreur ${responseData}");
      throw Exception("Erreur lors de l'upload du document");
    }
  }

//Recuperer tous les documents d'un etudiants
  Future<List<Document>> getDocumentsByEtudiant(int etudiantId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response =
          await http.get(Uri.parse('$baseUrl/documents/etudiant/$etudiantId'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonList = json.decode(responseBody) as List;

        return jsonList.map((json) => Document.fromJson(json)).toList();
      } else {
        throw Exception(
            "Impossible de charger les documents : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Échec du chargement des documents : $e");
    }
  }

//Telecharger un document
// Télécharger un document
Future<String> downloadDocument(int documentId) async {
  final pref = await SharedPreferences.getInstance();
  final token = pref.getString('token');

  final response = await http.get(
    Uri.parse('$baseUrl/documents/$documentId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/document_$documentId';
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    
    return filePath;
  } else {
    throw Exception('Échec du téléchargement du document (code: ${response.statusCode})');
  }
}

  //supprimer un document
  Future<void> deleteDocument(int documentId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await http.delete(Uri.parse('$baseUrl/documents/$documentId'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de la suppression de la Filière');
    }
  }
}
