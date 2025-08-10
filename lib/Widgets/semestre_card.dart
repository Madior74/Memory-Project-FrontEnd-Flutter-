import 'package:flutter/material.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class SemestreCard extends StatelessWidget {
  final String title;
  final int nbreUE;
  final double totalCredits;
  final int totalModules;

  final void Function()? supprimeBouton;
  final void Function()? ontapBouton;

  const SemestreCard({
    super.key,
    required this.title,
    required this.nbreUE,
    required this.totalCredits,
    required this.totalModules,
    required this.ontapBouton,
    this.supprimeBouton,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    String getAcronym(String fullName) {
      List<String> words = fullName.split(' ');

      List<String> filteredWords = words.where((word) {
        return word.length > 2 || RegExp(r'^\d+$').hasMatch(word);
      }).toList();

      String acronym = '';

      if (filteredWords.isNotEmpty) {
        for (String word in filteredWords) {
          acronym += (word.length > 2) ? word[0] : word;
        }
      }

      return acronym.toUpperCase();
    }

    return InkWell(
      onTap: ontapBouton,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).primaryColor.withOpacity(0.15),
                      color: myDrawerColol,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getAcronym(title),
                      style: TextStyle(
                        // color: Theme.of(context).primaryColor,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width / 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        size: 22, color: Colors.redAccent),
                    onPressed: supprimeBouton,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              _buildInfoTile(
                  context, Icons.book_outlined, 'Total UE', '$nbreUE'),
              _buildInfoTile(context, Icons.credit_card_outlined,
                  'Toatl crédit', '$totalCredits'),
              _buildInfoTile(context, Icons.widgets_outlined, 'Total Modules',
                  '$totalModules'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).primaryColor),
              Text(
                title,
                style: titleStyle,
              )
            ],
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
