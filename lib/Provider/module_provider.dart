import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Modules/moduleService.dart';

final getAllModulesProvider = FutureProvider<List<Module>>((ref) async {
  const baseUrl = 'http://localhost:9000/modules';
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final List<dynamic> data = json.decode(response.body);
    print("Données reçues de l'API : $data"); // Inspecte les données ici
    return data.map((model) => Module.fromJson(model)).toList();
  } else {
    throw Exception('Échec de la récupération des modules');
  }
});



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
// Provider pour récupérer les modules par UE
// final getModulesByUEProvider =
//     FutureProvider.family<List<Module>, int>((ref, ueId) async {
//   final moduleService = ModuleService();
//   return await moduleService.getModulesByUE(ueId);
// });
