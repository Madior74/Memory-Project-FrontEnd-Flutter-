import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/evaluation/Note/model_note.dart';

class Evaluation {
  int? id;

  final String type;
  final DateTime? dateEvaluation;
  final TimeOfDay heureDebut;
  final TimeOfDay heureFin;
  final Module? module;
  final Professeur? professeur;
  final List<Note>? notes;

  Evaluation({
    this.id,
    required this.type,
    this.dateEvaluation,
    required this.heureDebut,
    required this.heureFin,
    required this.module,
    required this.professeur,
    this.notes,
  });

  // Méthode pour désérialiser un JSON en objet Evaluation
  factory Evaluation.fromJson(Map<String, dynamic> json) {
    String heureDebutStr = json['heureDebut'] ?? '00:00';
    String heureFinStr = json['heureFin'] ?? '00:00';
    final debutParts = heureDebutStr.split(':');
    final finParts = heureFinStr.split(':');
    final heureDebut = TimeOfDay(
        hour: int.parse(debutParts[0]), minute: int.parse(debutParts[1]));
    final heureFin =
        TimeOfDay(hour: int.parse(finParts[0]), minute: int.parse(finParts[1]));

    return Evaluation(
      id: json['id'],
      type: json['type'],
      dateEvaluation: json['dateEvaluation'] != null
          ? DateTime.parse(json['dateEvaluation'])
          : null,
      heureDebut: heureDebut,
      heureFin: heureFin,
      module: json['module'] != null ? Module.fromJson(json['module']) : null,
      professeur: json['professeur'] != null
          ? Professeur.fromJson(json['professeur'])
          : null,
      notes: json['notes'] != null
          ? List<Note>.from(json['notes'].map((note) => Note.fromJson(note)))
          : null,
    );
  }

  // Méthode pour sérialiser l'objet en JSON
  Map<String, dynamic> toJson() {
    String formatTime(TimeOfDay time) {
      // Ajoute un zéro devant si nécessaire
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }

    return {
      'id': id,
      'type': type,
      'dateEvaluation': dateEvaluation?.toIso8601String(),
      'heureDebut': formatTime(heureDebut),
      'heureFin': formatTime(heureFin),
      'module': module?.toJson(),
      'professeur': professeur?.toJson(),
      'notes': notes?.map((note) => note.toJson()).toList(),
    };
  }
}
