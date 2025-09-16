import 'dart:convert';
import 'dart:math';
import 'package:flutter/src/material/time.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/evaluation/model_evaluation.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EvaluationService {
  final String baseUrl = AppConfig.baseUrl + '/evaluations';
  final http.Client _httpClient = http.Client();

  Future<List<Evaluation>> getAllEvaluations() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Evaluation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load evaluations');
    }
  }

//Evaluatiom By module

  Future<List<Evaluation>> getEvaluationByModule(int moduleId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/module/$moduleId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Evaluation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load evaluations');
    }
  }

  Future<Evaluation> addEvaluation(Evaluation evaluation) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/save'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(evaluation.toJson()),
      );

      print("Evalution add");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Evaluation.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to add evaluation');
      }
    } on Exception catch (e) {
      print('Erreur lors de l\'ajout de l\'evaluation $e');
      throw Exception('Erreur lors de l\'ajout de l\'evaluation $e');
    }
  }

  //update
  Future<Evaluation> updateEvaluation(int id, Evaluation evaluation) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.put(
      Uri.parse('$baseUrl/update/$id'), // À adapter selon ton endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(evaluation.toJson()),
    );
 

    if (response.statusCode == 200) {
      return Evaluation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update evaluation');
    }
  }

  Future<void> deleteEvaluation(int id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/delete/$id'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression de l\'evaluation $id');
      }
    } on Exception catch (e) {
      print('Erreur lors de la suppression de l\'evaluation $e');
      throw Exception('Erreur lors de la suppression de l\'evaluation $e');
      // TODO
    }
  }

  //existence d'une evaluation

  //Exister une séance
  Future<bool> evaluationExist(int moduleId, String type,
      DateTime? dateEvaluation, TimeOfDay heureFin) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final dateString =
        dateEvaluation != null ? formatDateForServer(dateEvaluation) : '';

    final response = await _httpClient.get(
        Uri.parse(
            '$baseUrl/exists?moduleId=$moduleId&type=$type&dateEvaluation=$dateString'),
        headers: {
          "Authorization": "Bearer $token",
        });
    print("existence");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception(
          'Erreur lors de la vérification de l\'existence de l\'evaluation');
    }
  }

  // Fonction utilitaire
  String formatDateForServer(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
