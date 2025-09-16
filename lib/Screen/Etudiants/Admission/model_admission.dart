import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';

class DossierAdmission {
  final int? id;
  final bool copieCni;
  final bool releveNotes;
  final bool diplome;
  final String? remarque;
  final double noteTest;
  final double noteEntretien;
  final String status;

  final Candidat? candidat;
  final Filiere? filiereAcceptee;
  final Niveau? niveauAccepte;

  DossierAdmission({
    this.id,
    required this.copieCni,
    required this.releveNotes,
    required this.diplome,
    this.remarque,
    required this.noteTest,
    required this.noteEntretien,
    required this.status,
    this.candidat,
    this.filiereAcceptee,
    this.niveauAccepte,
  });

  factory DossierAdmission.fromJson(Map<String, dynamic> json) {
    return DossierAdmission(
      id: json['id'],
      copieCni: json['copieCni'] ?? false,
      releveNotes: json['releveNotes'] ?? false,
      diplome: json['diplome'] ?? false,
      remarque: json['remarque']?.toString(),
      noteTest: (json['noteTest'] ?? 0.0).toDouble(),
      noteEntretien: (json['noteEntretien'] ?? 0.0).toDouble(),
      status: json['status']?.toString() ?? 'REFUSE',
      candidat: json['candidat'] != null && json['candidat'] is Map<String, dynamic>
          ? Candidat.fromJson(json['candidat'] as Map<String, dynamic>)
          : null,
      filiereAcceptee: json['filiereAcceptee'] != null && json['filiereAcceptee'] is Map<String, dynamic>
          ? Filiere.fromJson(json['filiereAcceptee'] as Map<String, dynamic>)
          : null,
      niveauAccepte: json['niveauAccepte'] != null && json['niveauAccepte'] is Map<String, dynamic>
          ? Niveau.fromJson(json['niveauAccepte'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'copieCni': copieCni,
      'releveNotes': releveNotes,
      'diplome': diplome,
      'remarque': remarque,
      'noteTest': noteTest,
      'noteEntretien': noteEntretien,
      'status': status,
      'candidat': candidat?.toJson(),
      'filiereAcceptee': filiereAcceptee?.toJson(),
      'niveauAccepte': niveauAccepte?.toJson(),
    };
  }
}
