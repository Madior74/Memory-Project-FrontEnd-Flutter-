import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/semestre/model_semestre.dart';



class Cours {
  final int id;
  final Professeur professeur;
  final Module module;
  final Filiere filiere;
  final Niveau niveau;
  final Semestre semestre;
  final String? salle;
  final String jour;
  final String heureDebut;
  final String heureFin;
  final DateTime dateDebut;
  final DateTime dateFin;
  final bool estRemplacement;
  final DateTime dateAjout;

  Cours({
    required this.id,
    required this.professeur,
    required this.module,
    required this.filiere,
    required this.niveau,
    required this.semestre,
    this.salle,
    required this.jour,
    required this.heureDebut,
    required this.heureFin,
    required this.dateDebut,
    required this.dateFin,
    required this.estRemplacement,
    required this.dateAjout,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: json['id'],
      professeur: Professeur.fromJson(json['professeur']),
      module: Module.fromJson(json['module']),
      filiere: Filiere.fromJson(json['filiere']),
      niveau: Niveau.fromJson(json['niveau']),
      semestre: Semestre.fromJson(json['semestre']),
      salle: json['salle'],
      jour: json['jour'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      estRemplacement: json['estRemplacement'],
      dateAjout: DateTime.parse(json['dateAjout']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'professeur': professeur.toJson(),
      'module': module.toJson(),
      'filiere': filiere.toJson(),
      'niveau': niveau.toJson(),
      'semestre': semestre.toJson(),
      'salle': salle,
      'jour': jour,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'estRemplacement': estRemplacement,
      'dateAjout': dateAjout.toIso8601String(),
    };
  }
}
