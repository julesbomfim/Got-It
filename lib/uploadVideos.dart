import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ingleswebsite/admin.dart';
import 'package:ingleswebsite/telaAdmin.dart';
import 'package:ingleswebsite/visualVideos.dart';

class UploadVideos extends StatefulWidget {
  const UploadVideos({super.key, required this.user});
  final Admin user;
  @override
  _UploadVideosState createState() => _UploadVideosState();
}

class _UploadVideosState extends State<UploadVideos> {
  List<Map<String, dynamic>> _selectedFiles = [];
  bool isUploadingFiles = false;
  List<Map<String, dynamic>> _selectedFiles2 = [];
  bool isUploadingFiles2 = false;

  Future<void> _pickVideo() async {
    final result = await FilePickerWeb.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mkv'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.add({
          'name': result.files.single.name,
          'bytes': result.files.single.bytes,
        });
      });
    }
  }

  String? _videoUrl;
  Future<void> uploadFile(Map<String, dynamic> fileData) async {
    try {
      final String fileName = fileData['name'];
      final Uint8List bytes = fileData['bytes'];

      // Upload do vídeo para o Firebase Storage
      final TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref('arquivos/${widget.user.id}/$fileName')
          .putData(bytes);

      // Obtenha a URL do vídeo após o upload
      final String videoUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _videoUrl = videoUrl;
      });

      // Salve os detalhes do vídeo (título, descrição, URL) no Firestore
      await saveVideoDetails(fileName, videoUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload do vídeo concluído com sucesso!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      print('Erro ao fazer upload para o Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer upload do vídeo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveVideoDetails(String videosUrl, String fileName) async {
    // Salve os detalhes do vídeo no Firestore
    await FirebaseFirestore.instance
        .collection('Videos')
        .doc(widget.user.id)
        .update({'docsVideos': videosUrl, 'fileNameVideos': fileName});
  }
///////////////////// exercicio

  Future<void> _pickExercicio() async {
    final result = await FilePickerWeb.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles2.add({
          'name': result.files.single.name,
          'bytes': result.files.single.bytes,
        });
      });
    }
  }

  String? _exercicioUrl;
  Future<void> uploadFile2(Map<String, dynamic> fileData) async {
    try {
      final String fileName = fileData['name'];
      final Uint8List bytes = fileData['bytes'];

      // Upload do vídeo para o Firebase Storage
      final TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref('arquivos/${widget.user.id}/$fileName')
          .putData(bytes);

      // Obtenha a URL do vídeo após o upload
      final String exercicioUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _exercicioUrl = exercicioUrl;
      });

      // Salve os detalhes do vídeo (título, descrição, URL) no Firestore
      await saveExercicioDetails(fileName, exercicioUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload do arquivo concluído com sucesso!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      print('Erro ao fazer upload para o Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer upload do vídeo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveExercicioDetails(
      String exercicioUrl, String fileNameExercicio) async {
    // Salve os detalhes do vídeo no Firestore
    await FirebaseFirestore.instance
        .collection('Videos')
        .doc(widget.user.id)
        .update({
      'docsExercicios': exercicioUrl,
      'fileNameExercicio': fileNameExercicio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            // Layout para dispositivos móveis
            return _buildMobileLayout();
          } else {
            // Layout para desktop/notebook
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

Widget _buildMobileLayout() {
  return Scaffold(
    body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu.png'), // Caminho da imagem de fundo
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upload ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text(
                'Escolher Vídeo',
                style: TextStyle(
                  color: Color.fromARGB(255, 30, 98, 170),
                ),
              ),
            ),
            SizedBox(height: 10),
            _selectedFiles.isNotEmpty
                ? Column(
                    children: _selectedFiles.map((fileData) {
                      return Text('Vídeo selecionado: ${fileData['name']}');
                    }).toList(),
                  )
                : Text(
                    'Nenhum vídeo selecionado',
                    style: TextStyle(color: Colors.black),
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectedFiles.isNotEmpty
                  ? () async {
                      setState(() {
                        isUploadingFiles = true;
                      });

                      await Future.wait(
                        _selectedFiles.map((fileData) async {
                          await uploadFile(fileData);
                        }),
                      );

                      _selectedFiles = [];

                      setState(() {
                        isUploadingFiles = false;
                      });
                    }
                  : null,
              child: isUploadingFiles
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : Text(
                      "Anexar vídeos",
                      style: TextStyle(color: Colors.white),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 30, 98, 170),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickExercicio,
              child: Text(
                'Escolher Material',
                style: TextStyle(
                  color: Color.fromARGB(255, 30, 98, 170),
                ),
              ),
            ),
            SizedBox(height: 10),
            _selectedFiles2.isNotEmpty
                ? Column(
                    children: _selectedFiles2.map((fileData) {
                      return Text('Arquivo selecionado: ${fileData['name']}');
                    }).toList(),
                  )
                : Text(
                    'Nenhum material selecionado',
                    style: TextStyle(color: Colors.black),
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectedFiles2.isNotEmpty
                  ? () async {
                      setState(() {
                        isUploadingFiles2 = true;
                      });

                      await Future.wait(
                        _selectedFiles2.map((fileData) async {
                          await uploadFile2(fileData);
                        }),
                      );

                      _selectedFiles2 = [];

                      setState(() {
                        isUploadingFiles2 = false;
                      });
                    }
                  : null,
              child: isUploadingFiles2
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : Text(
                      "Anexar material",
                      style: TextStyle(color: Colors.white),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 30, 98, 170),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaAdmin(),
                  ),
                );
              },
              child: Text(
                "Concluir",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 30, 98, 170),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



  Widget _buildDesktopLayout() {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'), // Caminho da imagem de fundo
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 600),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Upload ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: _pickVideo,
                        child: Text('Escolher Vídeo',
                            style: TextStyle(
                                color: Color.fromARGB(255, 30, 98, 170))),
                      ),
                      SizedBox(height: 20),
                      _selectedFiles.isNotEmpty
                          ? Column(
                              children: _selectedFiles.map((fileData) {
                                return Text(
                                    'Vídeo selecionado: ${fileData['name']}');
                              }).toList(),
                            )
                          : Text('Nenhum vídeo selecionado',
                              style: TextStyle(color: Colors.black)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _selectedFiles.isNotEmpty
                            ? () async {
                                setState(() {
                                  isUploadingFiles = true;
                                });

                                await Future.wait(
                                  _selectedFiles.map((fileData) async {
                                    await uploadFile(fileData);
                                  }),
                                );

                                _selectedFiles = [];

                                setState(() {
                                  isUploadingFiles = false;
                                });
                              }
                            : null,
                        child: isUploadingFiles
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              )
                            : Text(
                                "Anexar vídeos",
                                style: TextStyle(color: Colors.white),
                              ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color.fromARGB(255, 30, 98, 170)),
                        ),
                      ),
                      SizedBox(height: 46),
                      ElevatedButton(
                        onPressed: _pickExercicio,
                        child: Text(
                          'Escolher Material',
                          style: TextStyle(
                              color: Color.fromARGB(255, 30, 98, 170)),
                        ),
                      ),
                      SizedBox(height: 20),
                      _selectedFiles2.isNotEmpty
                          ? Column(
                              children: _selectedFiles2.map((fileData) {
                                return Text(
                                    'Arquivo selecionado: ${fileData['name']}');
                              }).toList(),
                            )
                          : Text('Nenhum material selecionado',
                              style: TextStyle(color: Colors.black)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _selectedFiles2.isNotEmpty
                            ? () async {
                                setState(() {
                                  isUploadingFiles2 = true;
                                });

                                await Future.wait(
                                  _selectedFiles2.map((fileData) async {
                                    await uploadFile2(fileData);
                                  }),
                                );

                                _selectedFiles2 = [];

                                setState(() {
                                  isUploadingFiles2 = false;
                                });
                              }
                            : null,
                        child: isUploadingFiles2
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              )
                            : Text(
                                "Anexar material",
                                style: TextStyle(color: Colors.white),
                              ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color.fromARGB(255, 30, 98, 170)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TelaAdmin()), // Navegar para a tela de login
                          );
                        },
                        child: Text(
                          "Concluir",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color.fromARGB(255, 30, 98, 170)),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
