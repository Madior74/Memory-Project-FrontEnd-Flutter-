import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class Devoir {
  final int? id;
  final double note;
  final DateTime? dateAttribution;
  final CandidatPreInscrit etudiant;
  final Professeur professeur;
  final Module courseModule;

  Devoir({
    this.id,
    required this.note,
    required this.dateAttribution,
    required this.etudiant,
    required this.professeur,
    required this.courseModule,
  });

  factory Devoir.fromJson(Map<String, dynamic> json) {
    return Devoir(
      id: json['id'],
      note: json['note'].toDouble(),
      dateAttribution: json['dateAttribution'] != null
          ? DateTime.parse(json['dateAttribution'])
          : null,
      etudiant: CandidatPreInscrit.fromJson(json['etudiant']),
      professeur: Professeur.fromJson(json['professeur']),
      courseModule: Module.fromJson(json['courseModule']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'dateAttribution': dateAttribution?.toIso8601String(),
      'etudiant': etudiant != null ? {'id': etudiant.id} : null,
      'professeur': professeur != null ? {'id': professeur.id} : null,
      'courseModule': courseModule != null ? {'id': courseModule.id} : null,
    };
  }
}
