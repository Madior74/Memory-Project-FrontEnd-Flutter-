// import 'package:flutter/material.dart';
// import 'package:school_management_system/Classes/module.dart';

// class MultiSelesct extends StatefulWidget {
//   final List<Module> items;
//   const MultiSelesct({super.key, required this.items});

//   @override
//   State<MultiSelesct> createState() => _MultiSelesctState();
// }

// class _MultiSelesctState extends State<MultiSelesct> {
//   final List<Module> _selectedItems = [];
//   //Fonction de declencheur

//   void _itemchange(Module itemvalue, bool isSelected) {
//     if (isSelected) {
//       setState(() {
//         widget.items.add(itemvalue);
//       });
//     } else {
//       setState(() {
//         widget.items.remove(itemvalue);
//       });
//     }
//   }

// //Cancel button
//   void _cancel() {
//     Navigator.pop(context);
//   }

// //Save button
//   void _submit() {
//     Navigator.pop(context, widget.items);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Selection des modules"),
//       content: SingleChildScrollView(
//           child: ListBody(
//         children: widget.items
//             .map(
//               (item) => CheckboxListTile(
//                   value: _selectedItems.contains(item),
//                   title: Text(item.nomModule),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (isChecked) => _itemchange(item, isChecked!)),
//             )
//             .toList(),
//       )),
//       actions: [
//         TextButton(onPressed: _cancel, child: Text("Annuler")),
//         TextButton(onPressed: _submit, child: Text("Enregistrer")),
//       ],
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Modules/module.dart';

class MultiSelect extends StatefulWidget {
  final List<Module> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<Module> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(Module itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(utf8.decode(item.nomModule.codeUnits)),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
