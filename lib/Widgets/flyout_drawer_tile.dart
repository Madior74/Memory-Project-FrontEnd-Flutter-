import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_management_system/Widgets/list_drawer.dart';
import 'package:school_management_system/theme/colors.dart';

// class FlyoutDrawerTile extends StatefulWidget {
//   final IconData icon;
//   final String text;
//   final List<MyDrawerListTile> children;

//   const FlyoutDrawerTile({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.children,
//   });

//   @override
//   State<FlyoutDrawerTile> createState() => _FlyoutDrawerTileState();
// }

// class _FlyoutDrawerTileState extends State<FlyoutDrawerTile> {
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//   bool _isHovering = false;
//   Timer? _hoverTimer;

//   void _showOverlay() {
//     if (_overlayEntry != null) return;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         width: 275,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           offset: const Offset(300, 0), // décalage à droite
//           showWhenUnlinked: false,
//           child: MouseRegion(
//             onEnter: (_) => _setHovering(true),
//             onExit: (_) => _setHovering(false),
//             child: Material(
//               borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10)),
//               color: myDrawerColol,
//               elevation: 4,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: widget.children,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   void _setHovering(bool value) {
//     _isHovering = value;
//     _hoverTimer?.cancel();

//     if (!value) {
//       _hoverTimer = Timer(const Duration(milliseconds: 300), () {
//         if (!_isHovering) {
//           _removeOverlay();
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: MouseRegion(
//         onEnter: (_) {
//           _setHovering(true);
//           _showOverlay();
//         },
//         onExit: (_) => _setHovering(false),
//         child: MyDrawerListTile(
//           icon: widget.icon,
//           text: widget.text,
//           onTap: () {}, // Ne rien faire ici
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _hoverTimer?.cancel();
//     _removeOverlay();
//     super.dispose();
//   }
// }

class FlyoutDrawerTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final List<MyDrawerListTile> children;

  const FlyoutDrawerTile({
    super.key,
    required this.icon,
    required this.text,
    required this.children,
  });

  @override
  State<FlyoutDrawerTile> createState() => _FlyoutDrawerTileState();
}

class _FlyoutDrawerTileState extends State<FlyoutDrawerTile> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;
  Timer? _hoverTimer;

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx +
            renderBox.size.width, // Position à droite de l'élément parent
        top: position.dy,
        child: MouseRegion(
          onEnter: (_) => _setHovering(true),
          onExit: (_) => _setHovering(false),
          child: Material(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: myDrawerColol,
            elevation: 4,
            child: Container(
              width: 250,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _setHovering(bool value) {
    _isHovering = value;
    _hoverTimer?.cancel();

    if (!value) {
      _hoverTimer = Timer(const Duration(milliseconds: 300), () {
        if (!_isHovering) {
          _removeOverlay();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          _setHovering(true);
          _showOverlay();
        },
        onExit: (_) => _setHovering(false),
        child: MyDrawerListTile(
          icon: widget.icon,
          text: widget.text,
          onTap: () {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }
}
