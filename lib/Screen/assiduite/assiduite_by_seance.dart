import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Seance/model_seance.dart';
import 'package:school_management_system/Screen/assiduite/assiduiteDTO.dart';
import 'package:school_management_system/Screen/assiduite/assiduite_service.dart';
import 'package:school_management_system/Screen/assiduite/model_assiduite.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/theme/my_styles.dart';

class AssiduiteByModule extends StatefulWidget {
  final Seance seance;
  const AssiduiteByModule({super.key, required this.seance});

  @override
  State<AssiduiteByModule> createState() => AssiduiteBySeance();
}

class AssiduiteBySeance extends State<AssiduiteByModule> {
  late Future<List<AssiduiteDto>> futureAssiduite;
  int nbrePresence = 0;
  int nbreAbsents = 0;
  int nbreRetard = 0;
  int nbreExclus = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      nbrePresence = 0;
      nbreAbsents = 0;
      nbreRetard = 0;
      nbreExclus = 0;
      futureAssiduite = AssiduiteService().getAssiduiteBySeance(widget.seance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const MyDrawer(),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Assiduité - ${widget.seance.module?.nomModule ?? 'Module'}',
                  style: firstTitleStyle,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.seance.module?.nomModule ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${widget.seance.dateSeance?.toString().split(' ')[0] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'Heure: ${widget.seance.heureDebut ?? 'N/A'} - ${widget.seance.heureFin ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Statistiques de présence
                      FutureBuilder<List<AssiduiteDto>>(
                        future: futureAssiduite,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            _calculateStats(snapshot.data!);

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatCard('Présents', nbrePresence,
                                    Colors.green, Icons.check_circle),
                                _buildStatCard('Absents', nbreAbsents,
                                    Colors.red, Icons.person_off),
                                _buildStatCard('Retards', nbreRetard,
                                    Colors.orange, Icons.schedule),
                                _buildStatCard('Exclus', nbreExclus,
                                    Colors.black, Icons.block),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Liste des étudiants
                Expanded(
                  child: FutureBuilder<List<AssiduiteDto>>(
                    future:
                        AssiduiteService().getAssiduiteBySeance(widget.seance),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print("Erreur recu${snapshot.error}");
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                "Erreur de chargement",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Veuillez réessayer",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _loadData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline,
                                  color: Colors.grey[400], size: 64),
                              const SizedBox(height: 16),
                              const Text(
                                "Aucun étudiant trouvé",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Pour cette séance",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Fonctionnalité d\'ajout d\'étudiants à implémenter'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.person_add),
                                label: const Text('Ajouter des étudiants'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        List<AssiduiteDto> assiduites = snapshot.data!;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing: 20,
                                headingRowColor:
                                    MaterialStateProperty.all(Colors.blue[50]),
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                columns: [
                                  const DataColumn(
                                    label: Text("Étudiant(e)"),
                                  ),
                                  const DataColumn(
                                    label: Text("Email"),
                                  ),
                                  const DataColumn(
                                    label: Text("Statut"),
                                  ),
                                  const DataColumn(
                                    label: Text("Actions"),
                                  ),
                                ],
                                rows: assiduites.map((assiduite) {
                                  final prenom =
                                      assiduite.etudiantDto.prenom ?? 'N/A';
                                  final nom =
                                      assiduite.etudiantDto.nom ?? 'N/A';
                                  String statutPresence =
                                      assiduite.statutPresence ?? 'PRESENT';

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[100],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${prenom[0]}${nom[0]}'
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.blue[700],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                "$prenom $nom",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                          Text(assiduite.etudiantDto.email)),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color:
                                                _getStatusColor(statutPresence),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            statutPresence,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Menu de modification du statut
                                            PopupMenuButton<String>(
                                              icon: Icon(Icons.more_vert,
                                                  color: Colors.grey[600]),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'PRESENT',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.check_circle,
                                                          color: Colors
                                                              .green[600]),
                                                      const SizedBox(width: 12),
                                                      const Text('PRÉSENT'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'ABSENT',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.person_off,
                                                          color:
                                                              Colors.red[600]),
                                                      const SizedBox(width: 12),
                                                      const Text('ABSENT'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'RETARD',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.schedule,
                                                          color: Colors
                                                              .orange[600]),
                                                      const SizedBox(width: 12),
                                                      const Text('RETARD'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'EXCLUS',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.block,
                                                          color: Colors.black),
                                                      const SizedBox(width: 12),
                                                      const Text('EXCLUS'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) =>
                                                  _updatePresenceStatus(
                                                      assiduite, value),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _calculateStats(List<AssiduiteDto> assiduites) {
    nbrePresence = 0;
    nbreAbsents = 0;
    nbreRetard = 0;
    nbreExclus = 0;

    for (var i in assiduites) {
      switch (i.statutPresence) {
        case "PRESENT":
          nbrePresence++;
          break;
        case "ABSENT":
          nbreAbsents++;
          break;
        case "RETARD":
          nbreRetard++;
          break;
        case "EXCLUS":
          nbreExclus++;
          break;
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return Colors.green;
      case 'ABSENT':
        return Colors.red;
      case 'RETARD':
        return Colors.orange;
      case 'EXCLUS':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  // Mettre à jour le statut de présence
  Future<void> _updatePresenceStatus(
      AssiduiteDto assiduite, String newStatus) async {
    try {
      // Créer un nouvel objet Assiduite avec le nouveau statut
      AssiduiteDto updatedAssiduite = AssiduiteDto(
        id: assiduite.id,
        etudiantDto: assiduite.etudiantDto,
        seanceId: assiduite.seanceId,
        statutPresence: newStatus,
      );

      await AssiduiteService().updateAssiduite(assiduite.id!, updatedAssiduite);

      setState(() {
        futureAssiduite =
            AssiduiteService().getAssiduiteBySeance(widget.seance);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Statut mis à jour: $newStatus",
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Erreur lors de la mise à jour: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  // Supprimer un étudiant
  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange[500], size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Confirmation de suppression",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Voulez-vous vraiment supprimer cet étudiant de la séance ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Annuler",
                          style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        AssiduiteService().deleAssiduite(id).then((_) {
                          setState(() {
                            futureAssiduite = AssiduiteService()
                                .getAssiduiteBySeance(widget.seance);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Étudiant supprimé avec succès",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Erreur : $error"),
                            ),
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Supprimer"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
