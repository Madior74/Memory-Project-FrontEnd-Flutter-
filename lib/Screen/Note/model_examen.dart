import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';

class Examen {
  final int? id;
  final double note;
  final DateTime dateAttribution;
  final Etudiant etudiant;
  final Professeur professeur;
  final Module courseModule;

  Examen({
    this.id,
    required this.note,
    required this.dateAttribution,
    required this.etudiant,
    required this.professeur,
    required this.courseModule,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'],
      note: json['note'].toDouble(),
      dateAttribution: DateTime.parse(json['dateAttribution']),
      etudiant: Etudiant.fromJson(json['etudiant']),
      professeur: Professeur.fromJson(json['professeur']),
      courseModule: Module.fromJson(json['courseModule']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'dateAttribution': dateAttribution.toIso8601String(),
      'etudiant': etudiant.toJson(),
      'professeur': professeur.toJson(),
      'courseModule': courseModule.toJson(),
    };
  }
}
