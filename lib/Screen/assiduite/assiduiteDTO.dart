import 'package:school_management_system/Screen/Etudiants/Inscription/etudiant_assiduite_dto.dart';

class AssiduiteDto {
  int id;
  int? seanceId;
  EtudiantAssiduiteDto etudiantDto;
  String statutPresence;

  AssiduiteDto({
    required this.id,
    this.seanceId,
    required this.etudiantDto,
    required this.statutPresence,
  });

  factory AssiduiteDto.fromJson(Map<String, dynamic> json) => AssiduiteDto(
        id: json["id"],
        seanceId: json["seanceId"],
        etudiantDto: EtudiantAssiduiteDto.fromJson(json["etudiantDTO"]),
        statutPresence: json["statutPresence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seanceId": seanceId,
        "etudiantDTO": etudiantDto.toJson(),
        "statutPresence": statutPresence,
      };
}
