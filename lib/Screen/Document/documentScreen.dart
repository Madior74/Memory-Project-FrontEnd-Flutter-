import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/Screen/Document/documentService.dart';
import 'package:school_management_system/Screen/Document/uploade_document_dialog.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';
import 'package:school_management_system/theme/colors.dart';

class Documentscreen extends StatefulWidget {
  final CandidatPreInscrit student;

  const Documentscreen({super.key, required this.student});

  @override
  _DocumentscreenState createState() => _DocumentscreenState();
}

class _DocumentscreenState extends State<Documentscreen> {
  List documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future _loadDocuments() async {
    try {
      final docs =
          await DocumentService().getDocumentsByEtudiant(widget.student.id!);
      setState(() {
        documents = docs;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur:$e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppbar(
            title:
                ('Documents - ${widget.student.prenom} ${widget.student.nom}'),
          ),
          Expanded(
            child: Center(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : documents.isEmpty
                      ? _buildEmptyState()
                      : _buildDocumentList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadDialog(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: myDrawerColol,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Aucun document',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ajoutez le premier document',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: _getDocumentIcon(document.type),
            title: Text(
              document.nom,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${document.type}'),
                Text(
                  'Déposé le: ${DateFormat('dd/MM/yyyy HH:mm').format(document.dateDepot)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'download',
                  child: Row(
                    children: [
                      Icon(Icons.download, color: Colors.blue[600]),
                      SizedBox(width: 8),
                      Text('Télécharger'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red[600]),
                      SizedBox(width: 8),
                      Text('Supprimer'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'download') {
                  _downloadDocument(document.id);
                } else if (value == 'delete') {
                  _confirmDelete(document.id);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _getDocumentIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'image':
        iconData = Icons.image;
        iconColor = Colors.green;
        break;
      case 'document':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => UploadDocumentDialog(
        studentId: widget.student.id!,
        onDocumentUploaded: () {
          _loadDocuments();
          Navigator.pop(context);
        },
      ),
    );
  
  }

  void _downloadDocument(int documentId) {
    DocumentService().downloadDocument(documentId).then((filePath) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Document téléchargé avec succès !\nEnregistré dans : $filePath",
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
        ),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce document ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await DocumentService().deleteDocument(id);

                  Navigator.of(context).pop();
                  setState(() {
                    _loadDocuments();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Document supprimé avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (error) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : $error")),
                  );
                }
              },
              child: Text(
                'Supprimer',
                style: TextStyle(color: myredColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
