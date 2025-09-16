import 'dart:convert';

import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiliereService {
  final String baseUrl = AppConfig.baseUrl;

  //Get
  Future<List<Filiere>> getFilieres() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(Uri.parse('$baseUrl/filieres'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        List<dynamic> jsonResponse = json.decode(response.body);

        // Convertissez chaque objet JSON en une instance de Filiere
        return jsonResponse
            .map((filiere) => Filiere.fromJson(filiere as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des filières  :${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur:$e');
    }
  }

  //Filiere by Id
  Future<Filiere?> getFiliereById(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Filiere.fromJson(json);
    } else {
      // Gérer l'erreur ou retourner null
      return null;
    }
  }

  //Create  Auto
  Future<Filiere> createFiliere(Filiere filiere) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.post(
        Uri.parse('$baseUrl/filieres/auto'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(filiere.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Filiere.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception(
            'Echec lors de l\'ajout  de la Filiere :${response.body}');
      }
    } on Exception catch (e) {
      throw Exception("Erreur:$e");
    }
  }

  //Delete

  Future<void> deleteFiliere(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/filieres/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de la suppression de la Filière');
    }
  }

//Exist
  Future<bool> filiereExists(String filiereName) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/filieres/exists?nomFiliere=$filiereName'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      } else {
        throw Exception(
            'Erreur lors de la vérification de filière${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la vérification des filières');
    }
  }

  //Nombre d'etudianta
  Future<int> getEtudiantsCountByFiliereId(int filiereId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
        Uri.parse('$baseUrl/filieres/$filiereId/etudiants/count'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 200) {
      return json.decode(response.body)['count'];
    } else {
      throw Exception('Erreur lors de la récupération du nombre d\'étudiants');
    }
  }
}
