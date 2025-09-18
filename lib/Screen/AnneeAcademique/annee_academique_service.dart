import 'dart:convert';

import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnneeAcademiqueService {
  final String baseUrl = AppConfig.baseUrl;
  final http.Client _httpClient = http.Client();

  //Get
  Future<List<AnneeAcademique>> getSessions() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
     
      if (token == null) {
        throw Exception("Token non trouvé");
      }
      final response = await http.get(Uri.parse('$baseUrl/annees'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      print("📡 Réponse GET - Status: ${response.statusCode}");
      print("📡 Body: ${response.body}");

      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        List<AnneeAcademique> annees = List<AnneeAcademique>.from(
            jsonResponse.map((model) => AnneeAcademique.fromJson(model)));
        print("✅ ${annees.length} années récupérées");
        for (var annee in annees) {
          print("   - ${annee.nomAnnee}: active=${annee.active}, état=${annee.etat}");
        }
        return annees;
      } else {
        throw Exception(
            'Failed to load Année Academiques:${response.statusCode}');
      }
    } catch (e) {
      print("❌ Erreur lors de la récupération des années: $e");
      throw Exception("Erreur lors de la récupération des années: $e");
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

  //Activer une annee
  Future<void> activerAnnee(int anneeId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/activate/$anneeId'), // À adapter selon ton endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception("Erreur lors de l'activation de l'annee:");
      }
    } catch (e) {
      throw Exception("Erreur lors de l'activation de l'annee:$e");
    }
  }

  Future<void> toggleActivation(int anneeId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      print("🔄 Tentative d'activation/désactivation de l'année ID: $anneeId");
      print("🔗 URL: $baseUrl/annees/activate/$anneeId");

      final response = await _httpClient.put(
        Uri.parse('$baseUrl/annees/activate/$anneeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      print("📡 Réponse du serveur - Status: ${response.statusCode}");
      print("📡 Body: ${response.body}");
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Erreur HTTP: ${response.statusCode} - ${response.body}");
      }
      
    } catch (e) {
      print("❌ Erreur lors du changement d'état : $e");
      throw Exception("Erreur lors du changement d'état : $e");
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

 
}
