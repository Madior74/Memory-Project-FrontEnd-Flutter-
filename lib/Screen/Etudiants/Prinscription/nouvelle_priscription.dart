import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management_system/Screen/Region/Departements/departement.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Screen/Filieres/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/model_niveau.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/liste_des_prinscrits.dart';
import 'package:school_management_system/Screen/Region/Departements/departementService.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Screen/Filieres/filiere_service.dart';
import 'package:school_management_system/Screen/Niveaux/niveau_service.dart';
import 'package:school_management_system/Screen/Region/regionService.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:school_management_system/theme/colors.dart';

class NouvellePriscription extends StatefulWidget {
  const NouvellePriscription({super.key});

  @override
  State<NouvellePriscription> createState() => _NouvellePriscriptionState();
}

class _NouvellePriscriptionState extends State<NouvellePriscription> {
  List<Filiere> futuresFilieres = [];
  List<Niveau> futuresNiveaux = [];
  List<AnneeAcademique> futureAnnees = [];

  String? selectedRole;
  //Le Niveau
  int? selectedNiveau;
  bool _passwordInVisible = true;

  CountryCode? selectedCountry;
  String sexeValue = 'Masculin';
  String? _selectedGender;
  DateTime? _selectedDate;
  int _index = 0;
  int value = 1;
  int selectedOption = 1;
  // late Future<List<AnneeAcademique>> sessions;

  //
  List<Region> _regions = [];
  Filiere? filiereChoisie;
  Niveau? niveauChoisie;
  AnneeAcademique? annechoisie;
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
    fetchFilieres();
    fetchAnnees();
  }

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

  //Recuperation des Filieres
  void fetchFilieres() async {
    try {
      List<Filiere> filieresData = await FiliereService().getFilieres();

      setState(() {
        futuresFilieres = filieresData;
      });
    } catch (e) {
      print("Recuperation des Filieres $e");
    }
  }

  //Recuperation des Filieres
  void fetchAnnees() async {
    try {
      List<AnneeAcademique> anneesData =
          await AnneeAcademiqueService().getSessions();

      setState(() {
        futureAnnees = anneesData;
      });
    } catch (e) {
      print("Recuperation des Annees $e");
    }
  }

  void fetchNiveaux(int filiereId) async {
    try {
      List<Niveau> niveauxData =
          await NiveauService().getNiveauxByFiliere(filiereId);
      setState(() {
        futuresNiveaux = niveauxData;
      });
    } catch (e) {
      print("Recuperation des Niveau  $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 3,
          backgroundColor: myDrawerColol,
          shadowColor: Colors.black,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "NOUVEAU ETUDIANT",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: personalInfoStep());
  }

  void _submit() async {
    // Validation du formulaire
    if (_formKey.currentState!.validate()) {
      // Vérification de la session choisie

      // Création de l'objet Etudiant
      final etudiant = CandidatPreInscrit(
        prenom: _prenomEditController.text,
        nom: _nomEditController.text,
        adresse: _adresseEditController.text,
        telephone: _telephoneEditController.text,
        sexe: _selectedGender ?? 'Masculin',
        email: _emailEditController.text,
        password: _passwordEditController.text,
        dateDeNaissance: _selectedDate ?? DateTime.now(),
        imagePath: _image?.path ?? '',
        paysDeNaissance: selectedCountry?.name ?? 'Senegal',
        cni: _cniEditController.text,
        ine: _ineEditController.text,
        departement: departementChoisi,
        filiereSouhaitee: filiereChoisie,
        niveauSouhaite: niveauChoisie,
        anneeAcademique: annechoisie,
        dateAjout: DateTime.now(),
        region: regionChoisie,
      );

      print("departement Choisie est : ${departementChoisi?.nomDepartement}");
      print("Donnees envoyees  : ${etudiant.toJson()}");
      final etudiantJson = etudiant.toJson();

      try {
        bool emailExists =
            await PrinscriptionService().emailExist(etudiant.email!);

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: myredColor,
                content: const Text('Cet email est déjà utilisé')),
          );
          return;
        }

        await PrinscriptionService().addEtudiant(etudiantData: etudiantJson);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              content: const Text('Étudiant ajouté avec succès'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListeDesPrinscrits()),
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

        print('Étudiant ajouté avec succès');
      } catch (e) {
        print(e);
        // Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    }
  }

//First Steps Info Personnelle
  Widget personalInfoStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                                          "assets/images/profil.png",
                                          height: 80,
                                        ),
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
                            padding: EdgeInsets.only(right: 70.0),
                            child: SvgPicture.asset(
                              "assets/images/student1.svg",
                              height: 250,
                            )),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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

                    const SizedBox(height: 20),
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
                                : null,
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
                              prefixIcon: Icon(FontAwesomeIcons.locationDot),
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
                    SizedBox(
                      height: 25,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Filiere>(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_balance),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: 'Filière Visée'),
                            value: filiereChoisie,
                            items: futuresFilieres.map((filiere) {
                              return DropdownMenuItem<Filiere>(
                                value: filiere,
                                child: Text(filiere.nomFiliere),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                filiereChoisie = value;
                                if (value != null) {
                                  fetchNiveaux(value.id!);
                                } else {
                                  // Réinitialiser les niveaux et semestres si aucune filière n'est sélectionnée
                                  futuresNiveaux = [];
                                  niveauChoisie = null;
                                }
                              });
                            },
                            validator: (value) => value == null
                                ? 'Veuillez sélectionner une filière'
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<Niveau>(
                            decoration: InputDecoration(
                                labelText: 'Niveau Visé',
                                prefixIcon: Icon(Icons.stairs),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            value: niveauChoisie,
                            items: futuresNiveaux.map((niveau) {
                              return DropdownMenuItem<Niveau>(
                                value: niveau,
                                child: Text(niveau.nomNiveau),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                niveauChoisie = value;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Veuillez sélectionner un niveau'
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<AnneeAcademique>(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_balance),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: 'Année Académique'),
                            value: annechoisie,
                            items: futureAnnees.map((annee) {
                              return DropdownMenuItem<AnneeAcademique>(
                                value: annee,
                                child: Text(annee.nomAnnee),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                annechoisie = value;
                                // Charger les niveaux lorsque la filière change
                              });
                            },
                            validator: (value) => value == null
                                ? 'Veuillez sélectionner une Année Académique'
                                : null,
                          ),
                        ),
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
      ),
    );
  }

  // Widget _buildOptionCard(int value, String title, IconData icon) {
  //   return Card(
  //     color: Colors.grey.shade100,
  //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //     child: Padding(
  //       padding: const EdgeInsets.all(15.0),
  //       child: ListTile(
  //         leading: Icon(
  //           icon,
  //           color: selectedOption == value ? myredColor : myblueColor,
  //         ),
  //         title: Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: selectedOption == value ? myredColor : Colors.black,
  //           ),
  //         ),
  //         trailing: Radio<int>(
  //           value: value,
  //           groupValue: selectedOption,
  //           activeColor: myredColor,
  //           onChanged: (int? newValue) {
  //             setState(() {
  //               selectedOption = newValue!;
  //             });
  //           },
  //         ),
  //         onTap: () {
  //           setState(() {
  //             selectedOption = value;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }
}
