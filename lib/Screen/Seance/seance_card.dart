import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/theme/colors.dart';

class SeanceCard extends StatelessWidget {
  final String nomModule;
  final String statut;
  final String nomSalle;
  final String nomProfesseur;
  final DateTime dateSeance;
  final String heureDebut;
  final String heureFin;
  final String dureeHMin;
  final Color statutColor;
  final String formattedTimeDebut;
  final String formattedTimeFin;
  final int volumeDeroule;
  final void Function()? onEdit;
  final void Function()? onDelete;
  int? heureRestante;
  final void Function()? onAnnuler;

  SeanceCard({
    super.key,
    required this.nomModule,
    required this.statut,
    required this.nomSalle,
    required this.nomProfesseur,
    required this.dateSeance,
    required this.heureDebut,
    required this.heureFin,
    required this.formattedTimeDebut,
    required this.formattedTimeFin,
    required this.dureeHMin,
    required this.statutColor,
    this.heureRestante,
    this.onEdit,
    this.onDelete,
    required this.volumeDeroule,
    this.onAnnuler,
  });

  String get formattedDateWithDay {
    final DateFormat formatter =
        DateFormat.EEEE('fr_FR').addPattern(' dd/MM/yyyy');
    return formatter.format(dateSeance).replaceFirstMapped(
        RegExp(r'^.'), (match) => match.group(0)!.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bandeau de statut
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: statutColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre + Statut
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          nomModule,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statutColor.withOpacity(0.1),
                          border: Border.all(color: statutColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 10, color: statutColor),
                            const SizedBox(width: 6),
                            Text(
                              statut,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: statutColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'annuler':
                                    if (onAnnuler != null) onAnnuler!();
                                    break;
                                  case 'supprimer':
                                    if (onDelete != null) onDelete!();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 'annuler',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          color: myredColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text('Annuler'),
                                      ],
                                    )),
                                PopupMenuItem(
                                    value: 'supprimer',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: myredColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text('supprimer'),
                                      ],
                                    )),
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        formattedDateWithDay,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Heure
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "$formattedTimeDebut → $formattedTimeFin ",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "($dureeHMin)",
                        style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Salle
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Salle : $nomSalle",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Professeur
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Prof : $nomProfesseur",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Heure restante
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     // Modifier button
                  //     TextButton.icon(
                  //       onPressed: onEdit,
                  //       icon: Icon(Icons.edit, color: Colors.indigo),
                  //       label: Text(
                  //         "Modifier",
                  //         style: TextStyle(color: Colors.indigo),
                  //       ),
                  //       style: TextButton.styleFrom(
                  //         backgroundColor: Colors.indigo.withOpacity(0.1),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 16, vertical: 10),
                  //       ),
                  //     ),

                  //     const SizedBox(width: 12),

                  //     // Supprimer button
                  //     TextButton.icon(
                  //       onPressed: onDelete,
                  //       icon: Icon(Icons.delete, color: Colors.red),
                  //       label: Text(
                  //         "Supprimer",
                  //         style: TextStyle(color: Colors.red),
                  //       ),
                  //       style: TextButton.styleFrom(
                  //         backgroundColor: Colors.red.withOpacity(0.1),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 16, vertical: 10),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    children: [
                      const Icon(Icons.hourglass_bottom,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('Volume restant  : $volumeDeroule h'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
