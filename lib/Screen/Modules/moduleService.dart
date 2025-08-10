import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:http/http.dart' as http;

class ModuleService {
  final String baseUrl = 'http://localhost:9000/modules';
  //get All Modules
  Future<List<Module>> getAllModules() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable jResponse = json.decode(response.body);
      return List<Module>.from(
          jResponse.map((model) => Module.fromJson(model)));
    } else {
      throw Exception('Echec de la recupération des modules');
    }
  }

  final getAllModulesProvider = FutureProvider<List<Module>>((ref) async {
    const baseUrl = 'http://localhost:9000/modules';
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((model) => Module.fromJson(model)).toList();
    } else {
      throw Exception('Échec de la récupération des modules');
    }
  });

  //get  Modules by UE
  Future<List<Module>> getModulesByUE(int ueId) async {
    final response = await http.get(Uri.parse('$baseUrl/ue/$ueId'));
    print("Recuperation des Modules");
    print(response.statusCode);
    print('$baseUrl/ue/$ueId');
    print(response.body);

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

  //Provider
  final getModulesByUEProvider =
      FutureProvider.family<List<Module>, int>((ref, ueId) async {
    const baseUrl = 'http://localhost:9000/modules';
    final response = await http.get(Uri.parse('$baseUrl/ue/$ueId'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((model) => Module.fromJson(model)).toList();
    } else {
      throw Exception('Échec de la récupération des modules pour cette UE');
    }
  });

  Future<List<Module>> getModuleById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

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
    // final url = Uri.parse('$baseUrl/$ueId/module');
    final url = Uri.parse('$baseUrl/ue/$ueId');
    final headers = {'Content-Type': 'application/json'};
    // final body = json.encode(module.toJsonForCreation(ueId));
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

    print("Ajout d'un module");
    print("URL:$url");
    print("Body:$body");

    final response = await http.post(url, headers: headers, body: body);
    print("Status de la reponse");
    print(response.statusCode);
    print("Reponse");
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Module Ajouté avec succès");
    } else {
      print("Erreur lors de l'ajout du module");
      throw Exception("Erreur lors de l'ajout du module : ${response.body}");
    }
  }

  //provider
  final addModuleToUEProvider =
      FutureProvider.family<void, ({int ueId, Module module})>(
          (ref, params) async {
    const baseUrl = 'http://localhost:9000/modules';
    final url = Uri.parse('$baseUrl/ue/${params.ueId}');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(params.module.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur lors de l\'ajout du module : ${response.body}');
    }
  });

  //Existence du Module
  Future<bool> moduleExist(String nomModule, int ueId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/exists?nomModule=$nomModule&ueId=$ueId'));
    print("Reponse de L'API et verification de l'existence du meme module");
    print(response);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Echec de la recuperation des modules');
    }
  }

  //Delete
  Future<void> deleteModule(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(" supression de L'UE");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression de l\'ue');
    }
  }

  //provider
  final deleteModuleProvider =
      FutureProvider.family<void, int>((ref, moduleId) async {
    const baseUrl = 'http://localhost:9000/modules';
    final response = await http.delete(Uri.parse('$baseUrl/$moduleId'));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de la suppression du module');
    }
  });
}
