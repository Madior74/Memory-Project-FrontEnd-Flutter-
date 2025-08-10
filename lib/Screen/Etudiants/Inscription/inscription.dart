import 'dart:ffi';

import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';

class Inscription {
  final int? id;
  final Etudiant? etudiant;
  final Filiere? filiere;
  final Niveau? niveau;
  final AnneeAcademique? anneeAcademique;
  final DateTime? dateInscription;
  final double montantVerse;

  Inscription({
    this.id,
    required this.anneeAcademique,
    required this.filiere,
    required this.dateInscription,
    required this.montantVerse,
    required this.niveau,
    required this.etudiant,
  });

  factory Inscription.fromJson(Map<String, dynamic> json) {
    return Inscription(
      id: json['id'],
      anneeAcademique: AnneeAcademique.fromJson(json['anneeAcademique']),
      filiere:
          json['filiere'] != null ? Filiere.fromJson(json['filiere']) : null,
      dateInscription: json['dateInscription'] != null
          ? DateTime.parse(json['dateInscription'])
          : null,
      montantVerse: json['montantVerse']?.toDouble() ?? 0.0,
      niveau: json['niveau'] != null ? Niveau.fromJson(json['niveau']) : null,
      etudiant:
          json['etudiant'] != null ? Etudiant.fromJson(json['etudiant']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'etudiant': {'id': etudiant?.id},
      'filiere': {'id': filiere?.id},
      'niveau': {'id': niveau?.id},
      'anneeAcademique': {'id': anneeAcademique?.id},
      'dateInscription': dateInscription != null
          ? dateInscription!.toIso8601String().substring(0, 10)
          : null,
      'montantVerse': montantVerse,
    };
  }
}
