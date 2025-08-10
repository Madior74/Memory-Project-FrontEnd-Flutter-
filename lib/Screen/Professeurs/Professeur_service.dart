import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';

class ProfesseurService {
  static const String baseUrl = 'http://localhost:9000';

  Future<List<Professeur>> fetchprofesseurs() async {
    final response = await http.get(Uri.parse('$baseUrl/professeurs'));

    print("Recuperation des Professeurs");
    print(response.statusCode);
    print(response.body); // <-- Ajout pour voir la structure JSON reçue

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Professeur.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load professeurs');
    }
  }

  //Verifier l'existence
  //Existence de l'etudiant par son email
  Future<bool> emailExist(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/professeurs/exists?email=$email'));
    print(" Existence du Professeur par son email");

    print(response.statusCode);
    print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la recupération des Professeurs");
    }
  }

  Future<Professeur> createProfesseur({
    required Map<String, dynamic> professeurData,
    List<int>? modulesIds,
  }) async {
    final params = <String, String>{};

    if (modulesIds != null) {
      for (var id in modulesIds) {
        params.addAll({'modulesIds': id.toString()});
      }
    }

    final url = Uri.http('localhost:9000', '/professeurs/save', params);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(professeurData),
      );

      print("Creation du Professeur");
      print(response.statusCode);
      print(response.body); // <-- Ajout pour voir la structure JSON reçue
      print("ProfesseurData");
      print(professeurData); // <-- Ajout pour voir la structure JSON reçue
      print("modulesIds");
      print(modulesIds); // <-- Ajout pour voir la structure JSON reçue
      print("params");
      print(params); // <-- Ajout pour voir la structure JSON reçue

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Professeur.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Échec de création : $error');
      }
    } on SocketException {
      throw Exception("Aucune connexion Internet");
    } on HttpException {
      throw Exception("Serveur injoignable");
    } on FormatException {
      throw Exception("Données reçues invalides");
    } catch (e) {
      throw Exception("Erreur lors de la création : $e");
    }
  }

  //Suppression d'un Professeur
  Future<void> deleteProfesseur(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/professeurs/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(" supression du Professeur");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression du Professeur');
    }
  }

  //supprimer la specialite d'un prof
  Future<void> removeSpecialiteFromProfesseur(
      int profId, int specialiteId) async {
    final url = '$baseUrl/professeurs/$profId/specialites/$specialiteId';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de la spécialité');
    }
  }

  //Specialite d'un Professeur
  Future<List<Specialite>> getSpecialitesByProfesseurId(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/professeurs/$id/specialites'));
    print("Recuperation des Specialites");
    print(response.statusCode);
    print(response.body); // <-- Ajout pour voir la structure JSON reçue
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((specialite) =>
              Specialite.fromJson(specialite as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des spécialités');
    }
  }

  //Ajouter des specialites à un Professeur
  Future<void> addSpecialiteToProfesseur(
      int profId, List<int> specialiteIds) async {
    final url = '$baseUrl/professeurs/$profId/specialites';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(specialiteIds),
    );

    print("Ajout de la specialite au Professeur");
    print(response.statusCode);
    print(response.body); // <-- Ajout pour voir la structure JSON reçue
    print("specialiteIds");
    print(specialiteIds); // <-- Ajout pour voir la structure JSON reçue

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de l\'ajout de la spécialité');
    }
  }
}
