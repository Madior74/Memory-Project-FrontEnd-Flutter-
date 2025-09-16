import 'dart:ffi';

import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
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
}
