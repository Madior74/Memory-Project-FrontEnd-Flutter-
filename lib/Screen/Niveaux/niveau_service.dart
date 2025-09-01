import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NiveauService {
  final String baseUrl = AppConfig.baseUrl;

  // Récupérer les niveaux pour une filière
  Future<List<Niveau>> getNiveauxByFiliere(int filiereId) async {
    final url = Uri.parse('$baseUrl/niveaux/filiere/$filiereId');
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    print('URL de l\'API : $url');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        print('Données JSON reçues : $data');

        // Mapper les données en objets Niveau
        List<Niveau> niveaux =
            data.map((niveau) => Niveau.fromJson(niveau)).toList();
        print('Liste des niveaux désérialisés : $niveaux');

        // Vérifier si les filières sont correctement désérialisées
        for (var niveau in niveaux) {}

        return niveaux;
      } catch (e) {
        throw Exception('Erreur lors de la désérialisation des niveaux');
      }
    } else {
      throw Exception('Failed to load niveaux');
    }
  }

  ///////
  Future<Filiere?> getFiliereByNiveauId(int niveauId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/niveaux/$niveauId/filiere'));
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

  Future<void> addNiveauToFiliere(int filiereId, String nomNiveau) async {
    final response = await http.post(
      Uri.parse('$baseUrl/niveaux/filiere/$filiereId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nomNiveau': nomNiveau}),
    );
    print("ReponseAfter");
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Niveau added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('This niveau already exists in the filière');
    } else {
      throw Exception('Failed to add niveau');
    }
  }

  // Mettre à jour un niveau
  Future<Niveau> updateNiveau(int id, Niveau niveau) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
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
    final response = await http.get(Uri.parse('$baseUrl/niveaux'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Niveau>.from(
          jsonResponse.map((model) => Niveau.fromJson(model)));
    } else {
      throw Exception('Erreur lors de la recupération des Niveaux');
    }
  }

  // Delete a niveau
  Future<void> deleteNiveau(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    print("Supression du niveau");
    print('$baseUrl/$id');
    print(response);
    print(
        "Réponse de l'API : ${response.statusCode}"); // Ajoutez ce log pour vérifier

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Echec de la supression du Niveau');
    }
  }

  Future<bool> niveauExist(String niveauName, int filiereId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/exists?nomNiveau=$niveauName&filiereId=$filiereId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la vérification du niveau");
    }
  }
}
