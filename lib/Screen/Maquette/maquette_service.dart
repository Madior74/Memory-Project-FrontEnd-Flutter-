// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:school_management_system/Classes/MaquetteSemestreDTO.dart';

// Future<MaquetteSemestreDTO> fetchMaquette(int semestreId) async {
//   final response = await http
//       .get(Uri.parse('http://localhost:9000/api/maquettes/$semestreId'));

//   if (response.statusCode == 200) {
//     return MaquetteSemestreDTO.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Erreur lors du chargement de la maquette');
//   }
// }
