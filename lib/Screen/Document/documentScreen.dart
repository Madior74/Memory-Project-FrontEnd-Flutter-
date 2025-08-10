import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Screen/Document/documentService.dart';
import 'package:school_management_system/Screen/Document/model_document.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/prinscription_service.dart';
import 'package:school_management_system/Screen/Etudiants/Prinscription/model_prinscription.dart';
import 'package:school_management_system/Widgets/button_annuler.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';

class Documentscreen extends StatefulWidget {
  final int etudiantId;
  const Documentscreen({super.key, required this.etudiantId});

  @override
  State<Documentscreen> createState() => _DocumentscreenState();
}

class _DocumentscreenState extends State<Documentscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchEtudiants();
  }

  //
  File? _selectedFile;
  final _formKey = GlobalKey<FormState>();

  // Méthode pour uploader le document
  bool _isUploading = false; 

  Future<void> _uploadDocument() async {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      _formKey.currentState!.save();

      setState(() {
        _isUploading = true;
      });

      try {
        var url = Uri.parse('http://192.168.1.15:9000/api/admin/documents/upload');

        var request = http.MultipartRequest('POST', url,)
          ..fields['nom'] =
              selectedTypeDocument! // Utiliser le type choisi comme nom
          ..fields['etudiantId'] = widget.etudiantId.toString()
          ..files.add(
              await http.MultipartFile.fromPath('file', _selectedFile!.path),);

        var response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Document uploadé avec succès !')),
          );
          Navigator.of(context).pop(); // Fermer la popup après succès
          _refreshDocuments(); // Recharge la liste des documents après upload
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(' Échec de l\'upload du document.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' Erreur : $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  //Recuperation ds etudiants
  void _fetchEtudiants() async {
    try {
      List<Etudiant> etudiantData = await EtudiantService().getAllEtudiant();

      setState(() {
        futuresEtudiant = etudiantData;
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  List<Etudiant> futuresEtudiant = [];
  Etudiant? etudiantChoisi;

  //

  String? selectedTypeDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: Column(
              //MyAppBar

              children: [
                MyAppbar(
                    title: "Documents ",
                    onTap: () => addDocument(),
                    boutonName: "Nouveau Document"),
                Expanded(
                  child: FutureBuilder<List<Document>>(
                    future: DocumentService()
                        .getDocumentsByEtudiant(widget.etudiantId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Center(
                            child: Text('Erreur : ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Aucun document trouvé.'));
                      } else {
                        List<Document> documents = snapshot.data!;

                        // Responsive : détecter la taille de l'écran
                        bool isWideScreen =
                            MediaQuery.of(context).size.width > 600;

                        // Mode grille
                        return GridView.builder(
                          padding: EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisExtent: 100,

                            childAspectRatio: 3, // Carte plus allongée
                          ),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return _buildDocumentCard(documents[index]);
                          },
                        );

                        // Mode liste
                        // return ListView.builder(
                        //   padding: EdgeInsets.all(16),
                        //   itemCount: documents.length,
                        //   itemBuilder: (context, index) {
                        //     return _buildDocumentCard(documents[index]);
                        //   },
                        // );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addDocument() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Téléverser un Document"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sélection du type de document obligatoire
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
                        value == null ? 'Veuillez choisir un type' : null,
                    decoration: InputDecoration(labelText: 'Type du document'),
                  ),
                  SizedBox(height: 16),

                  // Bouton pour sélectionner un fichier
                  ElevatedButton(
                    onPressed: _isUploading ? null : _pickFile,
                    child: _selectedFile == null
                        ? Text('Sélectionner un fichier')
                        : Text('Fichier sélectionné'),
                  ),
                  SizedBox(height: 16),

                  // Bouton pour envoyer
                  ElevatedButton(
                    onPressed: _isUploading ? null : _uploadDocument,
                    child: _isUploading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Téléverser'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Méthode pour sélectionner un fichier
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _refreshDocuments() {
    setState(() {});
  }

  //Build
  Widget _buildDocumentCard(Document document) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.insert_drive_file, color: Colors.blue, size: 40),
        title: Text(
          document.nom,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Text(
        //   "Type : ${document.nom}",
        //   style: TextStyle(color: Colors.grey[700]),
        // ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.download_rounded, color: Colors.green),
              onPressed: () async {
                await DocumentService().downloadDocument(document.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('📥 Document téléchargé !')),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_rounded, color: Colors.red),
              onPressed: () {
                // _confirmDelete(document);
              },
            ),
          ],
        ),
      ),
    );
  }



  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Voulez-vous Vraiment supprimer cet Etudiant ??"),
          actions: [
            const ButtonAnnuler(),
            TextButton(
                onPressed: () {
                  EtudiantService().deleteEtudiant(id).then((_) {
                    setState(
                      () {
                        EtudiantService().getAllEtudiant();
                      },
                    );

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Etudiant supprimé avec Succès",
                          style: TextStyle(color: Colors.white),
                        )));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Erreur : $error")),
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Supprimer"))
          ],
        );
      },
    );
  }
}
