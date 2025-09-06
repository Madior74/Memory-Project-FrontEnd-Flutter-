
import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Note/Devoir/model_devoir.dart';
import 'package:school_management_system/Screen/Note/model_examen.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Salle/model_salle.dart';

class Seance {
  final int? id;
  final Salle? salle;
  final bool estEnLigne;
  final DateTime? dateSeance;

  final TimeOfDay heureDebut;
  final TimeOfDay heureFin;

  final Module module;
  final Professeur professeur;
  final AnneeAcademique anneeAcademique;

  final bool estAnnulee;
  final List<Devoir>? devoirs;
  final List<Examen>? examens;

  Seance({
    this.id,
    required this.salle,
    required this.estEnLigne,
    required this.heureDebut,
    required this.heureFin,
    required this.dateSeance,
    required this.module,
    required this.professeur,
    required this.anneeAcademique,
    this.estAnnulee = false,
    this.devoirs,
    this.examens,
  });

  // --- Méthodes de sérialisation JSON ---
  factory Seance.fromJson(Map<String, dynamic> json) {
    final debutParts = json['heureDebut'].split(':');
    final finParts = json['heureFin'].split(':');

    final heureDebut = TimeOfDay(
        hour: int.parse(debutParts[0]), minute: int.parse(debutParts[1]));

    final heureFin =
        TimeOfDay(hour: int.parse(finParts[0]), minute: int.parse(finParts[1]));

    return Seance(
      id: json['id'],
      salle: json['salle'] != null ? Salle.fromJson(json['salle']) : null,
      estEnLigne: json['estEnLigne'] ?? false,
      dateSeance: json['dateSeance'] != null
          ? DateTime.parse(json['dateSeance'])
          : null,
      heureDebut: heureDebut,
      heureFin: heureFin,
      module: Module.fromJson(json['module']),
      professeur: Professeur.fromJson(json['professeur']),
      anneeAcademique: AnneeAcademique.fromJson(json['anneeAcademique']),
      estAnnulee: json['estAnnulee'] ?? false,
      devoirs: json['devoirs'] != null
          ? (json['devoirs'] as List).map((d) => Devoir.fromJson(d)).toList()
          : null,
      examens: json['examens'] != null
          ? (json['examens'] as List).map((e) => Examen.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    String formatTime(TimeOfDay time) {
      // Ajoute un zéro devant si nécessaire
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }

    return {
      'dateSeance': dateSeance?.toIso8601String().substring(0, 10),
      'heureDebut': formatTime(heureDebut),
      'heureFin': formatTime(heureFin),
      'salleId': salle?.id,
      'moduleId': module.id,
      'professeurId': professeur.id,
      'anneeAcademiqueId': anneeAcademique.id,
      'estEnLigne': estEnLigne,
    };
  }

  // --- Méthodes utilitaires ---

  String get formattedTimeDebut {
    return '${heureDebut.hour}:${heureDebut.minute.toString().padLeft(2, '0')}';
  }

  String get formattedTimeFin {
    return '${heureFin.hour}:${heureFin.minute.toString().padLeft(2, '0')}';
  }

  Duration get duree {
    final start = DateTime(0, 0, 0, heureDebut.hour, heureDebut.minute);
    final end = DateTime(0, 0, 0, heureFin.hour, heureFin.minute);
    return end.difference(start);
  }

  int getDureeEnHeures() {
    return heureFin.hour - heureDebut.hour;
  }

  bool get isConsidereeDeroulee {
    if (estAnnulee) return false;
    if (dateSeance == null) return false;
    final fin = DateTime(
      dateSeance!.year,
      dateSeance!.month,
      dateSeance!.day,
      heureFin.hour,
      heureFin.minute,
    );
    return fin.isBefore(DateTime.now());
  }

  String get dureeHMin {
    final d = duree;
    return '${d.inHours}h ${d.inMinutes % 60}min';
  }

  //Le status
  String get statut {
    if (estAnnulee) return 'Annulée';
    if (isConsidereeDeroulee) return 'Déroulée';
    if (dateSeance != null && dateSeance!.isAfter(DateTime.now())) {
      return 'Programmée';
    }
    return 'En Cours';
  }

  Color get statutColor {
    switch (statut) {
      case 'Annulée':
        return Colors.red;

      case 'Déroulée':
        return Colors.grey;
      case 'Programmée':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
