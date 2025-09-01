import 'dart:convert';

import 'package:school_management_system/Screen/UES/model_ue.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UeService {
  final String baseUrl = AppConfig.baseUrl;

  //Get
  Future<List<UE>> getUes() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('$baseUrl/ues'), headers: {
      'Authorization': 'Bearer $token',
    });

    print("Recuperation des UES");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable jsonResponse = json.decode(response.body);
      return List<UE>.from(jsonResponse.map((model) => UE.fromJson(model)));
    } else {
      throw Exception('Failed to load ues');
    }
  }

  Future<List<UE>> getUesBySemestre(int semestreId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http
        .get(Uri.parse('$baseUrl/ues/semestre/$semestreId'), headers: {
      'Authorization': 'Bearer $token',
    });
    print("Recuperation des UES");
    print(response.statusCode);
    print(response.body);
    print(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((ue) => UE.fromJson(ue)).toList();
    } else {
      throw Exception('Failed to load ues');
    }
  }

  //Create

  Future<void> addUeToSemestre(int? semestreId, UE ue) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$baseUrl/ues/$semestreId/ue');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final body = json.encode(ue.toJson());

  
    final response = await http.post(url, headers: headers, body: body);

  

    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
    
      throw Exception("Erreur lors de l'ajout de l'UE : ${response.body}");
    }
  }

  //Delete
  Future<void> deleteUe(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ues/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw Exception('Échec de la suppression de l\'ue');
    }
  }

  Future<UE> updateUE(UE ue) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ues/${ue.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(ue
          .toJson()), // Utilise toJson() pour formater correctement les données
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UE
          .fromJson(json.decode(response.body)); // Parse la réponse en objet UE
    } else {
      throw Exception('Échec de la mise à jour de l\'ue : ${response.body}');
    }
  }

  //Get by id
  Future<UE> getUeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/ues/$id'));
    if (response.statusCode == 200) {
      return UE.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ue');
    }
  }

  //Verification de l'existence d'une UE
  Future<bool> ueExist(String nomUe, int? semestreId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
        Uri.parse('$baseUrl/ues/exists?nomUE=$nomUe&semestreId=$semestreId'),
        headers: {
          "Authorization": "Bearer $token",
        });

   
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Failed to load ues');
    }
  }

  //Recuperer les UEs par id
  Future<UE> getUEById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/ues/$id"));

    if (response.statusCode == 200) {
      return UE.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Échec de la récupération de l'UE");
    }
  }
}
