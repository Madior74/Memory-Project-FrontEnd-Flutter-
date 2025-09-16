import 'package:school_management_system/Screen/Etudiants/candidat/model_candidat.dart';

class DossierAdmissionDto {
  int id;
  bool copieCni;
  bool releveNotes;
  bool diplome;
  String remarque;
  double noteTest;
  double noteEntretien;
  String? niveauSouhaite;
  int? niveauSouhaiteId;
  String? filiereAcceptee;
  int? filiereAccepteeId;
  String status;
  String? filiereSouhaitee;
  int? filiereSouhaiteeId;
  String? niveauAccepte;
  int? niveauAccepteId;
  Candidat candidat;

  DossierAdmissionDto({
    required this.id,
    required this.copieCni,
    required this.releveNotes,
    required this.diplome,
    required this.remarque,
    required this.noteTest,
    required this.noteEntretien,
    this.niveauSouhaite,
    this.niveauSouhaiteId,
    this.filiereAcceptee,
    this.filiereAccepteeId,
    required this.status,
    this.filiereSouhaitee,
    this.filiereSouhaiteeId,
    this.niveauAccepte,
    this.niveauAccepteId,
    required this.candidat,
  });

  factory DossierAdmissionDto.fromJson(Map<String, dynamic> json) =>
      DossierAdmissionDto(
        id: json["id"],
        copieCni: json["copieCni"],
        releveNotes: json["releveNotes"],
        diplome: json["diplome"],
        remarque: json["remarque"],
        noteTest: json["noteTest"],
        noteEntretien: json["noteEntretien"],
        niveauSouhaite: json["niveauSouhaite"],
        niveauSouhaiteId: json["niveauSouhaiteId"],
        filiereAcceptee: json["filiereAcceptee"],
        filiereAccepteeId: json["filiereAccepteeId"],
        status: json["status"],
        filiereSouhaitee: json["filiereSouhaitee"],
        filiereSouhaiteeId: json["filiereSouhaiteeId"],
        niveauAccepte: json["niveauAccepte"],
        niveauAccepteId: json["niveauAccepteId"],
        candidat: Candidat.fromJson(json["candidat"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "copieCni": copieCni,
        "releveNotes": releveNotes,
        "diplome": diplome,
        "remarque": remarque,
        "noteTest": noteTest,
        "noteEntretien": noteEntretien,
        "niveauSouhaite": niveauSouhaite,
        "niveauSouhaiteId": niveauSouhaiteId,
        "filiereAcceptee": filiereAcceptee,
        "filiereAccepteeId": filiereAccepteeId,
        "status": status,
        "filiereSouhaitee": filiereSouhaitee,
        "filiereSouhaiteeId": filiereSouhaiteeId,
        "niveauAccepte": niveauAccepte,
        "niveauAccepteId": niveauAccepteId,
        "candidat": candidat.toJson(),
      };
}
