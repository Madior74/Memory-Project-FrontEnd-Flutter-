import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';

class SpecialiteService {
  final String baseUrl = 'http://localhost:9000/specialites';
  //get All Specialites
  Future<List<Specialite>> getAllSpecialites() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jResponse = json.decode(response.body);
      return jResponse.map((model) => Specialite.fromJson(model)).toList();
    } else {
      throw Exception('Echec de la recupération des specialiés');
    }
  }

  //Nouvelle specialite
  Future<void> addSpecialite(Specialite specialite) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': specialite.nom,
        'description': specialite.description,
      }),
    );
    print("response de l'API");
    print(response.body);
    print("status code");
    print(response.statusCode);
    print("specialite");
    print(specialite);
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Niveau added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('This niveau already exists in the filière');
    } else {
      throw Exception('Failed to add niveau');
    }
  }
  //Recuperer les specialites par

  Future<List<Specialite>> getSpecialiteByDomaine(int domaineId) async {
    final url = Uri.parse('$baseUrl/domaine/$domaineId');
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
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(" supression de L'UE");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression ');
    }
  }

  Future<bool> specialiteExist(String nom) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?nom=$nom'),
      );

      if (response.statusCode == 200) {
        List<dynamic> specs = json.decode(response.body);
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
