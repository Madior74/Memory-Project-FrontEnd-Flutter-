class CandidatDto {
  int id;
  String nom;
  String prenom;
  String email;
  int filiereId;
  int niveauId;
  int anneeAcademiqueId;

  CandidatDto({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.filiereId,
    required this.niveauId,
    required this.anneeAcademiqueId,
  });

  factory CandidatDto.fromJson(Map<String, dynamic> json) => CandidatDto(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        email: json["email"],
        filiereId: json["filiereId"],
        niveauId: json["niveauId"],
        anneeAcademiqueId: json["anneeAcademiqueId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "filiereId": filiereId,
        "niveauId": niveauId,
        "anneeAcademiqueId": anneeAcademiqueId,
      };
}
