import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Seance/model_seance.dart';
import 'dart:convert';
import 'dart:async';

import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeanceService {
  static const String apiUrl = AppConfig.baseUrl + '/seances';
  final http.Client _httpClient = http.Client();

  //Récupérer toutes les séances
  Future<List<Seance>> getAllSeances() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(Uri.parse(apiUrl), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Seance.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des seances');
    }
  }

  //  Récupérer une séance par ID
  Future<Seance> getSeanceById(int id) async {
    final response = await _httpClient.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Seance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors du chargement de la séance $id');
    }
  }

  //  Récupérer les séances par ID de module
  Future<List<Seance>> getSeancesByModuleId(int moduleId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response =
        await _httpClient.get(Uri.parse('$apiUrl/module/$moduleId'), headers: {
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Seance.fromJson(json)).toList();
    } else {
      throw Exception(
          'Erreur lors du chargement des séances pour le module $moduleId');
    }
  }

  // Créer une nouvelle séance
  Future<Seance> createSeance(Seance seance) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.post(
      Uri.parse('$apiUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(seance.toJson()),
    );


    if (response.statusCode == 201 || response.statusCode == 200) {
      return Seance.fromJson(jsonDecode(response.body));
    } else {
      print("Erreur lors de la création de la séance");
      throw Exception('Erreur lors de la création de la séance');
    }
  }

  //  Mettre à jour une séance
  Future<Seance> updateSeance(int id, Seance seance) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.put(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(seance.toJson()),
    );

    if (response.statusCode == 200) {
      return Seance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour de la séance $id');
    }
  }

  //  Supprimer une séance
  Future<void> deleteSeance(int id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httpClient.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression de la séance $id');
      }
    } on Exception catch (e) {
      throw Exception('Erreur lors de la suppression de la séance $e');
      // TODO
    }
  }

  //Exister une séance
  Future<bool> seanceExists(BuildContext context, int moduleId,
      DateTime? dateSeance, TimeOfDay heureDebut, TimeOfDay heureFin) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final dateString =
        dateSeance != null ? formatDateForServer(dateSeance) : '';
    final heureDebutString = heureDebut.format(context);
    final heureFinString = heureFin.format(context);

    final response = await _httpClient.get(
        Uri.parse(
            '$apiUrl/existe?moduleId=$moduleId&dateSeance=$dateString&heureDebut=$heureDebutString&heureFin=$heureFinString'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception(
          'Erreur lors de la vérification de l\'existence de la séance');
    }
  }

// Fonction utilitaire
  String formatDateForServer(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  ///Methode pour reporter ou annuler une seance

  // Future<void> validerSeance(int id) async {
  //   await http.patch(
  //     Uri.parse('$apiUrl/$id'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'estValideeManuellement': true}),
  //   );
  // }

  Future<void> annulerSeance(int id) async {
    await http.patch(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estAnnulee': true}),
    );
  }

  // Future<void> reporterSeance(int id) async {
  //   await http.patch(
  //     Uri.parse('$apiUrl/$id'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'estReporte': true}),
  //   );
  // }

  //prof
  Professeur? getDernierProfesseurPourModule(
      Module module, List<Seance> toutesLesSeances) {
    final seancesDuModule =
        toutesLesSeances.where((s) => s.module.id == module.id).toList();

    if (seancesDuModule.isEmpty) return null;

    seancesDuModule.sort((a, b) =>
        (b.dateSeance ?? DateTime(0)).compareTo(a.dateSeance ?? DateTime(0)));

    return seancesDuModule.first.professeur;
    
  }

}
