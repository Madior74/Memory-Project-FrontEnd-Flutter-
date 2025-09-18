import 'dart:ffi';

import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant_dto.dart';
import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';

class Etudiant {
  final int? id;
  final DossierAdmission? dossierAdmission;

  final Filiere? filiere;
  final Niveau? niveau;
  final AnneeAcademique? anneeAcademique;
  final bool paye;

  Etudiant({
    this.id,
    required this.paye,
    required this.anneeAcademique,
    required this.filiere,
    required this.niveau,
    required this.dossierAdmission,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'],
      paye: json['paye'] ?? false,
      filiere:
          json['filiere'] != null ? Filiere.fromJson(json['filiere']) : null,
      anneeAcademique: json['anneeAcademique'] != null
          ? AnneeAcademique.fromJson(json['anneeAcademique'])
          : null,
      niveau: json['niveau'] != null ? Niveau.fromJson(json['niveau']) : null,
      dossierAdmission: json['dossierAdmission'] != null
          ? DossierAdmission.fromJson(json['dossierAdmission'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dossierAdmission': {'id': dossierAdmission?.id},
      'filiere': {'id': filiere?.id},
      'niveau': {'id': niveau?.id},
      'anneeAcademique': {'id': anneeAcademique?.id},
      'paye': paye,
    };
  }

  //Conversion
  factory Etudiant.fromEtudiantDTO(EtudiantDTO dto) {
    return Etudiant(
      id: dto.id,
      paye: false, // ou true selon ton besoin — à ajuster
      filiere: Filiere(
          id: dto.filiere,
          nomFiliere: dto.dossierAdmissionDto?.filiereAcceptee ?? "N/A",
          description: "N/A"), // tu peux charger le libellé si tu veux
      niveau: Niveau(id: dto.niveau, nomNiveau: "N/A"),
      anneeAcademique: AnneeAcademique(
        id: dto.anneeAcademique,
        nomAnnee: "N/A",
      ),
      dossierAdmission: DossierAdmission(
        id: dto.dossierAdmissionDto.id,
        candidat: Candidat(
          id: dto.dossierAdmissionDto.candidat.id,
          nom: dto.nom,
          prenom: dto.prenom,
          // ... autres champs si disponibles
        ),
        copieCni: dto.dossierAdmissionDto.copieCni,
        releveNotes: dto.dossierAdmissionDto.releveNotes,
        diplome: dto.dossierAdmissionDto.diplome,
        noteTest: dto.dossierAdmissionDto.noteTest,
        noteEntretien: dto.dossierAdmissionDto.noteEntretien,
        status: dto.dossierAdmissionDto.status,
        // ... autres champs de DossierAdmission si nécessaires
      ),
    );
  }
}
