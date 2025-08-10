import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';

class Filiere {
  final int? id;
  final String nomFiliere;
  final String description;
  final List<Niveau> niveaux;

  Filiere({this.id, required this.nomFiliere, required  this.description, this.niveaux = const []});
  
  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      id: json['id'] as int?,
      nomFiliere: json['nomFiliere'] ?? "",
      description: json['description'] ?? "",
      niveaux: (json['niveaux'] as List? ?? [])
          .map((niveau) => Niveau.fromJson(niveau as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomFiliere': nomFiliere,
      'description': description,
      'niveaux': niveaux.map((niveau) => niveau.toJson()).toList(),
    };
  }


  
}
