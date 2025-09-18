class AnneeAcademique {
  final int? id;
  final String nomAnnee;
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final bool? active;

  AnneeAcademique({
    this.id,
    required this.nomAnnee,
     this.active,
     this.dateDebut, // Obligatoire
     this.dateFin, // Obligatoire
  });

  // Méthode pour convertir un JSON en objet Session
  factory AnneeAcademique.fromJson(Map<String, dynamic> json) {
    return AnneeAcademique(
      id: json['id'],
      active:json['active']?? false,
      nomAnnee: json['nomAnnee'] ?? "",
      dateDebut:
          json['dateDebut'] != null ? DateTime.parse(json['dateDebut']) : null,
      dateFin: json['dateFin'] != null ? DateTime.parse(json['dateFin']) : null,
    );
  }

  // Méthode pour convertir un objet Session en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active':active,
      'nomAnnee': nomAnnee,
      'dateDebut': dateDebut?.toIso8601String().substring(0, 10),
      'dateFin': dateFin?.toIso8601String().substring(0, 10)
    };
  }

  // bool get isEnCours {
  //   final now = DateTime.now();
  //   return dateDebut != null &&
  //       dateFin != null &&
  //       now.isAfter(dateDebut!) &&
  //       now.isBefore(dateFin!);
  // }

  String get etat {
    final now = DateTime.now();

    if (dateDebut == null || dateFin == null) {
      return "Non définie";
    }

    // Si l'année n'est pas active, elle est désactivée
    if (active == false) {
      return "Désactivée";
    }

    if (now.isBefore(dateDebut!)) {
      return "À venir";
    } else if (now.isAfter(dateFin!)) {
      return "Terminée";
    } else {
      return "En cours";
    }
  }
}
