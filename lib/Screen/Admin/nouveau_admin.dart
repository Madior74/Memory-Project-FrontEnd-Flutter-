import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({Key? key}) : super(key: key);

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  late String nom;
  late String prenom;
  late String adresse;
  late String paysDeNaissance;
  late String dateDeNaissance; // On va utiliser un DatePicker
  late String cni;
  late String ine;
  late String telephone;
  late String sexe = 'HOMME'; // Valeur par défaut
  late String email;
  late String password;

  final List<String> sexes = ['HOMME', 'FEMME'];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      final url = Uri.parse('http://192.168.1.15:9000/api/auth/admin/register');

      final body = jsonEncode({
        "nom": nom,
        "prenom": prenom,
        "adresse": adresse,
        "paysDeNaissance": paysDeNaissance,
        "dateDeNaissance": dateDeNaissance,
        "cni": cni,
        "ine": ine,
        "telephone": telephone,
        "sexe": sexe,
        "email": email,
        "password": password,
        "regionId":
            1, // TODO: À remplacer par une sélection dynamique si nécessaire
        "departementId": 1,
      });

      try {
        final response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ Admin enregistré avec succès")),
          );
          Navigator.pop(context); // Retour à l'écran précédent
        } else {
          final errorMessage = jsonDecode(response.body)['message'] ??
              'Erreur lors de l\'enregistrement';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ $errorMessage")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur de connexion : $e")),
        );
      }
    }
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateDeNaissance =
            "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dateDeNaissance =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription Administrateur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                onSaved: (value) => nom = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                onSaved: (value) => prenom = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse'),
                onSaved: (value) => adresse = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pays de Naissance'),
                onSaved: (value) => paysDeNaissance = value!,
              ),
              SizedBox(height: 10),
              InputDecorator(
                decoration: InputDecoration(labelText: 'Date de Naissance'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateDeNaissance),
                    IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'CNI'),
                onSaved: (value) => cni = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'INE'),
                onSaved: (value) => ine = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Téléphone'),
                onSaved: (value) => telephone = value!,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sexe'),
                items: sexes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => sexe = value!),
                value: sexe,
                validator: (value) =>
                    value == null ? 'Veuillez choisir un genre' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                onSaved: (value) => password = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("S'inscrire"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
