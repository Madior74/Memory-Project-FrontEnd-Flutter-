import 'package:flutter/material.dart';
import 'package:school_management_system/Widgets/back_bouton.dart';
import 'package:school_management_system/theme/colors.dart';
import 'package:school_management_system/theme/my_styles.dart';

class MyAppbar extends StatelessWidget {
  final String title;
  final String boutonName;
  final void Function()? onTap;
  const MyAppbar(
      {super.key,
      required this.title,
      required this.onTap,
      required this.boutonName});

  @override
  Widget build(BuildContext context) {
    final fontSizeTitle = MediaQuery.sizeOf(context).width * 0.015;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton Retour
            const MyBackButton(),
            // Titre principal
            Text(
              title,
              style: TextStyle(
                  fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                onPressed: onTap,
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text(
                  boutonName,
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: myDrawerColol,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
