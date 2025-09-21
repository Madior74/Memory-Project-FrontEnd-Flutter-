import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant_dto.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscriptionService {
  final String baseUrl = AppConfig.baseUrl + '/inscriptions';

  //Ajouter une Inscription
  Future<Map<String, dynamic>> addInscription({
    required Map<String, dynamic> inscriptionData,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$baseUrl/save');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(inscriptionData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Échec de la création de l\'inscription : ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout : $e');
      throw Exception('Erreur lors de l\'ajout : $e');
    }
  }

  //Recuperer les Inscriptions
  Future<List<Etudiant>> getAllInscriptionWDTO() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/all'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Etudiant>.from(
          jsonResponse.map((ins) => Etudiant.fromJson(ins)));
    } else {
      throw Exception('Erreur lors de la recuperation des Inscriptions');
    }
  }

  //Recuperer les Inscriptions avec DTO
  Future<List<EtudiantDTO>> getAllInscriptions() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<EtudiantDTO>.from(
          jsonResponse.map((ins) => EtudiantDTO.fromJson(ins)));
    } else {
      throw Exception('Erreur lors de la recuperation des Inscriptions');
    }
  }

  //Supprimer une Inscription
  Future<void> deleteInscription(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.delete(Uri.parse('$baseUrl/$id'), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Echec de la supression de l\'Inscription');
    }
  }

  //Existe t'il une inscription
  Future<bool> checkIfInscriptionExists({
    required int etudiantId,
    required int filiereId,
    required int anneeAcademiqueId,
  }) async {
    final url = Uri.parse(
        '$baseUrl/check?etudiantId=$etudiantId&filiereId=$filiereId&anneeAcademiqueId=$anneeAcademiqueId');

    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        throw Exception(
            'Échec de la vérification de l\'inscription : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la vérification : $e');
    }
  }

// Récupérer les étudiants d'un niveau
  Future<List<EtudiantDTO>> getEtudiantsByNiveauId(int niveauId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl/niveau/$niveauId'), headers: {
      "Authorization": "Bearer $token",
    });
   

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((etudiant) =>
              EtudiantDTO.fromJson(etudiant as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 204) {
      return []; // Retourne une liste vide si aucun étudiant n'est trouvé
    } else if (response.statusCode == 404) {
      throw Exception("Aucun étudiant trouvé pour ce niveau.");
    } else {
      throw Exception(
          "Erreur lors de la récupération des étudiants : ${response.reasonPhrase}");
    }
  }
}
