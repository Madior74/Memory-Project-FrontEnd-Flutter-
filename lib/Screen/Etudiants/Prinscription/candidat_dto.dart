class CandidatSimple {
  final int id;
  final String nom;
  final String prenom;

  CandidatSimple({
    required this.id,
    required this.nom,
    required this.prenom,
  });

  factory CandidatSimple.fromJson(Map<String, dynamic> json) {
    return CandidatSimple(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
    );
  }

  String get fullName => '$prenom $nom';
}