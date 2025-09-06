import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DossierAdmissionService {
  final String baseUrl = AppConfig.baseUrl;

  //Recuperer les dossiers
  Future<List<DossierAdmission>> getAllDossiers() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(Uri.parse('$baseUrl/dossiers'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse
            .map((dossier) =>
                DossierAdmission.fromJson(dossier as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            "Error lors de la recupération des dossiers d'admission");
      }
    } catch (e) {
      throw Exception(
          "Error lors de la recupération des dossiers d'admission:$e");
    }
  }

  //Creer un nouveau dossier
  Future<Map<String, dynamic>> createDossierAdmission(
      {required Map<String, dynamic> dossierAdmissionData}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.post(Uri.parse('$baseUrl/dossiers/save'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(dossierAdmissionData));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            "Echec de la creation decdossier d'admission:${response.body}");
      }
    } catch (e) {
      throw Exception("Echec de la creation decdossier d'admission:$e");
    }
  }

  //Mise a jour
  Future<void> updateDossierAdmission(DossierAdmission dossier, int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/dossiers/update/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(dossier.toJson()),
      );

      print("mis a jour admission");
      print(response.statusCode);
      print("id envoyé ${id}");
      print("Échec de la mise à jour du dossier : ${response.body}");
      if (response.statusCode != 200) {
        throw Exception(
            "Échec de la mise à jour du dossier : ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour : $e");
    }
  }

  //verification de l'existence d'un dossier
  Future<bool> dissierExist(int etudiantId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
        Uri.parse('$baseUrl/dossiers/exists?etudiantId=$etudiantId'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la vérification du dossier");
    }
  }

  //Delete
  Future<void> deleteDossier(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await http.delete(Uri.parse('$baseUrl/dossiers/$id'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Echec lors de la suppression du dossier");
    }
  }
}
