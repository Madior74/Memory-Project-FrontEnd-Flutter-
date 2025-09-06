import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpInterceptor {
  static bool _isRefreshing = false;

  static Future<http.Response> request(
    String method,
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      // Ajouter les headers d'authentification
      final authHeaders = await AuthService().authHeaders;
      final finalHeaders = {...authHeaders, ...?headers};

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(Uri.parse(url), headers: finalHeaders);
          break;
        case 'POST':
          response = await http.post(
            Uri.parse(url),
            headers: {
              ...finalHeaders,
              'Content-Type': 'application/json',
            },
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          throw Exception("Méthode $method non gérée");
      }

      // Vérifier si de nouveaux tokens ont été fournis (par headers ou body)
      final newAccessToken = response.headers['new-access-token'];
      final newRefreshToken = response.headers['new-refresh-token'];

      if (newAccessToken != null && newRefreshToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AuthService.accessTokenKey, newAccessToken);
        await prefs.setString(AuthService.refreshTokenKey, newRefreshToken);
      }

      // Si erreur 401, essayer de rafraîchir le token
      if (response.statusCode == 401 && !_isRefreshing) {
        _isRefreshing = true;
        final refreshSuccess = await AuthService().refreshToken();
        _isRefreshing = false;

        if (refreshSuccess) {
          return await request(method, url, headers: headers, body: body);
        } else {
          throw Exception('Session expirée, veuillez vous reconnecter');
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
