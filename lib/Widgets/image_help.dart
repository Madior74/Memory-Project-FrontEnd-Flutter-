// CircleAvatar(
//   radius: 100,
//   backgroundImage: _getImageProvider(etudiant.imagePath),
// );

// ImageProvider _getImageProvider(String? path) {
//   if (path == null || path.isEmpty) {
//     return const AssetImage('assets/images/default_avatar.png');
//   } else if (path.startsWith('http')) {
//     return NetworkImage(path);
//   } else if (File(path).existsSync()) {
//     return FileImage(File(path));
//   } else {
//     return AssetImage(path);
//   }
// }


//Transformation en classe

import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static ImageProvider getImageProvider(String? path, {String? defaultAsset}) {
    if (path == null || path.isEmpty) {
      return AssetImage(defaultAsset ?? 'assets/images/default_avatar.png');
    } else if (path.startsWith('http')) {
      return NetworkImage(path);
    } else if (File(path).existsSync()) {
      return FileImage(File(path));
    } else {
      return AssetImage(defaultAsset ?? 'assets/images/default_avatar.png');
    }
  }
}


//utilisation

// CircleAvatar(
//   radius: 100,
//   backgroundImage: ImageHelper.getImageProvider(etudiant.imagePath),
// );