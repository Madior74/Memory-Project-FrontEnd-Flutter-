import 'dart:convert';

import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/services/config.dart';
import 'package:school_management_system/services/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnneeAcademiqueService {
  final String baseUrl = AppConfig.baseUrl;

  //Get
  Future<List<AnneeAcademique>> getSessions() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      print("token:$token");
      if (token == null) {
        throw Exception("Token non trouvé");
      }
      final response = await http.get(Uri.parse('$baseUrl/annees'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        return List<AnneeAcademique>.from(
            jsonResponse.map((model) => AnneeAcademique.fromJson(model)));
      } else {
        throw Exception(
            'Failed to load Année Academiques:${response.statusCode}');
      }
    } catch (e) {
      print("Erreur lors de la Mise a jour des Rôles");
      throw Exception("Erreur lors de la Mise a jour des Rôles");
    }
  }

  //Create
  Future<AnneeAcademique> createSession(AnneeAcademique session) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      if (token == null) {
        throw Exception("Token non trouvé");
      }
      final response = await http.post(
        Uri.parse('$baseUrl/annees/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(session.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AnneeAcademique.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de la  mise a jour : ${response.body}');
      }
    } catch (e) {
      throw Exception("Erreur lors de la Mise a jour des Rôles");
    }
  }

  //Mise a jour
  Future<AnneeAcademique> updateSession(int id, AnneeAcademique annee) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      if (token == null) {
        throw Exception("Token non trouvé");
      }
      final response = await http.put(
        Uri.parse('$baseUrl/annees/update/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(annee.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AnneeAcademique.fromJson(
            json.decode(response.body)); // Parse la réponse en objet Session
      } else {
        throw Exception('Échec de l\'ajout de la session : ${response.body}');
      }
    } catch (e) {
      throw Exception("Erreur lors de la Mise a jour des Rôles");
    }
  }

  //Delete
  Future<void> deleteSession(int id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.delete(
        Uri.parse('$baseUrl/annees/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Échec de la suppression de la session');
      }
    } on Exception catch (e) {
      throw Exception("Erreur lors de la suppression de l'année $e");
    }
  }

//Exist
  Future<bool> anneeExists(String nomAnnee) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/annees/exists?nomAnnee=$nomAnnee'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      } else {
        throw Exception(
            'Erreur lors de la vérification de de lannee${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la vérification des lannee');
    }
  }

  //Annee En Cours
  // Future<AnneeAcademique> getAnneeEnCours() async {
  //   final pref = await SharedPreferences.getInstance();
  //   final token = pref.getString('token');
  //   final response = await http.get(Uri.parse('$baseUrl/en-cours'), headers: {
  //     "Authorization": "Bearer $token",
  //   });
  //   if (response.statusCode == 200) {
  //     return AnneeAcademique.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load current academic year');
  //   }
  // }

  Future<AnneeAcademique> getAnneeEnCours() async {
    final response = await HttpInterceptor.request(
      "GET",
      "$baseUrl/annees/en-cours",
    );

    if (response.statusCode == 200) {
      return AnneeAcademique.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current academic year');
    }
  }
}
