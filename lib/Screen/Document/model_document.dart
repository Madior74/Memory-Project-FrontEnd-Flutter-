class Document {
  final int id;
  final String nom;
  final String type;
  final String cheminFichier;
  final DateTime dateDepot;
  final int? etudiantId;

  Document({
    required this.id,
    required this.nom,
    required this.type,
    required this.cheminFichier,
    required this.dateDepot,
    required this.etudiantId,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      cheminFichier: json['cheminFichier'],
      dateDepot: DateTime.parse(json['dateDepot']),
      etudiantId: json['etudiantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'cheminFichier': cheminFichier,
      'dateDepot': dateDepot.toIso8601String(),
      'etudiantId': etudiantId,
    };
  }
}
