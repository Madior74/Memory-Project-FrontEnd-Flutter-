import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_management_system/theme/colors.dart';

class NiveauCard extends StatelessWidget {
  final String accronyme;
  final String nomNiveau;
  final int nobreEtudiant;
  final void Function()? niveauTap;
  final void Function()? supprimeTap;

  const NiveauCard({
    super.key,
    required this.accronyme,
    required this.nomNiveau,
    required this.nobreEtudiant,
    this.niveauTap,
    this.supprimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Colors.blue.withOpacity(0.3),
      child: InkWell(
        onTap: niveauTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Carte $accronyme sélectionnée')),
              );
            },
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: myDrawerColol,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        accronyme,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      nomNiveau,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(width: 20),

              // Contenu informatif
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.userGraduate,
                            size: 20,
                            color: Colors.black,
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
                            '$nobreEtudiant ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Actions

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: niveauTap ?? () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myDrawerColol,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Voir détails'),
                        ),
                        if (supprimeTap != null)
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: supprimeTap,
                            tooltip: 'Supprimer',
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour générer une couleur basée sur l'acronyme
}
