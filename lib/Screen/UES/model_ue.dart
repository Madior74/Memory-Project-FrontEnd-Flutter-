import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/semestre/model_semestre.dart';

class UE {
  final int? id;
  final String nomUE;
  final String codeUE;
  final Semestre? semestre;
  final List<Module> modules;
  final DateTime? dateAjout;

  UE({
    this.id,
    required this.nomUE,
    required this.codeUE,
    required this.semestre,
    required this.dateAjout,
    this.modules = const [],
  });

  factory UE.fromJson(Map<String, dynamic> json) {
    return UE(
      id: json['id'],
      nomUE: json['nomUE'] ?? "Nom inconnu",
      codeUE: json['codeUE'] ?? "Code inconnu",
      semestre:
          json['semestre'] != null ? Semestre.fromJson(json['semestre']) : null,
      dateAjout: json['dateAjout'] != null
          ? DateTime.tryParse(json['dateAjout'])
          : null,
      modules: (json['modules'] != null)
          ? (json['modules'] as List)
              .map((module) => Module.fromJson(module))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomUE': nomUE,
      'codeUE': codeUE,
      'semestre': {'id': semestre?.id},
      'dateAjout': dateAjout?.toIso8601String().substring(0, 23),
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }

  // Méthode pour calculer le nombre total de crédits
  double getTotalCredits() {
    return modules.fold(
        0, (sum, module) => sum + (module.creditModule?.toDouble() ?? 0));
  }

  //Volume horaire total
  int getTotalVolumeHoraire() {
  return modules.fold(
      0, (sum, module) => sum + (module.volumeHoraire ?? 0));
}

//Nombre de modules 


}
