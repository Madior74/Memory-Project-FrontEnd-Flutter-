import 'dart:convert';

import 'package:http/http.dart' as _httpClient;
import 'package:school_management_system/Screen/Seance/model_seance.dart';
import 'package:school_management_system/Screen/assiduite/assiduiteDTO.dart';
import 'package:school_management_system/Screen/assiduite/model_assiduite.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssiduiteService {
  final String baseUrl = AppConfig.baseUrl + '/assiduites';

  // Récupération de toutes les assiduités
  Future<List<Assiduite>> getAllAssiduite() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await _httpClient.get(Uri.parse('$baseUrl'), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return List<Assiduite>.from(
          jsonResponse.map((asd) => Assiduite.fromJson(asd)));
    } else {
      throw Exception('Erreur lors de la récupération des assiduités');
    }
  }

  // Assiduité par Séance
  Future<List<AssiduiteDto>> getAssiduiteBySeance(Seance seance) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await _httpClient
        .get(Uri.parse('$baseUrl/seance/${seance.id}'), headers: {
      "Authorization": "Bearer $token",
    });
    print("Assiduites");
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return List<AssiduiteDto>.from(
          jsonResponse.map((asd) => AssiduiteDto.fromJson(asd)));
    } else {
      throw Exception(
          'Erreur lors de la récupération des assiduités pour la séance');
    }
  }

  // Récupérer une assiduité par ID
  Future<Assiduite> getAssiduiteById(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await _httpClient.get(Uri.parse('$baseUrl/$id'), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return Assiduite.fromJson(jsonResponse);
    } else {
      throw Exception('Erreur lors de la récupération de l\'assiduité');
    }
  }

  // Créer une assiduité
  Future<Assiduite> createAssiduite(Assiduite assiduite) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/save'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(assiduite.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return Assiduite.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Erreur lors de la création de l\'assiduité: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'assiduité: $e');
      throw Exception('Erreur lors de la création de l\'assiduité: $e');
    }
  }

  // Mettre à jour une assiduité
  Future<AssiduiteDto> updateAssiduite(int id, AssiduiteDto assiduite) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response = await _httpClient.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(assiduite.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return AssiduiteDto.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Erreur lors de la mise à jour de l\'assiduité: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'assiduité: $e');
    }
  }

  // Supprimer une assiduité
  Future<void> deleAssiduite(int assiduiteId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/delete/$assiduiteId'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return;
      } else {
        throw Exception(
            'Erreur lors de la suppression de l\'assiduité: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'assiduité: $e');
    }
  }

  //Gen

  Future<List<Assiduite>> getAssiduiteeParSeance(int seanceId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/assiduite/seance/$seanceId'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Assiduite.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
