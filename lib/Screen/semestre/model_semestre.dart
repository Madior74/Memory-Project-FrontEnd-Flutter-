import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';

class Semestre {
  final int? id;
  final String nomSemestre;
  final Niveau? niveau;
  final List<UE> ues;

  Semestre({
    required this.id,
    required this.nomSemestre,
    this.niveau,
    this.ues = const [],
  });
  factory Semestre.fromJson(Map<String, dynamic> json) {
    return Semestre(
      id: json['id'],
      nomSemestre: json['nomSemestre'] ?? "",
      niveau: json['niveau'] != null ? Niveau.fromJson(json['niveau']) : null,
      ues: json['ues'] != null && json['ues'] is List
          ? (json['ues'] as List).map((ue) => UE.fromJson(ue)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomSemestre': nomSemestre,
      'niveau': niveau?.toJson(), // Correction ici
      'ues': ues.map((ue) => ue.toJson()).toList(),
    };
  }

  // Méthode pour calculer le nombre total de crédits
  double getTotalCredits() {
    return ues.fold(
        0, (sum, ue) => sum + (ue.getTotalCredits() ?? 0));
  }
  //Volume horaire total
  int getTotalVolumeHoraire() {
    return ues.fold(
        0, (sum, ue) => sum + (ue.getTotalVolumeHoraire() ?? 0));
  }
  // Méthode pour calculer le nombre total de modules
  int getTotalModules() {
    return ues.fold(
        0, (sum, ue) => sum + (ue.modules.length ?? 0));
  }
  // Méthode pour calculer le nombre total de modules
  int getTotalUEs() {
    return ues.length;
  }
  // Méthode pour calculer le nombre total de modules
  int getTotalModulesBySemestre() {
    return ues.fold(
        0, (sum, ue) => sum + (ue.modules.length ?? 0));
  }
  // Méthode pour calculer le nombre total de modules
  int getTotalUEsBySemestre() {
    return ues.length;
  }
}
