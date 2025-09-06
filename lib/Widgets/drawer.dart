import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Auth/login_screen.dart';
import 'package:school_management_system/Screen/Salle/list_salles.dart';
import 'package:school_management_system/Screen/Seance/seance_by_module.dart.dart';
import 'package:school_management_system/Screen/Specialite/liste_des_specialite.dart';
import 'package:school_management_system/Screen/Etudiants/Admission/gestion_des_admissions.dart';
import 'package:school_management_system/Screen/Etudiants/Inscription/list_inscriptions.dart';
import 'package:school_management_system/Screen/Horaire/emploi_du_temps.dart';
import 'package:school_management_system/Screen/Professeurs/liste_des_professeurs.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/liste_des_prinscrits.dart';
import 'package:school_management_system/Screen/Filieres/list_filieres.dart';
import 'package:school_management_system/Screen/Modules/liste_des_modules.dart';
import 'package:school_management_system/Screen/Note/liste_des_notes.dart';
import 'package:school_management_system/Screen/Region/liste_des_regions.dart';
import 'package:school_management_system/Screen/AnneeAcademique/list_annee_academique.dart';
import 'package:school_management_system/Screen/UES/listes_ue.dart';
import 'package:school_management_system/Widgets/flyout_drawer_tile.dart';
import 'package:school_management_system/Widgets/list_drawer.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxHeight * 0.28,
        height: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: myDrawerColol,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.8),
                  blurRadius: 1,
                  spreadRadius: 0)
            ]),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: myDrawerColol,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'School Admin ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white),
              MyDrawerListTile(
                icon: Icons.home,
                text: "ACCUEIL",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListInscriptions(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.school,
                text: " PROFESSEURS",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeDesProfesseurs(),
                    ),
                  );
                },
              ),
              FlyoutDrawerTile(
                  icon: Icons.person,
                  text: "Gestion des Etudiants",
                  children: [
                    MyDrawerListTile(
                      icon: Icons.pending_actions,
                      text: "Prinscriptions",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListeDesPrinscrits(),
                          ),
                        );
                      },
                    ),
                    MyDrawerListTile(
                      icon: Icons.assignment_turned_in,
                      text: "Admissibilité",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GestionDesAdmissions(),
                          ),
                        );
                      },
                    ),
                    MyDrawerListTile(
                      icon: Icons.verified,
                      text: "Etudiants Inscrits",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListInscriptions(),
                          ),
                        );
                      },
                    ),
                  ]),
              MyDrawerListTile(
                icon: Icons.account_balance,
                text: "FILIERES",
                onTap: () {
                  Navigator.of(context).pop;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListFilieres(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.location_city,
                text: "REGIONS",
                onTap: () {
                  Navigator.of(context).pop;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeDesRegions(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.book,
                text: "UNITES D'ENSEIGNEMENTS",
                onTap: () {
                  Navigator.of(context).pop;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeDesUES(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.book,
                text: "Modules",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeDesModules(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.book,
                text: "Séances",
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SeanceByModule(),
                  //   ),
                  // );
                },
              ),
              MyDrawerListTile(
                icon: Icons.book,
                text: "Liste des Specialités",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeDesSpecialite(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.book,
                text: "Liste des Salles",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListSalles(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.edit_document,
                text: "NOTES",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesScreen(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.timeline_rounded,
                text: "Annees Académique",
                onTap: () {
                  Navigator.of(context).pop;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListSession(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.calendar_month,
                text: "EMPLOI DU TEMPS",
                onTap: () {
                  Navigator.of(context).pop;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmploisDuTemps(),
                    ),
                  );
                },
              ),
              MyDrawerListTile(
                icon: Icons.person_remove_rounded,
                text: "ASSIDUITE",
                onTap: () {},
              ),
              const Divider(),
              MyDrawerListTile(
                icon: Icons.payment,
                text: "PAYEMENTS",
                onTap: () {},
              ),
              MyDrawerListTile(
                icon: Icons.groups,
                text: "BDE",
                onTap: () {},
              ),
              const Divider(),
              MyDrawerListTile(
                icon: Icons.settings,
                text: "PARAMETRES",
                onTap: () {},
              ),
              MyDrawerListTile(
                icon: Icons.settings,
                text: "Déconnexion",
                onTap: () async {
                  final pref = await SharedPreferences.getInstance();
                  await pref.remove('user');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
