// To parse this JSON data, do
//
//     final evaluationDto = evaluationDtoFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Note/note_dto.dart';

List<EvaluationDto> evaluationDtoFromJson(String str) =>
    List<EvaluationDto>.from(
        json.decode(str).map((x) => EvaluationDto.fromJson(x)));

String evaluationDtoToJson(List<EvaluationDto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EvaluationDto {
  int id;
  String type;
  DateTime dateEvaluation;
  int moduleId;
  int salleId;
  int professeurId;
  TimeOfDay heureDebut;
  TimeOfDay heureFin;
  int anneeAcademiqueId;
  List<NoteDTO> notes;

  EvaluationDto({
    required this.id,
    required this.type,
    required this.dateEvaluation,
    required this.moduleId,
    required this.salleId,
    required this.professeurId,
    required this.heureDebut,
    required this.heureFin,
    required this.anneeAcademiqueId,
    required this.notes,
  });

  factory EvaluationDto.fromJson(Map<String, dynamic> json) {
    String heureDebutStr = json['heureDebut'] ?? '00:00';
    String heureFinStr = json['heureFin'] ?? '00:00';

    final debutParts = heureDebutStr.split(':');
    final finParts = heureFinStr.split(':');

    final heureDebut = TimeOfDay(
        hour: int.parse(debutParts[0]), minute: int.parse(debutParts[1]));
    final heureFin =
        TimeOfDay(hour: int.parse(finParts[0]), minute: int.parse(finParts[1]));

    return EvaluationDto(
      id: json["id"],
      type: json["type"],
      dateEvaluation: DateTime.parse(json["dateEvaluation"]),
      moduleId: json["moduleId"],
      salleId: json["salleId"],
      professeurId: json["professeurId"],
      heureDebut: heureDebut,
      heureFin: heureFin,
      anneeAcademiqueId: json["anneeAcademiqueId"],
      notes: List<NoteDTO>.from(json["notes"].map((x) => NoteDTO.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "dateEvaluation":
            "${dateEvaluation.year.toString().padLeft(4, '0')}-${dateEvaluation.month.toString().padLeft(2, '0')}-${dateEvaluation.day.toString().padLeft(2, '0')}",
        "moduleId": moduleId,
        "salleId": salleId,
        "professeurId": professeurId,
        "heureDebut": heureDebut,
        "heureFin": heureFin,
        "anneeAcademiqueId": anneeAcademiqueId,
        "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
      };
  int getDureeEnHeur() {
    return heureFin.hour - heureDebut.hour;
  }
}
