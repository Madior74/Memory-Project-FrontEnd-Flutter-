import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Salle/model_salle.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalleService {
  final String baseUrl = AppConfig.baseUrl;

  //get
  Future<List<Salle>> getAllSalles() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(Uri.parse('$baseUrl/salles'), headers: {
        "Authorization": "Bearer $token",
      });
      print(response.body);
      print("status code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((salle) => Salle.fromJson(salle as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des salles');
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception('Erreur lors de la récupération des salles');
    }
  }

  //Nouvelle salle
  Future<void> addSpecialite(Salle salle) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/salles/save'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode(salle),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
    } else if (response.statusCode == 409) {
      throw Exception('Cette Salle existe dèja');
    } else {
      throw Exception('Failed to add niveau');
    }
  }

  //Mettre a jour
  Future<void> updateSpecialite(int id, Salle salle) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/salles/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode(salle.toJson()),
    );
    print("Mis a jour dune speci de l'API");

    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Niveau added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('Erreur de Conflit ');
    } else {
      throw Exception('Echec lors de la mise à jour de la salle ');
    }
  }

  //Existence d'une classe
  Future<bool> salleExist(String nomSalle) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(
          Uri.parse('$baseUrl/salles/exists?nomSalle=$nomSalle'),
          headers: {
            "Authorization": "Bearer $token",
          });

      print(response.statusCode);

      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      } else {
        throw Exception(
            "Erreur lors de la vérification de l'existence de la salle");
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la vérification de l\'existence de la salle');
    }
  }

  //Delete
  Future<void> deleteSalle(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/salles/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression ');
    }
  }
}
