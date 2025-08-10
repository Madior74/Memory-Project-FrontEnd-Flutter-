import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';

class MaquetteSemestre {
  final String nomSemestre;
  final Niveau niveau;
  final String filiere;
  final double totalVolumeHoraire;
  final double totalCredits;
  final int nombreModules;
  final List<UE> ues;

  MaquetteSemestre({
    required this.nomSemestre,
    required this.niveau,
    required this.filiere,
    required this.totalVolumeHoraire,
    required this.totalCredits,
    required this.nombreModules,
    required this.ues,
  });
  factory MaquetteSemestre.fromJson(Map<String, dynamic> json) {
    return MaquetteSemestre(
      nomSemestre: json['nomSemestre'],
      niveau: Niveau.fromJson(json['niveau']), // Mapper l'objet imbriqué
      filiere: json['filiere'], // Chaîne de caractères directe
      totalCredits: (json['totalCredits'] as num?)?.toDouble() ?? 0.0, // Gérer les valeurs null
      totalVolumeHoraire: (json['totalVolumeHoraire'] as num?)?.toDouble() ?? 0.0, // Gérer les valeurs null
      nombreModules: json['nombreModules'] ?? 0, // Remplacer null par 0
      ues: (json['ues'] as List<dynamic>? ?? [])
          .map((ue) => UE.fromJson(ue))
          .toList(),
    );
  }
}
