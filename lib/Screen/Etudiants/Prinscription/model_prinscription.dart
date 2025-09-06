import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Document/model_document.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/model_admission.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';

class CandidatPreInscrit {
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
  final DateTime? dateAjout;
  final Filiere? filiereSouhaitee;
  final Niveau? niveauSouhaite;
  final AnneeAcademique? anneeAcademique; // <-- corrigé

  CandidatPreInscrit({
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
    this.dateAjout,
    this.filiereSouhaitee,
    this.niveauSouhaite,
    this.anneeAcademique,
  });

  factory CandidatPreInscrit.fromJson(Map<String, dynamic> json) {
    return CandidatPreInscrit(
      id: json['id'],
      prenom: json['prenom'],
      nom: json['nom'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      sexe: json['sexe'],
      email: json['email'],
      password: json['password'],
      dateDeNaissance: json['dateDeNaissance'] != null
          ? DateTime.tryParse(json['dateDeNaissance'])
          : null,
      imagePath: json['imagePath'],
      paysDeNaissance: json['paysDeNaissance'],
      cni: json['cni'],
      ine: json['ine'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      documents: (json['documents'] as List? ?? [])
          .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
          .toList(),
      dossierAdmission: json['dossierAdmission'] != null
          ? DossierAdmission.fromJson(json['dossierAdmission'])
          : null,
      anneeAcademique: json['anneeAcademique'] != null // <-- corrigé
          ? AnneeAcademique.fromJson(json['anneeAcademique'])
          : null,
      filiereSouhaitee: json['filiereSouhaitee'] != null
          ? Filiere.fromJson(json['filiereSouhaitee'])
          : null,
      niveauSouhaite: json['niveauSouhaite'] != null
          ? Niveau.fromJson(json['niveauSouhaite'])
          : null,
      departement: json['departement'] != null
          ? Departement.fromJson(json['departement'])
          : null,
      dateAjout: json['dateAjout'] != null
          ? DateTime.tryParse(json['dateAjout'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'filiere': filiereSouhaitee != null ? {'id': filiereSouhaitee!.id} : null,
      'anneeAcademique':
          anneeAcademique != null ? {'id': anneeAcademique!.id} : null,
      'niveau': niveauSouhaite != null ? {'id': niveauSouhaite!.id} : null,
      'departement': departement != null ? {'id': departement!.id} : null,
    };
  }
}
