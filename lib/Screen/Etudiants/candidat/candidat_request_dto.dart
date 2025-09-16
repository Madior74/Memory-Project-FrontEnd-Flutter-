class CandidatRequestDto {
  int id;
  String nom;
  String prenom;
  String nomFiliere;
  String nomNiveau;
  int documentCount;

  CandidatRequestDto({
    required this.id,
    required this.documentCount,
    required this.nom,
    required this.prenom,
    required this.nomFiliere,
    required this.nomNiveau,
  });

  factory CandidatRequestDto.fromJson(Map<String, dynamic> json) =>
      CandidatRequestDto(
        id: json["id"],
        documentCount: json["documentCount"],
        nom: json["nom"],
        prenom: json["prenom"],
        nomFiliere: json["nomFiliere"],
        nomNiveau: json["nomNiveau"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "documentCount": documentCount,
        "prenom": prenom,
        "nomFiliere": nomFiliere,
        "nomNiveau": nomNiveau,
      };
}
