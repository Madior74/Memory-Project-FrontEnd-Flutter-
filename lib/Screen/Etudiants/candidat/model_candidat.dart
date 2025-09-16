import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Document/model_document.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';

class Candidat {
  final int? id;
  final String? prenom;
  final String? nom;
  final String? adresse;
  final String? telephone;
  final String? sexe;
  final String? email;
  final String? password;
  final DateTime? dateDeNaissance;
  final String? imagePath;
  final String? paysDeNaissance;
  final String? cni;
  final String? ine;
  final Region? region;
  final List<Document>? documents;
  final DossierAdmission? dossierAdmission;
  final Departement? departement;
  final Filiere? filiereSouhaitee;
  final Niveau? niveauSouhaite;
  final Filiere? filiere;
  final Niveau? niveau;
  final AnneeAcademique? anneeAcademique;

  Candidat({
    this.id,
    this.prenom,
    this.nom,
    this.adresse,
    this.telephone,
    this.sexe,
    this.email,
    this.password,
    this.dateDeNaissance,
    this.imagePath,
    this.paysDeNaissance,
    this.cni,
    this.ine,
    this.region,
    this.documents,
    this.dossierAdmission,
    this.departement,
    this.filiereSouhaitee,
    this.niveauSouhaite,
    this.filiere,
    this.niveau,
    this.anneeAcademique,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'],
      prenom: json['prenom']?.toString(),
      nom: json['nom']?.toString(),
      adresse: json['adresse']?.toString(),
      telephone: json['telephone']?.toString(),
      sexe: json['sexe']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      dateDeNaissance: json['dateDeNaissance'] != null
          ? DateTime.tryParse(json['dateDeNaissance'].toString())
          : null,
      imagePath: json['imagePath']?.toString(),
      paysDeNaissance: json['paysDeNaissance']?.toString(),
      cni: json['cni']?.toString(),
      ine: json['ine']?.toString(),
      region: json['region'] != null && json['region'] is Map<String, dynamic> 
          ? Region.fromJson(json['region'] as Map<String, dynamic>) 
          : null,
      documents: (json['documents'] as List? ?? [])
          .where((doc) => doc != null && doc is Map<String, dynamic>)
          .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
          .toList(),
      dossierAdmission: json['dossierAdmission'] != null && json['dossierAdmission'] is Map<String, dynamic>
          ? DossierAdmission.fromJson(json['dossierAdmission'] as Map<String, dynamic>)
          : null,
      anneeAcademique: json['anneeAcademique'] != null && json['anneeAcademique'] is Map<String, dynamic>
          ? AnneeAcademique.fromJson(json['anneeAcademique'] as Map<String, dynamic>)
          : null,
      filiereSouhaitee: json['filiereSouhaitee'] != null && json['filiereSouhaitee'] is Map<String, dynamic>
          ? Filiere.fromJson(json['filiereSouhaitee'] as Map<String, dynamic>)
          : null,
      niveauSouhaite: json['niveauSouhaite'] != null && json['niveauSouhaite'] is Map<String, dynamic>
          ? Niveau.fromJson(json['niveauSouhaite'] as Map<String, dynamic>)
          : null,
      filiere: json['filiere'] != null && json['filiere'] is Map<String, dynamic> 
          ? Filiere.fromJson(json['filiere'] as Map<String, dynamic>) 
          : null,
      niveau: json['niveau'] != null && json['niveau'] is Map<String, dynamic> 
          ? Niveau.fromJson(json['niveau'] as Map<String, dynamic>) 
          : null,
      departement: json['departement'] != null && json['departement'] is Map<String, dynamic>
          ? Departement.fromJson(json['departement'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'sexe': sexe,
      'email': email,
      'password': password,
      'dateDeNaissance': dateDeNaissance?.toIso8601String().substring(0, 10),
      'imagePath': imagePath,
      'paysDeNaissance': paysDeNaissance,
      'cni': cni,
      'ine': ine,
      'region': region != null ? {'id': region!.id} : null,
      'filiereSouhaitee':
          filiereSouhaitee != null ? {'id': filiereSouhaitee!.id} : null,
      'anneeAcademique':
          anneeAcademique != null ? {'id': anneeAcademique!.id} : null,
      'niveauSouhaite':
          niveauSouhaite != null ? {'id': niveauSouhaite!.id} : null,
      'filiere': filiere != null ? {'id': filiere!.id} : null,
      'niveau': niveau != null ? {'id': niveau!.id} : null,
      'departement': departement != null ? {'id': departement!.id} : null,
    };
  }
}
