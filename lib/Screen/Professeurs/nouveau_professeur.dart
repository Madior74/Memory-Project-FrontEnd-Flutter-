import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';
import 'package:school_management_system/Screen/Modules/module.dart';
import 'package:school_management_system/Screen/Professeurs/model_professeur.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';
import 'package:school_management_system/Screen/Professeurs/liste_des_professeurs.dart';
import 'package:school_management_system/Screen/Professeurs/Professeur_service.dart';
import 'package:school_management_system/Screen/Region/Departements/departementService.dart';
import 'package:school_management_system/Screen/Region/regionService.dart';
import 'package:school_management_system/Screen/Specialite/specialiteService.dart';

import 'package:school_management_system/theme/colors.dart';

class NouveauProfesseur extends StatefulWidget {
  const NouveauProfesseur({super.key});

  @override
  State<NouveauProfesseur> createState() => _NouveauProfesseurState();
}

class _NouveauProfesseurState extends State<NouveauProfesseur> {
  bool _passwordInVisible = true;
  String _selectedGrade = 'Professeur';

  CountryCode? selectedCountry;
  String sexeValue = 'Masculin';
  String? _selectedGender;
  DateTime? _selectedDate;
  int _index = 0;
  int value = 1;
  int selectedOption = 1;

//specialités
  List<Specialite> _splt = [];
  List<int> _selectedSpecialiteIds = [];

  //Region et depart
  List<Region> _regions = [];
  Region? regionChoisie;
  Departement? departementChoisi;
  List<Departement> _dept = [];

  bool isEmail(String input) =>
      RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(input);
  bool isPhone(String input) => RegExp(r'^[0-9]{9}$').hasMatch(input);
  //Mes Controllers

  final _adresseEditController = TextEditingController();
  final _nomEditController = TextEditingController();
  final _cniEditController = TextEditingController();
  final _ineEditController = TextEditingController();
  final selectedModuleController = MultiSelectController();

  final _prenomEditController = TextEditingController();
  final _telephoneEditController = TextEditingController();
  final _emailEditController = TextEditingController();
  final _passwordEditController = TextEditingController();
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  List<String> listeStatus = [
    "Vacataire",
    "Permanent",
  ];

  String? selectedStatus;

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
    _loadSpecialite();
  }

  List<Step> stepList() => [
        Step(
          state: _index > 0 ? StepState.complete : StepState.indexed,
          isActive: _index >= 0,
          title: const Text("Information Personnelle"),
          content: personalInfoStep(),
        ),
        Step(
          state: _index > 1 ? StepState.complete : StepState.indexed,
          isActive: _index >= 1,
          title: const Text("Information Académique"),
          content: academicInfoStep(),
        ),
      ];

  void _incrementStepper() {
    if (_formKey.currentState!.validate()) {
      if (_index < 2) {
        setState(() {
          _index++;
        });
      } else {
        // Logique de soumission finale
        print("Formulaire soumis");
      }
    }
  }

  void _decrementStepper() {
    if (_index > 0) {
      setState(() {
        _index--;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      _index = value;
    });
  }

  //Departement
  Future<void> _loadSpecialite() async {
    try {
      final Specialites = await SpecialiteService().getAllSpecialites();
      setState(() {
        _splt = Specialites;
      });
    } catch (e) {
      print("Erreur lors recuperation des Specialites $e");
      throw Exception("Erreur lors de la recupération des Specialites");
    }
  }

  //regions
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
        backgroundColor: myDrawerColol,
        shadowColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "NOUVEAU PROFESSEUR",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: myredColor,
          ),
        ),
        child: Stepper(
          controlsBuilder: (context, details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_index > 0)
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text("Retour"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_index == stepList().length - 1) {
                      _submit(); // Appel à la méthode submit lors de la dernière étape
                    } else {
                      details.onStepContinue?.call();
                    }
                  },
                  child: Row(
                    children: [
                      Text(_index == stepList().length - 1
                          ? "Confirmer"
                          : "Suivant"),
                    ],
                  ),
                ),
              ],
            );
          },
          onStepTapped: onStepTapped,
          onStepContinue: _incrementStepper,
          onStepCancel: _decrementStepper,
          currentStep: _index,
          elevation: 0,
          steps: stepList(),
          type: StepperType.horizontal,
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSpecialiteIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez sélectionner au moins une spécialité."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Récupérer les objets Specialite correspondants aux IDs
      List<Specialite> selectedSpecialites = _splt
          .where((specialite) => _selectedSpecialiteIds.contains(specialite.id))
          .toList();

      try {
        final professeur = Professeur(
          prenom: _prenomEditController.text,
          nom: _nomEditController.text,
          adresse: _adresseEditController.text,
          telephone: _telephoneEditController.text,
          sexe: _selectedGender ?? 'Masculin',
          email: _emailEditController.text,
          password: _passwordEditController.text,
          imagePath: _image?.path ?? '',
          paysDeNaissance: selectedCountry?.name ?? 'Sénégal',
          cni: _cniEditController.text,
          ine: _ineEditController.text,
          dateDeNaissance: _selectedDate ?? DateTime.now(),
          departement: departementChoisi,
          status: selectedStatus ?? "Vacataire",
          specialites: selectedSpecialites,
          region: regionChoisie,
        );
        print("Donnees prof envoyés");
        print(professeur.toJson());

        // Envoi via le service
        await ProfesseurService().createProfesseur(professeur);

        // Afficher succès
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              content: const Text('Professeur ajouté avec succès'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListeDesProfesseurs(),
                      ),
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
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

//First Steps Info Personnelle
  Widget personalInfoStep() {
    return Padding(
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
                                    child:
                                        Image.asset("assets/images/profil.png"),
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
                        "assets/images/Prof.png",
                        height: 260,
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
                //Region et departement

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Region>(
                        decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.city),
                            labelText: "Selectionner une Region",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        value: regionChoisie,
                        items: _regions.map((reg) {
                          return DropdownMenuItem<Region>(
                              value: reg, child: Text(reg.nomRegion));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            regionChoisie = value;
                            //Charger les departements lorsque la region change
                            if (value != null) {
                              _loaddepartements(value.id!);
                            } else {
                              //reinitialiser les departement e si aucune region n'est selectionnee
                              _dept = [];
                              departementChoisi = null;
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
                      child: DropdownButtonFormField<Departement>(
                        decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.city),
                            labelText: "Selectionner un Departement",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        value: _dept.contains(departementChoisi)
                            ? departementChoisi
                            : null, // Ensure value is in list

                        items: _dept.map((depart) {
                          return DropdownMenuItem<Departement>(
                              value: depart,
                              child: Text(depart.nomDepartement));
                        }).toList(),
                        onChanged: (value) {
                          departementChoisi = value;
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
                          prefixIcon: const Icon(FontAwesomeIcons.locationDot),
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
                          prefixIcon: const Icon(Icons.assignment_ind_rounded),
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
                          prefixIcon: const Icon(Icons.assignment_ind_rounded),
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
                    Expanded(
                      child: TextFormField(
                        obscureText: _passwordInVisible,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "le champs ne doit pas etre vide";
                          }
                          return null;
                        },
                        controller: _passwordEditController,
                        decoration: InputDecoration(
                          labelText: "Mot de Passe",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordInVisible = !_passwordInVisible;
                              });
                            },
                            icon: Icon(_passwordInVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget academicInfoStep() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(45),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Spécialités ou Modules Enseignés",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Liste des spécialités avec Checkbox
                ..._splt.map((specialite) {
                  bool isSelected =
                      _selectedSpecialiteIds.contains(specialite.id);

                  return CheckboxListTile(
                    title: Text(specialite.nom ?? "Inconnu"),
                    value: isSelected,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          if (!isSelected) {
                            _selectedSpecialiteIds.add(specialite.id!);
                          }
                        } else {
                          _selectedSpecialiteIds.remove(specialite.id);
                        }
                      });
                    },
                  );
                }).toList(),

                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _selectedSpecialiteIds.map((id) {
                    final specialite = _splt.firstWhere((s) => s.id == id,
                        orElse: () => Specialite(id: id, nom: "Inconnu"));
                    if (specialite == null) return Container(); // sécurité

                    return Chip(
                      label: Text(
                        specialite.nom ?? "Spécialité",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue.shade800,
                      onDeleted: () {
                        setState(() {
                          _selectedSpecialiteIds.remove(id);
                        });
                      },
                      deleteIcon: const Icon(Icons.close,
                          size: 16, color: Colors.white),
                    );
                  }).toList(),
                ),

                // Message si aucune spécialité sélectionnée
                if (_selectedSpecialiteIds.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      "Aucune spécialité sélectionnée",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
