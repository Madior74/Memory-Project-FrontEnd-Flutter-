import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';

class Professeur {
  final int? id;
  final String nom;
  final String prenom;
  final String adresse;
  final String paysDeNaissance;
  final DateTime dateDeNaissance;
  final String imagePath;
  final String cni;
  final String ine;
  final String telephone;
  final String sexe;
  final String email;
  final String? password; // facultatif, envoyé seulement à l'inscription
  final String grade;
  final bool estPermanent;
  List<Specialite>? specialites;
  final Region? region;
  final Departement? departement;
  final DateTime dateAjout;

  Professeur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.paysDeNaissance,
    required this.dateDeNaissance,
    required this.imagePath,
    required this.cni,
    required this.ine,
    required this.telephone,
    required this.sexe,
    required this.email,
    this.password,
    required this.grade,
    required this.estPermanent,
    this.specialites,
    required this.region,
    required this.departement,
    required this.dateAjout,
  });

  factory Professeur.fromJson(Map<String, dynamic> json) {
    return Professeur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      adresse: json['adresse'],
      paysDeNaissance: json['paysDeNaissance'],
      dateDeNaissance: DateTime.parse(json['dateDeNaissance']),
      imagePath: json['imagePath'],
      cni: json['cni'],
      ine: json['ine'],
      telephone: json['telephone'],
      sexe: json['sexe'],
      email: json['email'],
      // 👇 password non présent dans les réponses JSON (sécurité)
      password: null,
      grade: json['grade'],
      estPermanent: json['estPermanent'],
      specialites: (json['specialites'] as List)
          .map((s) => Specialite.fromJson(s))
          .toList(),
      region: Region.fromJson(json['region']),
      departement: Departement.fromJson(json['departement']),
      dateAjout: DateTime.parse(json['dateAjout']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'paysDeNaissance': paysDeNaissance,
      'dateDeNaissance': dateDeNaissance.toIso8601String(),
      'imagePath': imagePath,
      'cni': cni,
      'ine': ine,
      'telephone': telephone,
      'sexe': sexe,
      'email': email,
      'grade': grade,
      'estPermanent': estPermanent,
      'specialites': specialites?.map((s) => s.toJson()).toList(),
      'region': region?.toJson(),
      'departement': departement?.toJson(),
      'dateAjout': dateAjout.toIso8601String(),
    };

    if (password != null) {
      data['password'] = password;
    }

    return data;
  }
}
