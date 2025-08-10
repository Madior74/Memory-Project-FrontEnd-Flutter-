import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Modules/module.dart';

class ModuleSelectionWidget extends StatefulWidget {
  final List<Module> availableModules;
  final List<int> selectedModuleIds;
  final Function(List<int>) onSelectionChanged;

  const ModuleSelectionWidget({
    super.key,
    required this.availableModules,
    required this.selectedModuleIds,
    required this.onSelectionChanged,
  });

  @override
  _ModuleSelectionWidgetState createState() => _ModuleSelectionWidgetState();
}

class _ModuleSelectionWidgetState extends State<ModuleSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Modules enseignés',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableModules.map((module) {
            final isSelected = widget.selectedModuleIds.contains(module.id);
            return FilterChip(
              label: Text(module.nomModule),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final newSelection = List<int>.from(widget.selectedModuleIds);
                  if (selected) {
                    newSelection.add(module.id!);
                  } else {
                    newSelection.remove(module.id);
                  }
                  widget.onSelectionChanged(newSelection);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
