import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = AppConfig.authUrl;

  Future<Map<String, dynamic>> login(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Statut HTTP : ${response.statusCode}');
    print('Réponse : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      //Sauvegarder le token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['accessToken']);
      await prefs.setString('user', jsonEncode(data['user']));
      return data;
    } else if (response.statusCode == 401) {
      throw Exception('Échec de l\'authentification : Identifiants invalides.');
    } else if (response.statusCode == 404) {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['error'] ?? 'Ressource non trouvée.');
    } else {
      throw Exception('Erreur inattendue : ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
