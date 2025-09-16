class EtudiantAssiduiteDto {
  int id;
  String prenom;
  String nom;
  String email;
  int filiereId;
  int niveauId;
  int anneeAcademiqueId;
  DateTime dateInscription;

  EtudiantAssiduiteDto({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.filiereId,
    required this.niveauId,
    required this.anneeAcademiqueId,
    required this.dateInscription,
  });

  factory EtudiantAssiduiteDto.fromJson(Map<String, dynamic> json) =>
      EtudiantAssiduiteDto(
        id: json["id"],
        prenom: json["prenom"],
        nom: json["nom"],
        email: json["email"],
        filiereId: json["filiereId"],
        niveauId: json["niveauId"],
        anneeAcademiqueId: json["anneeAcademiqueId"],
        dateInscription: DateTime.parse(json["dateInscription"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prenom": prenom,
        "nom": nom,
        "filiereId": filiereId,
        "niveauId": niveauId,
        "anneeAcademiqueId": anneeAcademiqueId,
        "dateInscription": dateInscription.toIso8601String(),
      };
}
