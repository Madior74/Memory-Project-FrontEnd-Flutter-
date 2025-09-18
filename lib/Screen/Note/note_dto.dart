class NoteDTO {
  int? id;
  double valeur;
  int etudiantId;
  int evaluationId;
  String? nomEtudiant;
  String? prenomEtudiant;

  NoteDTO({
     this.id,
    required this.valeur,
    required this.etudiantId,
    required this.evaluationId,
     this.nomEtudiant,
     this.prenomEtudiant,
  });

  factory NoteDTO.fromJson(Map<String, dynamic> json) => NoteDTO(
        id: json["id"],
        valeur: json["valeur"],
        etudiantId: json["etudiantId"],
        evaluationId: json["evaluationId"],
        nomEtudiant: json["nomEtudiant"],
        prenomEtudiant: json["prenomEtudiant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "valeur": valeur,
        "etudiantId": etudiantId,
        "evaluationId": evaluationId,
        "nomEtudiant": nomEtudiant,
        "prenomEtudiant": prenomEtudiant,
      };
}
