import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';

class DossierAdmission {
  final int? id;
  final bool copieCni;
  final bool releveNotes;
  final bool diplome;
  final String statut;
  final double noteTest;
  final double noteEntretien;
  final String remarque;
  final CandidatPreInscrit? candidat;

  DossierAdmission({
    this.id,
    required this.copieCni,
    required this.releveNotes,
    required this.diplome,
    required this.statut,
    required this.remarque,
    required this.noteEntretien,
    required this.noteTest,
    required this.candidat,
  });

  factory DossierAdmission.fromJson(Map<String, dynamic> json) {
    return DossierAdmission(
      id: json['id'],
      copieCni: json['copieCni'],
      releveNotes: json['releveNotes'],
      diplome: json['diplome'],
      statut: json['statut'],
      noteEntretien: json['noteEntretien'],
      noteTest: json['noteTest'],
      remarque: json['remarque'],
      candidat: json['candidat'] != null
          ? CandidatPreInscrit.fromJson(json['candidat'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'copieCni': copieCni,
      'releveNotes': releveNotes,
      'diplome': diplome,
      'statut': statut,
      'remarque': remarque,
      'noteTest': noteTest,
      'noteEntretien': noteEntretien,
      'candidatId': candidat?.id,
    };
  }
}
