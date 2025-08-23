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
    required this.status,
    required this.region,
    required this.departement,
    required this.dateAjout,
    required this.specialites,
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
      status: json['status'],
      specialites: (json['specialites'] as List<dynamic>)
          .map((e) => Specialite.fromJson(e))
          .toList(),
      region: Region.fromJson(json['region']),
      departement: Departement.fromJson(json['departement']),
      dateAjout: DateTime.parse(json['dateAjout']),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['prenom'] = this.prenom;
    data['adresse'] = this.adresse;
    data['paysDeNaissance'] = this.paysDeNaissance;
    data['dateDeNaissance'] = this.dateDeNaissance;
    data['imagePath'] = this.imagePath;
    data['cni'] = this.cni;
    data['ine'] = this.ine;
    data['telephone'] = this.telephone;
    data['sexe'] = this.sexe;
    data['email'] = this.email;
    data['status'] = this.status;
    if (this.specialites != null) {
      data['specialites'] = this.specialites!.map((v) => v.toJson()).toList();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    if (this.departement != null) {
      data['departement'] = this.departement!.toJson();
    }
    data['dateAjout'] = this.dateAjout;
    return data;
  }
}
