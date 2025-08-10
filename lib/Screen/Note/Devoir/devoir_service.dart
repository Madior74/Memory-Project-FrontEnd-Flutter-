import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Note/Devoir/model_devoir.dart';

class DevoirService {
  static const String baseUrl = "http://localhost:9000/devoirs";

  Future<List<Devoir>> getAllDevoir() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("Recuperation des devoirs");
    print(response.statusCode);
    print(response.body);
    print(response);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((note) => Devoir.fromJson(note)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des devoirs");
    }
  }

  // Ajouter une note de devoir
  Future<Map<String, dynamic>> createdevoir(
      {required Map<String, dynamic> devoir}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(devoir),
      );

      print("Creation  d'une note devoirs");
      print(response.statusCode);
      print(response.body);
      print(response);
      print(devoir);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create devoir: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating devoir: $e');
    }
  }

  // Récupérer les notes de devoir d'un étudiant dans un module
  Future<List<Devoir>> getDevoirNotes(int etudiantId, int moduleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/devoirs/etudiant/$etudiantId/module/$moduleId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Devoir.fromJson(json)).toList();
    } else {
      throw Exception('Échec de la récupération des devoirs');
    }
  }

  // Calculer la moyenne finale
  Future<double> calculateFinalAverage(int etudiantId, int moduleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes/moyenne/etudiant/$etudiantId/module/$moduleId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body).toDouble();
    } else {
      throw Exception('Échec du calcul de la moyenne');
    }
  }

  //delete Devoir
  Future<void> deleteDevoir(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(" supression d'une Note");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression de la note');
    }
  }
}
