import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleService {
  final String baseUrl = AppConfig.baseUrl + '/modules';

  //get All Modules
  Future<List<Module>> getAllModules() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse(baseUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print("Recuperation des Modules");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable jResponse = json.decode(response.body);
      return List<Module>.from(
          jResponse.map((model) => Module.fromJson(model)));
    } else {
      throw Exception('Echec de la recupération des modules');
    }
  }

  //get  Modules by UE
  Future<List<Module>> getModulesByUE(int ueId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/ue/$ueId'), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      // Vérifier si "data" est null ou vide
      final data = jsonResponse['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) {
        throw Exception('Aucun module trouvé pour cette UE');
      }

      return data.map((module) => Module.fromJson(module)).toList();
    } else if (response.statusCode == 404) {
      // Gérer explicitement le cas 404
      throw Exception('Aucun module trouvé pour cette UE');
    } else {
      // Gérer les autres erreurs HTTP
      throw Exception('Failed to load modules: ${response.statusCode}');
    }
  }

  Future<List<Module>> getModuleById(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      if (jsonData is List) {
        // Si l'API renvoie une liste, on la convertit directement
        return jsonData.map((mdl) => Module.fromJson(mdl)).toList();
      } else if (jsonData is Map<String, dynamic>) {
        // Si l'API renvoie un seul module (objet JSON unique), on l'ajoute dans une liste
        return [Module.fromJson(jsonData)];
      } else {
        throw Exception("Format de réponse inattendu");
      }
    } else {
      throw Exception('Failed to load module');
    }
  }

  //Nouveau Module
  Future<void> addModuleToUE(int ueId, Module module) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$baseUrl/ue/$ueId');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final body = json.encode({
      'nomModule': module.nomModule,
      'ueId': ueId,
      'volumeHoraire': module.volumeHoraire,
      'creditModule': module.creditModule,
      'ue': {"id": module.ue!.id},
      'dateAjout': module.dateAjout!.toIso8601String().substring(0, 23),
      'devoirNotes': module.devoirNotes
          .map((note) => note.toJson())
          .toList(), // Convertir les devoirNotes en JSON
    });



    final response = await http.post(url, headers: headers, body: body);
  

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception("Erreur lors de l'ajout du module : ${response.body}");
    }
  }

  //Existence du Module
  Future<bool> moduleExist(String nomModule, int ueId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
        Uri.parse('$baseUrl/exists?nomModule=$nomModule&ueId=$ueId'),
        headers: {
          "Authorization": "Bearer $token",
        });


    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Echec de la recuperation des modules');
    }
  }

  //Delete
  Future<void> deleteModule(int id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );
    print(" supression de L'UE");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression de l\'ue');
    }
  }
}
