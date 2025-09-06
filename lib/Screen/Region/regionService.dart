import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Region/model_region.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegionService {
  final String baseUrl = AppConfig.baseUrl;

  //Get
  Future<List<Region>> getRegion() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(Uri.parse('$baseUrl/regions'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        // Convertissez chaque objet JSON en une instance de Region
        return jsonResponse
            .map((region) => Region.fromJson(region as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des regions');
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception('Erreur lors de la récupération des regions');
    }
  }

  //Create

  Future<Region> createRegion(Region region) async {
    final response = await http.post(
      Uri.parse('$baseUrl/regions/save'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode(region.toJson()),
    );
    print("Ajout d'une region");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Region.fromJson(json.decode(response.body));
    } else {
      throw Exception('Echec lors de l\'ajout  de la region :${response.body}');
    }
  }

  //Delete

  Future<void> deleteRegion(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/regions/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de la suppression de la Region');
    }
  }

//Exist

  Future<bool> regionExists(String regionName) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/regions?nomRegion=$regionName'));

      if (response.statusCode == 200) {
        List<dynamic> regions = json.decode(response.body);
        return regions.any((region) => region['nomRegion'] == regionName);
      } else {
        throw Exception('Erreur lors de la vérification des regions');
      }
    } catch (e) {
      print('Erreur lors de la vérification des regions : $e');
      throw Exception('Erreur lors de la vérification des regions');
    }
  }

  ///
  ///
  ///
}
