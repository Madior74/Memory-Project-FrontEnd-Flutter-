import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfesseurService {
  static const String baseUrl =
      'http://192.168.1.15:9000/api/admin/professeurs';
  Future<List<Professeur>> fetchprofesseurs() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl'), headers: {
      "Authorization": "Bearer $token",
    });

    print("Recuperation des Professeurs");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      return jsonResponse
          .map((prof) => Professeur.fromJson(prof as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          "Erreur lors de la récupération des Etudiants ${response.statusCode}");
    }
  }

  //Verifier l'existence
  //Existence de l'etudiant par son email
  Future<bool> emailExist(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/professeurs/exists?email=$email'));
    print(" Existence du Professeur par son email");

    print(response.statusCode);
    print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la recupération des Professeurs");
    }
  }

//Nouveau Professeur
  Future<Professeur> createProfesseur(Professeur prof) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.put(Uri.parse('$baseUrl'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: json.encode(prof.toJson()));

    if (response.statusCode == 200) {
      return Professeur.fromJson(json.decode(response.body));
    } else {
      throw Exception("Echec lors de l'ajout du professeur :${response.body}");
    }
  }

//Mise a jour dun prof
  Future<Professeur> updateProfesseur(int profId, Professeur professeur) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.put(Uri.parse('$baseUrl/update/$profId'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: json.encode(professeur.toJson()));
    print("donnees envoyes ${professeur.toJson()}");

    print("Mise a jour du prof ${response.statusCode}");
    print("Mise a jour du prof ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Professeur.fromJson(json.decode(response.body));
    } else
      throw Exception(
          "Erreur lors de la mise a jour du professeur ${response.statusCode}");
  }

  //Suppression d'un Professeur
  Future<void> deleteProfesseur(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/professeurs/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(" supression du Professeur");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression du Professeur');
    }
  }

  //supprimer la specialite d'un prof
  Future<void> removeSpecialiteFromProfesseur(
      int profId, int specialiteId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = '$baseUrl/$profId/specialites/$specialiteId';

    final response = await http
        .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de la spécialité');
    }
  }

  //Specialite d'un Professeur
  Future<List<Specialite>> getSpecialitesByProfesseurId(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl/$id/specialites'), headers: {
      "Authorization": "Bearer $token",
    });
    print("Recuperation des Specialites");
    print(response.statusCode);
    print(response.body); // <-- Ajout pour voir la structure JSON reçue
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((specialite) =>
              Specialite.fromJson(specialite as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des spécialités');
    }
  }

  //Ajouter des specialites à un Professeur
  Future<void> addSpecialiteToProfesseur(
      int profId, List<int> specialiteIds) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = '$baseUrl/$profId/specialites';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(specialiteIds),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de l\'ajout de la spécialité');
    }
  }
}
