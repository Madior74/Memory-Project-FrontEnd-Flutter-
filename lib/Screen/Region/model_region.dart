import 'package:school_management_system/Screen/Region/Departements/departement.dart';

class Region {
  final int? id;
  final String nomRegion;
  final List<Departement> departements;

  Region({
    this.id,
    required this.nomRegion,
    this.departements = const [],
  });

  // Méthode fromJson
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as int?,
      nomRegion: json['nomRegion'] ?? "",
      departements: (json['departements'] as List? ?? [])
          .map((e) => Departement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomRegion': nomRegion,
      'departements': departements.map((d) => d.toJson()).toList(),
    };
  }
}
