import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Specialite/model_specialite.dart';
import 'package:school_management_system/Screen/Region/model_region.dart';
import 'package:flutter/material.dart';

class ProfesseurCard extends StatelessWidget {
  final String prenomEtNom;
  final Region region;
  final String email;
  final String departement;
  final String adresse;
  final List<Specialite> specialites;
  final void Function()? detail;
  final void Function()? onDelete;
  final bool estPermanent;

  const ProfesseurCard({
    super.key,
    required this.prenomEtNom,
    required this.email,
    required this.adresse,
    required this.specialites,
    required this.region,
    required this.departement,
    required this.detail,
    required this.onDelete,
    required this.estPermanent,
  });

  String getInitials(String name) {
    var parts = name.split(' ');
    return parts.length > 1 ? '${parts[0][0]}${parts[1][0]}' : parts[0][0];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: detail,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec avatar, nom et bouton supprimer
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.indigo[400],
                    child: Text(
                      getInitials(prenomEtNom).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prenomEtNom,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: estPermanent
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      estPermanent ? "Permanent" : "Vacataire",
                      style: TextStyle(
                        fontSize: 12,
                        color: estPermanent
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: onDelete,
                    tooltip: "Supprimer",
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildInfoRow(Icons.email, "Email", email),
              // _buildInfoRow(Icons.place, "Adresse", adresse),
              // _buildInfoRow(Icons.account_tree, "Département", departement),
              _buildInfoRow(Icons.map, "Région", region.nomRegion),
              const SizedBox(height: 10),
              const Text(
                "Spécialités",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: _buildLimitedSpecialites(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo, size: 18),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLimitedSpecialites(BuildContext context) {
    List<Widget> chips = [];
    int maxChips = 2;

    for (int i = 0; i < specialites.length && i < maxChips; i++) {
      chips.add(
        Chip(
          label: Text(
            utf8.decode((specialites[i].nom ?? "").codeUnits),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: Colors.indigoAccent,
        ),
      );
    }

    if (specialites.length > maxChips) {
      chips.add(
        Chip(
          label: Text(
            "+${specialites.length - maxChips} autres",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: Colors.grey,
        ),
      );
    }

    return chips;
  }
}



// Expanded ou Flexible pour forcer les widgets à s'adapter à l'espace disponible.