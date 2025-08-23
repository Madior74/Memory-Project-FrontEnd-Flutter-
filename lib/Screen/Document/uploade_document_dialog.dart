import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Document/documentService.dart';

class UploadDocumentDialog extends StatefulWidget {
  final int studentId;
  final VoidCallback onDocumentUploaded;

  const UploadDocumentDialog({
    required this.studentId,
    required this.onDocumentUploaded,
  });

  @override
  _UploadDocumentDialogState createState() => _UploadDocumentDialogState();
}

class _UploadDocumentDialogState extends State<UploadDocumentDialog> {
  final _formKey = GlobalKey<FormState>();

  String? selectedTypeDocument;
  File? _selectedFile;
  bool _isUploading = false;

  Future _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future _uploadDocument() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await DocumentService().uploadDocument(
        _selectedFile!,
        selectedTypeDocument.toString(),
        widget.studentId,
      );

      widget.onDocumentUploaded();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document uploadé avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un document'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: selectedTypeDocument,
              items: [
                'Diplôme Baccalauréat',
                'Relevé de notes du Bac',
                'Extrait de naissance',
              ].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTypeDocument = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Veuillez choisir un document' : null,
              decoration: InputDecoration(
                  labelText: 'Nom du document',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.attach_file),
              label: Text('Sélectionner un fichier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
            if (_selectedFile != null) ...[
              SizedBox(height: 8),
              Text(
                'Fichier sélectionné: ${_selectedFile!.path.split('/').last}',
                style: TextStyle(fontSize: 12, color: Colors.green[600]),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        const SizedBox(
          width: 15,
        ),
        ElevatedButton(
          onPressed: _isUploading ? null : _uploadDocument,
          child: _isUploading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Uploader'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
