import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final String nomModule;
  final String nomUE;
  final int volumeHoraire;
  final double creditModule;

  const ModuleCard({
    super.key,
    required this.nomModule,
    required this.nomUE,
    required this.volumeHoraire,
    required this.creditModule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: isDark ? Colors.grey[900] : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom du module
              Row(
                children: [
                  Icon(Icons.book, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    nomModule,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        overflow: TextOverflow.ellipsis),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Volume horaire
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: theme.iconTheme.color),
                      const SizedBox(width: 8),
                      Text(
                        "Volume horaire:",
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    "$volumeHoraire h",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.tealAccent : Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Crédit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.numbers, color: theme.iconTheme.color),
                      const SizedBox(width: 8),
                      Text(
                        "Crédit:",
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    creditModule.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.tealAccent : Colors.deepPurple,
                    ),
                  ),
                ],
              ),

              //Nom de L'UE
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.book, color: theme.iconTheme.color),
                      const SizedBox(width: 6),
                      Text(
                        "Nom de l'UE:",
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    nomUE,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.tealAccent : Colors.deepPurple,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
