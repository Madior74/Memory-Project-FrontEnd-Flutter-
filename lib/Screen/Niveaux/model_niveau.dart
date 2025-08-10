import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/semestre/model_semestre.dart';

class Niveau {
  final int? id;
  final String nomNiveau;
  final Filiere? filiere;
  final List<Semestre> semestres;

  Niveau({
    this.id,
    required this.nomNiveau,
    this.filiere,
    this.semestres = const [],
  });

  factory Niveau.fromJson(Map<String, dynamic> json) {
    return Niveau(
      id: json['id'],
      nomNiveau: json['nomNiveau'] ?? "",
      filiere: json['filiere'] != null
          ? Filiere.fromJson(json['filiere'])
          : null, // Correction ici
      semestres: (json['semestres'] as List?)
              ?.map((s) => Semestre.fromJson(s))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomNiveau': nomNiveau,
      'filiere': filiere?.toJson(),
      'semestres': semestres.map((s) => s.toJson()).toList(),
    };
  }
}
