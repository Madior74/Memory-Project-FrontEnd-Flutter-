import 'dart:convert';

import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EtudiantService {
  final String baseUrl =
      "http://192.168.1.15:9000/api/admin/candidat-pre-inscrit";

  //Get all Etudiants
  Future<List<Etudiant>> getAllEtudiant() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse
            .map((etudiant) =>
                Etudiant.fromJson(etudiant as Map<String, dynamic>))
            .toList();
      } else {
        print(
            "Erreur lors de la récupération des Etudiants ${response.statusCode}");
        throw Exception(
            "Erreur lors de la récupération des Etudiants ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception('Erreur lors de la récupération des Etudiants ');
    }
  }

  Future<Map<String, dynamic>> addEtudiant({
    required Map<String, dynamic> etudiantData,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$baseUrl/save');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(etudiantData),
      );
      print("Ajout d'un nouveau etudiant");
      print(response.statusCode);
      print(response.body);
      print(response);
      print("envoyes");
      print(json.encode(etudiantData));
      print(baseUrl);
      print('Réponse complète du serveur: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create professor: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating professor: $e');
    }
  }

  //dossier complet
  Future<List<Etudiant>> getEtudiantsAvecTroisDocuments() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response =
          await http.get(Uri.parse('$baseUrl/three-documents'), headers: {
        "Authorization": "Bearer $token",
      });
      print("Statut de la réponse: ${response.statusCode}");
      print("Corps de la réponse: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((etudiant) =>
                Etudiant.fromJson(etudiant as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            "Erreur lors de la récupération des étudiants avec trois documents");
      }
    } catch (e) {
      print("Erreur: $e");
      throw Exception(
          "Erreur lors de la récupération des étudiants avec trois documents: $e");
    }
  }

  //Supprimer un Etudiant
  Future<void> deleteEtudiant(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-type': 'application/json;charset=UTF-8',
      },
    );
    print("Suppression de l'etudiant");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erreur lors de la suppression de l'etudiant");
    }
  }

  //Existence de l'etudiant par son email
  Future<bool> emailExist(String email) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl/exists?email=$email'), headers: {
      "Authorization": "Bearer $token",
    });
    print(" Existence de l'etudiant par son email");

    print(response.statusCode);
    print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la recupération des Etudiants");
    }
  }

  //mise a jour d'un etudiant
  Future<Etudiant> updateEtudiant(Etudiant etudiant) async {
    final response = await http.put(Uri.parse('$baseUrl/${etudiant.id}'),
        headers: {'Content-type': 'application/json;charset=UTF-8'},
        body: json.encode(etudiant.toJson()));

    print("Mise a jour de l'etudiant");
    print(response.statusCode);
    print(response);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Etudiant.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          "Echec lors de  la mise a jour de l'etudiant ${response.body}");
    }
  }

  //recuperer les etudiants d'une Filiere
  Future<List<Etudiant>> getEtudiantsByFiliereId(int filiereId) async {
    final response = await http.get(Uri.parse('$baseUrl/filiere/$filiereId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((etudiant) => Etudiant.fromJson(etudiant))
          .toList();
    } else {
      throw Exception('Échec de la récupération des étudiants');
    }
  }

  Future<int> getEtudiantsCountByFiliereId(int filiereId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/filiere/$filiereId/count'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as int;
    } else {
      throw Exception('Échec de la récupération du nombre d\'étudiants');
    }
  }

// Récupérer les étudiants d'un niveau
  Future<List<Etudiant>> getEtudiantsByNiveauId(int niveauId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/niveau/$niveauId'));
      print("Récupération des étudiants par niveau");
      print("Code de réponse : ${response.statusCode}");
      print("Corps de la réponse : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((etudiant) =>
                Etudiant.fromJson(etudiant as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 204) {
        print("Aucun étudiant trouvé pour ce niveau.");
        return []; // Retourne une liste vide si aucun étudiant n'est trouvé
      } else if (response.statusCode == 404) {
        print(
            "Erreur 404 : Aucun étudiant trouvé pour le niveau ID $niveauId.");
        throw Exception("Aucun étudiant trouvé pour ce niveau.");
      } else {
        throw Exception(
            "Erreur lors de la récupération des étudiants : ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception('Erreur lors de la récupération des étudiants');
    }
  }

  //recuperer les etudiants d'une session
  Future<List<Etudiant>> getEtudiantsBySessionId(int sessionId) async {
    final response = await http.get(Uri.parse('$baseUrl/session/$sessionId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((etudiant) => Etudiant.fromJson(etudiant))
          .toList();
    } else {
      throw Exception('Échec de la récupération des étudiants');
    }
  }
}
