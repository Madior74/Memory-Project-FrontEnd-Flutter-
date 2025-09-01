import 'package:school_management_system/Screen/Note/Devoir/model_devoir.dart';
import 'package:school_management_system/Screen/UES/model_ue.dart';

class Module {
  final int? id;
  final String nomModule; // Nom du module
  final String? nomUE; // Nom du module
  final int volumeHoraire; // Volume horaire du module
  final double creditModule; // Crédits du module
  final DateTime? dateAjout; // Date d'ajout du module
  final UE? ue; // UE associée (peut être null)
  final List<Devoir> devoirNotes; // Liste des devoirNotes associées

  // Constructeur
  Module({
    this.id,
    this.nomUE,
    required this.nomModule,
    required this.volumeHoraire,
    required this.creditModule,
    this.dateAjout,
    this.ue,
    this.devoirNotes = const [], // Liste des devoirNotes initialisée par défaut
  });

  // Factory pour créer un Module à partir d'un JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nomModule: json['nomModule'] ?? "Nom inconnu",
      nomUE: json['nomUE'] ?? "Nom inconnu",
      volumeHoraire: json['volumeHoraire'] ?? 0,
      creditModule: json['creditModule'] ?? 0.0,
      dateAjout: json['dateAjout'] != null
          ? DateTime.tryParse(json['dateAjout'])
          : null,
      ue: json['ue'] != null ? UE.fromJson(json['ue']) : null,
      devoirNotes: (json['devoirNotes'] != null)
          ? (json['devoirNotes'] as List)
              .map((note) => Devoir.fromJson(note))
              .toList()
          : [],
    );
  }

  // Convertir un Module en JSON (pour l'envoi au serveur)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomModule': nomModule,
      'volumeHoraire': volumeHoraire,
      'creditModule': creditModule,
      'dateAjout': dateAjout?.toIso8601String(),

      'ue':
          ue != null ? {'id': ue!.id} : null, // Envoyer uniquement l'ID de l'UE
      'devoirNotes': devoirNotes
          .map((note) => note.toJson())
          .toList(), // Convertir les devoirNotes en JSON
    };
  }
}
