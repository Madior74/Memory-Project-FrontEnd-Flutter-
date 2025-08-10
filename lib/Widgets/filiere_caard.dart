import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_management_system/theme/colors.dart';

class FiliereCaard extends StatelessWidget {
  final String accronyme;
  final String nomFiliere;
  final int nobreEtudiant;
  final int nbredeModule;
  final void Function()? niveauTap;
  final void Function()? supprimeTap;

  const FiliereCaard({
    super.key,
    required this.accronyme,
    required this.nomFiliere,
    required this.nobreEtudiant,
    required this.nbredeModule,
    required this.niveauTap,
    required this.supprimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: niveauTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 520,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colonne pour l'Acronyme
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: myDrawerColol,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            accronyme,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40, // Réduit la taille de l'acronyme
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // Colonne pour les détails de la filière
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom de la filière
                      Row(
                        children: [
                          Text(
                            nomFiliere,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.012,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Ligne avec l'icône et le nombre d'étudiants
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.userGraduate,
                            size: 20,
                            color: myDrawerColol,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Étudiants : ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            nobreEtudiant.toString(),
                            style: TextStyle(
                              color: myDrawerColol,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Nombre de Modules
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Modules : ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            nbredeModule.toString(),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Bouton Supprimer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: supprimeTap,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
