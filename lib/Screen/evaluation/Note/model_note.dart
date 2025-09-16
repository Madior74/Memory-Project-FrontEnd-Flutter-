

class Note {
  final int valeur;

  Note({required this.valeur});

  Map<String, dynamic> toJson() {
    return {
      'valeur': valeur,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      valeur: json['valeur'],
    );
  }
}