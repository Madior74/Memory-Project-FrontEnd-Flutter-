import 'package:school_management_system/Screen/Etudiants/Admission/dossier_admissionDTO.dart';

class InscriptionDTO {
  final int? id;
  final int filiereId;
  final int niveauId;
  final int anneeAcademiqueId;
  final double montantVerse;
  final DateTime? dateInscription;
  final DossierAdmissionDTO dossierAdmissionDTO;

  InscriptionDTO({
    this.id,
    required this.filiereId,
    required this.niveauId,
    required this.anneeAcademiqueId,
    required this.montantVerse,
    required this.dateInscription,
    required this.dossierAdmissionDTO,
  });

  factory InscriptionDTO.fromJson(Map<String, dynamic> json) {
    return InscriptionDTO(
      id: json['id'],
      filiereId: json['filiere'] as int,
      niveauId: json['niveau'] as int,
      anneeAcademiqueId: json['anneeAcademique'] as int,
      montantVerse: (json['montantVerse'] as num).toDouble(),
      dateInscription: json['dateInscription'] != null
          ? DateTime.parse(json['dateInscription'])
          : null,
      dossierAdmissionDTO: DossierAdmissionDTO.fromJson(
        json['dossierAdmissionDTO'] as Map<String, dynamic>,
      ),
    );
  }
}