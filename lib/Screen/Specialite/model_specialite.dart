class Specialite {
  int? id;
  String? nom;
  String? description;

  Specialite({this.id, this.nom, this.description});

  Specialite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['description'] = this.description;
    return data;
  }
}