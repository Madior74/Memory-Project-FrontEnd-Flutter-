import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant.dart';
import 'package:school_management_system/Screen/Seance/model_seance.dart';

class Assiduite {
  final int? id;
  final Etudiant etudiant;
  final Seance seance;
  final String statutPresence;

  Assiduite({
    this.id,
    required this.etudiant,
    required this.seance,
    required this.statutPresence,
  });

  factory Assiduite.fromJson(Map<String, dynamic> json) {
    return Assiduite(
        id: json['id'],
        etudiant: Etudiant.fromJson(json['etudiant']),
        seance: Seance.fromJson(json['seance']),
        statutPresence: json['statutPresence']);
  }

  Map<String, dynamic> toJson() {
    return {
      'etudiant': etudiant.toJson(),
      'seance': seance.toJson(),
      'statutPresence': statutPresence
    };
  }
}

enum StatutPresence { present, absent, retard, exclus }
