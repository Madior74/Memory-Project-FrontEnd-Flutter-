import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Etudiants/Inscription/inscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscriptionService {
  final String baseUrl = 'http://192.168.1.15:9000/api/admin/inscriptions';

  //Ajouter une Inscription
  Future<Map<String, dynamic>> addInscription({
    required Map<String, dynamic> inscriptionData,
  }) async {
    final url = Uri.parse('$baseUrl/dossiers/save');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inscriptionData),
      );
      print("donnees Envoyees");
      print(inscriptionData);
      print('Réponse serveur : ${response.statusCode}');
      print('Corps : ${response.body}');

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
  Future<List<Inscription>> getAllInscriptions() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/dossiers'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Inscription>.from(
          jsonResponse.map((ins) => Inscription.fromJson(ins)));
    } else {
      throw Exception('Erreur lors de la recuperation des Inscriptions');
    }
  }

  //Supprimer une Inscription
  Future<void> deleteInscription(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/dossiers/$id'));

    print("Supression de l\'Inscription");
    print('$baseUrl/$id');
    print(response);
    print(response.body);
    print(
        "Réponse de l'API : ${response.statusCode}"); // Ajoutez ce log pour vérifier

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
        '$baseUrl/dossiers/check?etudiantId=$etudiantId&filiereId=$filiereId&anneeAcademiqueId=$anneeAcademiqueId');

    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      print("Vérification de l'existence de l'inscription");
      print('URL : $url');
      print('Réponse serveur : ${response.statusCode}');
      print('Corps : ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        throw Exception(
            'Échec de la vérification de l\'inscription : ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la vérification : $e');
      throw Exception('Erreur lors de la vérification : $e');
    }
  }

// Récupérer les étudiants d'un niveau
  Future<List<Inscription>> getEtudiantsByNiveauId(int niveauId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response =
          await http.get(Uri.parse('$baseUrl/dossiers/niveau/$niveauId'), headers: {
        "Authorization": "Bearer $token",
      });
      print("Récupération des étudiants par niveau");
      print("Code de réponse : ${response.statusCode}");
      print("Corps de la réponse : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((etudiant) =>
                Inscription.fromJson(etudiant as Map<String, dynamic>))
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
}
