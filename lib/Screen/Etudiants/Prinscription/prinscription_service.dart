import 'dart:convert';

import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';

import 'package:http/http.dart' as http;
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinscriptionService {
  final String baseUrl = AppConfig.baseUrl;

  //Get all Etudiants
  Future<List<CandidatPreInscrit>> getAllEtudiant() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response =
          await http.get(Uri.parse('$baseUrl/candidat-pre-inscrit'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse
            .map((etudiant) =>
                CandidatPreInscrit.fromJson(etudiant as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            "Erreur lors de la récupération des Etudiants ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Etudiants $e');
    }
  }

  Future<Map<String, dynamic>> addEtudiant({
    required Map<String, dynamic> etudiantData,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$baseUrl/candidat-pre-inscrit/save');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(etudiantData),
      );

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
  Future<List<CandidatPreInscrit>> getEtudiantsAvecTroisDocuments() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(
          Uri.parse('$baseUrl/candidat-pre-inscrit/three-documents'),
          headers: {
            "Authorization": "Bearer $token",
          });

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((etudiant) =>
                CandidatPreInscrit.fromJson(etudiant as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            "Erreur lors de la récupération des étudiants avec trois documents");
      }
    } catch (e) {
      throw Exception(
          "Erreur lors de la récupération des étudiants avec trois documents: $e");
    }
  }

  //Supprimer un Etudiant
  Future<void> deleteEtudiant(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/candidat-pre-inscrit/$id'),
      headers: {
        'Content-type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erreur lors de la suppression de l'etudiant");
    }
  }

  //Existence de l'etudiant par son email
  Future<bool> emailExist(String email) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
        Uri.parse('$baseUrl/candidat-pre-inscrit/exists?email=$email'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la recupération des Etudiants");
    }
  }

  //mise a jour d'un etudiant
  Future<CandidatPreInscrit> updateEtudiant(CandidatPreInscrit etudiant) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.put(
        Uri.parse('$baseUrl/candidat-pre-inscrit/${etudiant.id}'),
        headers: {
          'Content-type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(etudiant.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CandidatPreInscrit.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          "Echec lors de  la mise a jour de l'etudiant ${response.body}");
    }
  }

  //recuperer les etudiants d'une Filiere
  Future<List<CandidatPreInscrit>> getEtudiantsByFiliereId(
      int filiereId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/candidat-pre-inscrit/filiere/$filiereId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((etudiant) => CandidatPreInscrit.fromJson(etudiant))
          .toList();
    } else {
      throw Exception('Échec de la récupération des étudiants');
    }
  }

  Future<int> getEtudiantsCountByFiliereId(int filiereId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/candidat-pre-inscrit/filiere/$filiereId/count'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as int;
    } else {
      throw Exception('Échec de la récupération du nombre d\'étudiants');
    }
  }

// Récupérer les étudiants d'un niveau
  Future<List<CandidatPreInscrit>> getEtudiantsByNiveauId(int niveauId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/candidat-pre-inscrit/niveau/$niveauId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((etudiant) =>
                CandidatPreInscrit.fromJson(etudiant as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 204) {
        return []; // Retourne une liste vide si aucun étudiant n'est trouvé
      } else if (response.statusCode == 404) {
        throw Exception("Aucun étudiant trouvé pour ce niveau.");
      } else {
        throw Exception(
            "Erreur lors de la récupération des étudiants : ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des étudiants');
    }
  }

  //recuperer les etudiants d'une session
  Future<List<CandidatPreInscrit>> getEtudiantsBySessionId(
      int sessionId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/candidat-pre-inscrit/session/$sessionId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((etudiant) => CandidatPreInscrit.fromJson(etudiant))
          .toList();
    } else {
      throw Exception('Échec de la récupération des étudiants');
    }
  }
}
