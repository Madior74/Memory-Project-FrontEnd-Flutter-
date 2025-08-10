// FutureProvider pour récupérer les niveaux
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final niveauxProvider = FutureProvider.family<List<Niveau>, int>((ref, filiereId) async {
  final response = await http.get(Uri.parse('http://localhost:9000/niveaux/filiere/$filiereId'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Niveau.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load niveaux');
  }
});