import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Filieres/filiere.dart';

final filiereProvider =
    FutureProvider.family<Filiere, int>((ref, filiereId) async {
  final response =
      await http.get(Uri.parse('http://localhost:9000/filieres/$filiereId'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Filiere.fromJson(data);
  } else {
    throw Exception('Failed to load filiere');
  }
});
