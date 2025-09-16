import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique.dart';
import 'package:school_management_system/theme/my_styles.dart';
import 'package:diacritic/diacritic.dart';
import 'package:school_management_system/Screen/AnneeAcademique/annee_academique_service.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;

class AnneeAcademiqueCard extends StatelessWidget {
  final AnneeAcademique annee;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActivation;

  const AnneeAcademiqueCard({
    Key? key,
    required this.annee,
    this.onEdit,
    this.onDelete,
    this.onToggleActivation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isActif = annee.etat.toLowerCase().contains('en cours');

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header avec badge d'état ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    annee.nomAnnee,
                    style: TextStyle(
                      color: Colors.indigo.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: getEtatColor(annee.etat).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    annee.etat,
                    style: TextStyle(
                      color: getEtatColor(annee.etat),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- Période académique ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Début",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${annee.dateDebut!.day.toString().padLeft(2, '0')}/${annee.dateDebut!.month.toString().padLeft(2, '0')}/${annee.dateDebut!.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  Column(
                    children: [
                      Text(
                        "Fin",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${annee.dateFin!.day.toString().padLeft(2, '0')}/${annee.dateFin!.month.toString().padLeft(2, '0')}/${annee.dateFin!.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Boutons d'action ---
            Row(
              children: [
                // Bouton Activer/Désactiver
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleToggleActivation(context, isActif),
                    icon: Icon(
                      isActif ? Icons.toggle_on : Icons.toggle_off,
                      size: 20,
                    ),
                    label: Text(
                      isActif ? "Désactiver" : "Activer",
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isActif ? Colors.red.shade50 : Colors.green.shade50,
                      foregroundColor: isActif ? Colors.red : Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isActif
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Bouton Modifier
                Expanded(
                  child: IconButton(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit, color: Colors.indigo.shade600),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.indigo.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: Colors.indigo.shade100, width: 1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Bouton Supprimer
                Expanded(
                  child: IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete, color: Colors.red.shade600),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red.shade100, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Gestion de l'activation/désactivation
  Future<void> _handleToggleActivation(
      BuildContext context, bool isActif) async {
    final service = AnneeAcademiqueService();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isActif ? "Désactiver l'année ?" : "Activer l'année ?"),
        content: Text(
          isActif
              ? "Êtes-vous sûr de vouloir désactiver cette année académique ?\nAucune inscription ne pourra être faite."
              : "Êtes-vous sûr de vouloir activer cette année académique ?\nLes inscriptions seront autorisées.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isActif ? "Désactiver" : "Activer",
              style: TextStyle(color: isActif ? Colors.red : Colors.green),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await service.toggleActivation(annee.id!);
      if (!SchedulerBinding.instance.schedulerPhase.index.isInRange(0, 4))
        return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isActif
              ? "Année désactivée avec succès"
              : "Année activée avec succès"),
          backgroundColor: isActif ? Colors.red : Colors.green,
        ),
      );
      onToggleActivation?.call();
    } catch (e) {
      if (!SchedulerBinding.instance.schedulerPhase.index.isInRange(0, 4))
        return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color getEtatColor(String etat) {
    final normalized = removeDiacritics(etat.toLowerCase());
    switch (normalized) {
      case "a venir":
        return Colors.blue;
      case "en cours":
        return Colors.green;
      case "terminee":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

extension IntRange on int {
  bool isInRange(int start, int end) => this >= start && this <= end;
}
