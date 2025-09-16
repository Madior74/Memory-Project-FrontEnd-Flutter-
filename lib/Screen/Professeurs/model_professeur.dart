import 'package:intl/intl.dart';
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
  final String? password;
  final String status;
  final List<Specialite> specialites;
  final Region? region;
  final Departement? departement;

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
    required this.status,
    required this.specialites,
    this.region,
    this.departement,
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
      status: json['status'],
      password: json['password'],
      specialites: (json['specialites'] as List<dynamic>)
          .map((e) => Specialite.fromJson(e))
          .toList(),
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      departement: json['departement'] != null
          ? Departement.fromJson(json['departement'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'paysDeNaissance': paysDeNaissance,
      'dateDeNaissance': dateDeNaissance.toIso8601String().substring(0, 10),
      'imagePath': imagePath,
      'password': password,
      'cni': cni,
      'ine': ine,
      'status': status,
      'telephone': telephone,
      'sexe': sexe,
      'email': email,
      'region': region != null ? {'id': region!.id} : null,
      'departement': departement?.toJson(),
      'specialites': specialites.map((s) => s.toJson()).toList(),
    };
  }
}
