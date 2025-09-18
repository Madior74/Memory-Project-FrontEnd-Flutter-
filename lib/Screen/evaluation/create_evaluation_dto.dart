import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/Screen/Note/model_note.dart';

class CreateEvaluationDto {
  int? id;
  final String titre; 
  final String type; 
  final DateTime? dateEvaluation; 
  final TimeOfDay heureDebut;
  final TimeOfDay heureFin;
  final int moduleId; 
  final int professeurId;
  final List<Note>? notes; 

  CreateEvaluationDto({
    this.id,
    required this.titre,
    required this.type,
    this.dateEvaluation,
    required this.heureDebut,
    required this.heureFin,
    required this.moduleId,
    required this.professeurId,
    this.notes,
  });

  // Méthode pour sérialiser l'objet en JSON
  Map<String, dynamic> toJson() {
     String formatTime(TimeOfDay time) {
      // Ajoute un zéro devant si nécessaire
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
    return {
      'id': id,
      'titre': titre,
      'type': type,
      'dateEvaluation': dateEvaluation?.toIso8601String(),
      'heureDebut': formatTime(heureDebut),
      'heureFin': formatTime(heureFin),
      'moduleId': moduleId,
      'professeurId': professeurId,
      'notes': notes?.map((note) => note.toJson()).toList(),
    };
  }

  // Méthode pour désérialiser un JSON en objet CreateEvaluationDto
  factory CreateEvaluationDto.fromJson(Map<String, dynamic> json) {
    
    String heureDebutStr = json['heureDebut'] ?? '00:00';
    String heureFinStr = json['heureFin'] ?? '00:00';

    final debutParts = heureDebutStr.split(':');
    final finParts = heureFinStr.split(':');

    final heureDebut = TimeOfDay(
        hour: int.parse(debutParts[0]), minute: int.parse(debutParts[1]));

    final heureFin =
        TimeOfDay(hour: int.parse(finParts[0]), minute: int.parse(finParts[1]));

    return CreateEvaluationDto(
      id: json['id'],
      titre: json['titre'],
      type: json['type'],
      dateEvaluation: json['dateEvaluation'] != null
          ? DateTime.parse(json['dateEvaluation'])
          : null,
      heureDebut:heureDebut,
      heureFin: heureFin,
      moduleId: json['moduleId'],
      professeurId: json['professeurId'],
      notes: json['notes'] != null
          ? List<Note>.from(json['notes'].map((note) => Note.fromJson(note)))
          : null,
    );
  }
}
