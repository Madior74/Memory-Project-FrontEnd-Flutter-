import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Professeurs/liste_des_professeurs.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Region/Departements/departement.dart';

import 'package:school_management_system/Screen/Region/model_region.dart';

import 'package:school_management_system/Screen/Region/Departements/departementService.dart';

import 'package:school_management_system/Screen/Region/regionService.dart';
import 'package:school_management_system/theme/colors.dart';

class UpdateProfesseur extends StatefulWidget {
  final Professeur professeur;
  const UpdateProfesseur({super.key, required this.professeur});

  @override
  State<UpdateProfesseur> createState() => _UpdateProfesseurState();
}

class _UpdateProfesseurState extends State<UpdateProfesseur> {
  bool _passwordInVisible = true;

  int? regionChoisieId;
  List<Region> _regions = [];

  int? departementChoisiId;
  List<Departement> _dept = [];

  CountryCode? selectedCountry;
  String sexeValue = 'Masculin';
  String? _selectedGender;
  DateTime? _selectedDate;
  int _index = 0;
  int value = 1;
  int selectedOption = 1;

  bool _estPermanent = false;
  String _selectedGrade = 'Professeur';

  //

  bool isEmail(String input) =>
      RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(input);
  bool isPhone(String input) => RegExp(r'^[0-9]{9}$').hasMatch(input);
  //Mes Controllers

  final _adresseEditController = TextEditingController();
  final _nomEditController = TextEditingController();
  final _cniEditController = TextEditingController();
  final _ineEditController = TextEditingController();

  final _prenomEditController = TextEditingController();
  final _telephoneEditController = TextEditingController();
  final _emailEditController = TextEditingController();
  final _passwordEditController = TextEditingController();
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("Aucune Image insérée");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRegions();
    if (widget.professeur != null) {
      _adresseEditController.text = widget.professeur.adresse!;
      _cniEditController.text = widget.professeur.cni!;
      _ineEditController.text = widget.professeur.ine!;
      _prenomEditController.text = widget.professeur.prenom!;
      _telephoneEditController.text = widget.professeur.telephone!;
      _nomEditController.text = widget.professeur.nom!;
      _selectedGender = widget.professeur.sexe;
      _emailEditController.text = widget.professeur.email!;
      _passwordEditController.text = widget.professeur?.password ?? '';
      _image = File(widget.professeur.imagePath!);

      regionChoisieId = widget.professeur.region?.id;
      departementChoisiId = widget.professeur.departement?.id;

      if (regionChoisieId != null) {
        _loaddepartements(regionChoisieId!);
      }

      setState(() {});
    }
  }

//Recuperer les regions
  Future<void> _loadRegions() async {
    try {
      final regions = await RegionService().getRegion();
      setState(() {
        _regions = regions;
      });
    } catch (e) {
      print("Erreur lors du chargement des filieres:$e");
      throw Exception('Erreur lors de la récupération des filières');
    }
  }

  //_loaddepartements
  Future<void> _loaddepartements(int regionId) async {
    try {
      final dptm = await DepartementService().getDepartementByRegion(regionId);
      setState(() {
        _dept = dptm;
      });
    } catch (e) {
      print("Erreur lors recuperation des departements $e");
      throw Exception("Erreur lors de la recupération des departements");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 3,
          shadowColor: Colors.black,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Mise a Jour des Informations ",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: personalInfoStep());
  }

  void _submit() async {
    print("Id de l'professeur :${widget.professeur.id}");
    // Validation du formulaire
    if (_formKey.currentState!.validate()) {
      final departementChoisi =
          _dept.firstWhereOrNull((d) => d.id == departementChoisiId);

      final regionChoisie =
          _regions.firstWhereOrNull((r) => r.id == regionChoisieId);

      // Vérification de la session choisie

      // Création de l'objet Etudiant
      final prof = Professeur(
          status: widget.professeur.status,
          id: widget.professeur.id,
          specialites: widget.professeur.specialites,
          prenom: _prenomEditController.text,
          nom: _nomEditController.text,
          adresse: _adresseEditController.text,
          telephone: _telephoneEditController.text,
          sexe: _selectedGender ?? 'Masculin',
          email: _emailEditController.text,
          dateDeNaissance: _selectedDate ?? DateTime.now(),
          imagePath: _image?.path ?? '',
          paysDeNaissance: selectedCountry?.name ?? 'Senegal',
          cni: _cniEditController.text,
          ine: _ineEditController.text,
          departement: departementChoisi ?? widget.professeur.departement,
          region: regionChoisie ?? widget.professeur.region);

      try {
        await ProfesseurService().updateProfesseur(prof.id!, prof);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              content: const Text('Professeur Mise à jour avec succès'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListeDesProfesseurs()),
                    );
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Erreur:$e");
        // Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    }
  }

//Les Information Personnelles
  Widget personalInfoStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo profil et logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: getImageGallery,
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _image!.absolute,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Image.asset(
                                          "assets/images/profil.png"),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: getImageGallery,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myblueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Choisir une Photo",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      // Logo
                      Padding(
                        padding: const EdgeInsets.only(right: 70.0),
                        child: Image.asset(
                          "assets/images/education.png",
                          height: 270,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // prenom ,Nom Sexe
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "le champs ne doit pas etre vide";
                            }
                            return null;
                          },
                          controller: _prenomEditController,
                          decoration: InputDecoration(
                            labelText: "Prénom",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "le champs ne doit pas etre vide";
                            }
                            return null;
                          },
                          controller: _nomEditController,
                          decoration: InputDecoration(
                            labelText: "Nom",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Sexe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Masculin',
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Masculin'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Féminin',
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Féminin'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Date de Naissance et Pays de Naissance
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null && picked != _selectedDate) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 10),
                                Text(
                                  _selectedDate == null
                                      ? 'Sélectionnez une date'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              setState(() {
                                selectedCountry = countryCode;
                              });
                            },
                            initialSelection: 'SN',
                            favorite: const ['+221'],
                            showCountryOnly: true,
                            showOnlyCountryWhenClosed: true,
                            alignLeft: true,
                            textStyle: const TextStyle(fontSize: 16),
                            searchDecoration: const InputDecoration(
                              labelText: 'Search',
                              hintText: 'Search country',
                              border: OutlineInputBorder(),
                            ),
                            dialogTextStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                              labelText: "Selectionner une Region",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          value: regionChoisieId,
                          items: _regions.map((reg) {
                            return DropdownMenuItem<int>(
                                value: reg.id, child: Text(reg.nomRegion));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              regionChoisieId = value;
                              //Charger les departements lorsque la region change
                              departementChoisiId = null;
                              if (value != null) {
                                _loaddepartements(value);
                              }
                            });
                          },
                          validator: (value) => value == null
                              ? "Veuiller selectionner une Region"
                              : null,
                        ),
                      ),

                      const SizedBox(width: 20),

                      //Choix du departement
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                              labelText: "Selectionner un Departement",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          value: departementChoisiId,
                          items: _dept.map((depart) {
                            return DropdownMenuItem<int>(
                                value: depart.id,
                                child: Text(depart.nomDepartement));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              departementChoisiId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Veuilller selectionner un departement";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Address et Email
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "le champs ne doit pas etre vide";
                            }
                            return null;
                          },
                          controller: _adresseEditController,
                          decoration: InputDecoration(
                            labelText: "Adresse",
                            prefixIcon: const Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _emailEditController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "le champ ne doit pas être vide";
                            }
                            if (!isEmail(value)) {
                              return "e-mail invalide";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // CNI and INE
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "le champs ne doit pas etre vide";
                            }
                            return null;
                          },
                          controller: _cniEditController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "CNI",
                            prefixIcon:
                                const Icon(Icons.assignment_ind_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "le champs ne doit pas etre vide";
                            }
                            return null;
                          },
                          controller: _ineEditController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "INE",
                            prefixIcon:
                                const Icon(Icons.assignment_ind_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Telephone and Email
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _telephoneEditController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const CountryCodePicker(
                              initialSelection: 'SN',
                              favorite: ["+221"],
                              showFlag: true,
                            ),
                            labelText: 'Numéro téléphone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "le champ ne doit pas être vide";
                            }
                            if (!isPhone(value)) {
                              return "numéro téléphone invalide";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _submit,
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: myDrawerColol.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26, vertical: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
