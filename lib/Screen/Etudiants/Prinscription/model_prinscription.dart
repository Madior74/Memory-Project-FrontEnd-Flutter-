import 'package:intl/intl.dart';
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
  final List<Document>? documents; // Liste des documents téléversés
  final DossierAdmission? dossierAdmission; // Dossier d'admission
  final Departement? departement;
  final DateTime? dateAjout;
  final Filiere? filiereSouhaitee;
  final Niveau? niveauSouhaite;

  CandidatPreInscrit(
      {this.id,
      required this.prenom,
      required this.nom,
      required this.adresse,
      required this.telephone,
      required this.sexe,
      required this.email,
      required this.password,
      required this.dateDeNaissance,
      required this.imagePath,
      required this.paysDeNaissance,
      required this.cni,
      required this.ine,
      required this.region,
      required this.departement,
      required this.dateAjout,
      required this.filiereSouhaitee,
      required this.niveauSouhaite,
      this.documents,
      this.dossierAdmission});

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
          ? DateTime.parse(json['dateDeNaissance'])
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
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

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
      'filiereSouhaitee':
          filiereSouhaitee != null ? {'id': filiereSouhaitee!.id} : null,
      'niveauSouhaite':
          niveauSouhaite != null ? {'id': niveauSouhaite!.id} : null,
      'departement': departement != null ? {'id': departement!.id} : null,
      'dateAjout': dateAjout != null ? dateFormat.format(dateAjout!) : null,
    };
  }
}
