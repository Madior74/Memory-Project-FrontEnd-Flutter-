import 'package:flutter/material.dart';
import 'package:school_management_system/Widgets/back_bouton.dart';
import 'package:school_management_system/theme/colors.dart';

class MyAppbar extends StatelessWidget {
  final String title;
  const MyAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final fontSizeTitle = MediaQuery.sizeOf(context).width * 0.015;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 2,
        color: myDrawerColol,
        child: SizedBox(
          height: 60, // hauteur fixe
          child: Row(
            children: [
              const MyBackButton(),

              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 40), // ou un bouton d'action si besoin
            ],
          ),
        ),
      ),
    );
  }
}
