import 'package:school_management_system/Screen/Etudiants/Prinscription/candidat_dto.dart';

class DossierAdmissionDTO {
  final int id;
  final bool copieCni;
  final bool releveNotes;
  final bool diplome;
  final String remarque;
  final double noteTest;
  final double noteEntretien;
  final String status;
  final CandidatSimple candidat;

  DossierAdmissionDTO({
    required this.id,
    required this.copieCni,
    required this.releveNotes,
    required this.diplome,
    required this.remarque,
    required this.noteTest,
    required this.noteEntretien,
    required this.status,
    required this.candidat,
  });

  factory DossierAdmissionDTO.fromJson(Map<String, dynamic> json) {
    return DossierAdmissionDTO(
      id: json['id'],
      copieCni: json['copieCni'] ?? false,
      releveNotes: json['releveNotes'] ?? false,
      diplome: json['diplome'] ?? false,
      remarque: json['remarque'] ?? '',
      noteTest: (json['noteTest'] as num?)?.toDouble() ?? 0.0,
      noteEntretien: (json['noteEntretien'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'inconnu',
      candidat: CandidatSimple.fromJson(json['candidat']),
    );
  }
}