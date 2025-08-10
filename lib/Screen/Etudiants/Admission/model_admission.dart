import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';

class DossierAdmission {
  final int? id;
  final bool copieCni;
  final bool releveNotes;
  final bool diplome;
  final String statut;
  final String remarque;
  final Etudiant? etudiant;

  DossierAdmission({
    this.id,
    required this.copieCni,
    required this.releveNotes,
    required this.diplome,
    required this.statut,
    required this.remarque,
    required this.etudiant,
  });

  factory DossierAdmission.fromJson(Map<String, dynamic> json) {
    return DossierAdmission(
      id: json['id'],
      copieCni: json['copieCni'],
      releveNotes: json['releveNotes'],
      diplome: json['diplome'],
      statut: json['statut'],
      remarque: json['remarque'],
      etudiant:
          json['etudiant'] != null ? Etudiant.fromJson(json['etudiant']) : null,
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
      'etudiant': {'id': etudiant?.id},
    };
  }
}
