import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialiteService {
  final String baseUrl = AppConfig.baseUrl;
  //get All Specialites
  Future<List<Specialite>> getAllSpecialites() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/specialites'), headers: {
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jResponse = json.decode(utf8.decode(response.bodyBytes));
      return jResponse.map((model) => Specialite.fromJson(model)).toList();
    } else {
      throw Exception('Echec de la recupération des specialiés');
    }
  }

  //Nouvelle specialite
  Future<void> addSpecialite(Specialite specialite) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/specialites/save'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'nom': specialite.nom,
        'description': specialite.description,
      }),
    );
  
    if (response.statusCode == 201 || response.statusCode == 200) {
    } else if (response.statusCode == 409) {
      throw Exception('This niveau already exists in the filière');
    } else {
      throw Exception('Failed to add niveau');
    }
  }

  //Mettre a jour
  //Nouvelle specialite
  Future<void> updateSpecialite(int id, Specialite specialite) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/specialites/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode(specialite.toJson()),
    );
    print("Mis a jour dune speci de l'API");
    print(response.body);
    print("status code");
    print(response.statusCode);

    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Niveau added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('Erreur de Conflit ');
    } else {
      throw Exception('Echec lors de la mise à jour de la spécialité');
    }
  }
  //Recuperer les specialites par

  Future<List<Specialite>> getSpecialiteByDomaine(int domaineId) async {
    final url = Uri.parse('$baseUrl/specialites/domaine/$domaineId');
    print('URL de l\'API : $url');

    final response = await http.get(url);
    print('Réponse API : ${response.body}');
    print(response);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((speci) => Specialite.fromJson(speci)).toList();
    } else {
      throw Exception('Failed to load Specialites');
    }
  }

  //Delete
  Future<void> deleteSpecialite(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/specialites/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(" supression de la salle");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression ');
    }
  }

  Future<bool> specialiteExist(String nom) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(Uri.parse('$baseUrl/specialites?nom=$nom'), headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        List<dynamic> specs = json.decode(utf8.decode(response.bodyBytes));
        return specs.any((speci) => speci['nom'] == nom);
      } else {
        throw Exception(
            "Erreur lors de la vérification de l'existence de la spécialité");
      }
    } catch (e) {
      print('Erreur lors de la vérification de la specialite : $e');
      throw Exception(
          'Erreur lors de la vérification de l\'existence de la spécialité');

      // TODO
    }
  }
}
