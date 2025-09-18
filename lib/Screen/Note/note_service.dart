import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Note/model_note.dart';
import 'package:school_management_system/Screen/Note/note_dto.dart';
import 'package:school_management_system/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteService {
  final String baseUrl = AppConfig.baseUrl + '/notes';
  final http.Client _httpClient = http.Client();

  Future<List<NoteDTO>> getNoteByEvaluation(int evaluationId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/evaluation/$evaluationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => NoteDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la recupération des Notes');
    }
  }

  //Note By Etudiant

  Future<NoteDTO> addNote(NoteDTO note) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/save'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(note.toJson()),
      );

      print("note add");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NoteDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to add Note');
      }
    } on Exception catch (e) {
      print('Erreur lors de l\'ajout du Note $e');
      throw Exception('Erreur lors de l\'ajout du Note $e');
    }
  }

  //update
  Future<Note> updateNote(int id, NoteDTO note) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.put(
      Uri.parse('$baseUrl/update/$id'), // À adapter selon ton endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(note.toJson()),
    );
    print("up");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return Note.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Note');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/delete/$id'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression de l\'evaluation $id');
      }
    } on Exception catch (e) {
      print('Erreur lors de la suppression de l\'evaluation $e');
      throw Exception('Erreur lors de la suppression de l\'evaluation $e');
      // TODO
    }
  }

  //existence d'une note

  //Exister une séance
  Future<bool> noteExist(int etudiantId, int evaluationId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await _httpClient.get(
        Uri.parse(
            '$baseUrl/exists?etudiantId=$etudiantId&evaluationId=$evaluationId'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception(
          'Erreur lors de la vérification de l\'existence de la note');
    }
  }
}
