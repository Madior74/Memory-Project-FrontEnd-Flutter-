class Salle {
  int? id;
  String? nomSalle;
  String? equipements;

  Salle({this.id, this.nomSalle, this.equipements});

  Salle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomSalle = json['nomSalle'];
    equipements = json['equipements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomSalle'] = this.nomSalle;
    data['equipements'] = this.equipements;
    return data;
  }
}
