import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartementService {
  final String baseUrl = AppConfig.baseUrl;

  // Récupérer les niveaux pour une filière
  Future<List<Departement>> getDepartementByRegion(int regionId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$baseUrl/departements/departement/$regionId');
    print('URL de l\'API : $url');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data
          .map((departement) => Departement.fromJson(departement))
          .toList();
    } else {
      throw Exception('Failed to load departements');
    }
  }

  ///////
  Future<Filiere?> getFiliereByNiveauId(int niveauId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/departements/$niveauId/filiere'));
      print("Recuperation de la filiere");
      print('$baseUrl/$niveauId/filiere');
      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var filiereJson = jsonDecode(response.body);
        return Filiere.fromJson(filiereJson); // Conversion en objet Filiere
      } else {
        throw Exception('Erreur lors de la récupération de la filière');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la filière : $e');
    }
  }

  Future<void> addDepartementToRegion(
      int regionId, String nomDepartement) async {
    final response = await http.post(
      Uri.parse('$baseUrl/departements/departement/$regionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nomDepartement': nomDepartement}),
    );
    print("ReponseAfter");
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Departement added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('This departement already exists in the region');
    } else {
      throw Exception('Failed to add departement');
    }
  }

  // Mettre à jour un niveau
  Future<Niveau> updateNiveau(int id, Niveau niveau) async {
    final response = await http.put(
      Uri.parse('$baseUrl/departements/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(niveau.toJson()),
    );

    if (response.statusCode == 200) {
      return Niveau.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update niveau');
    }
  }

  // Get all niveaux
  Future<List<Niveau>> getNiveaux() async {
    final response = await http.get(Uri.parse('$baseUrl/departements'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Niveau>.from(
          jsonResponse.map((model) => Niveau.fromJson(model)));
    } else {
      throw Exception('Erreur lors de la recupération des Niveaux');
    }
  }

  // Delete a niveau
  Future<void> deleteDepartement(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/departements/$id'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );


    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Echec de la supression du Niveau');
    }
  }

  Future<bool> departementExist(String depName, int regionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/departements/exists?nomDepartement=$depName&regionId=$regionId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la vérification du departement");
    }
  }
}
