import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = AppConfig.authUrl;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static String get accessTokenKey => _accessTokenKey;
  static String get refreshTokenKey => _refreshTokenKey;

  Future<Map<String, String>> get authHeaders async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'Refresh-Token': refreshToken ?? '',
    };
  }

  Future<Map<String, dynamic>> login(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    print(
      ('$baseUrl/auth/login'),
    );
    print('Statut HTTP : ${response.statusCode}');
    print('Réponse : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      //Sauvegarder le token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['accessToken']);
      await prefs.setString(_accessTokenKey, data['accessToken']);
      await prefs.setString(_refreshTokenKey, data['refreshToken']);
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

  //Refresh Token
  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshTken = prefs.getString(_refreshTokenKey);

      if (refreshTken == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshTken': refreshTken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString(_accessTokenKey, data['accessToken']);
        await prefs.setString(_refreshTokenKey, data['refreshToken']);

        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
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
