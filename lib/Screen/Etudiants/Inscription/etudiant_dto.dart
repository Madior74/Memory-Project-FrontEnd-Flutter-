import 'package:school_management_system/Screen/Etudiants/Admission/admission_dto.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';

class EtudiantDTO {
  int id;
  String prenom;
  String nom;
  int filiere;
  int niveau;
  int anneeAcademique;
  DossierAdmissionDto dossierAdmissionDto;
  DateTime dateInscription;

  EtudiantDTO({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.filiere,
    required this.niveau,
    required this.anneeAcademique,
    required this.dossierAdmissionDto,
    required this.dateInscription,
  });

  factory EtudiantDTO.fromJson(Map<String, dynamic> json) => EtudiantDTO(
        id: json["id"],
        prenom: json["prenom"],
        nom: json["nom"],
        filiere: json["filiere"],
        niveau: json["niveau"],
        anneeAcademique: json["anneeAcademique"],
        dossierAdmissionDto:
            DossierAdmissionDto.fromJson(json["dossierAdmissionDTO"]),
        dateInscription: DateTime.parse(json["dateInscription"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prenom": prenom,
        "nom": nom,
        "filiere": filiere,
        "niveau": niveau,
        "anneeAcademique": anneeAcademique,
        "dossierAdmissionDTO": dossierAdmissionDto.toJson(),
        "dateInscription": dateInscription.toIso8601String(),
      };
}
