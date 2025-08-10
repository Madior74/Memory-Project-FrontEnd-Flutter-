import 'package:school_management_system/Screen/Region/model_region.dart';

class Departement {
  final int id;
  final String nomDepartement;
  final Region? region;

  Departement({
    required this.id,
    required this.nomDepartement,
    required this.region,
  });

  factory Departement.fromJson(Map<String, dynamic> json) {
    return Departement(
      id: json['id'] as int,
      nomDepartement: json['nomDepartement'] ?? "",
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomDepartement': nomDepartement,
      'region': region?.toJson(),
    };
  }
}
