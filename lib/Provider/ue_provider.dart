import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/UES/model_ue.dart';

final getAllUesProvider = FutureProvider<List<UE>>((ref) async {
  final response = await http.get(Uri.parse('http://localhost:9000/ues'));

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    print("Données reçues de l'API : $data"); // Inspecte les données ici
    return data.map((json) => UE.fromJson(json)).toList();
  } else {
    throw Exception('Échec du chargement des UEs');
  }
});

final ueProvider =
    FutureProvider.family<List<UE>, int>((ref, semestreId) async {
  const baseUrl = 'http://localhost:9000/ues';

  // Effectuer la requête HTTP
  final response = await http.get(Uri.parse('$baseUrl/semestre/$semestreId'));

  if (response.statusCode == 200) {
    // Décoder la réponse JSON en une liste d'objets UE
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => UE.fromJson(json)).toList();
  } else {
    // Lever une exception en cas d'erreur
    throw Exception('Failed to load UEs for semestre $semestreId');
  }
});
