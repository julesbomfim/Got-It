import 'package:flutter/material.dart';
import 'package:ingleswebsite/admin.dart';
import 'package:ingleswebsite/auth/authentic.dart';

class ListWebUpload extends StatefulWidget {
  final List<Admin> users;

  ListWebUpload({required this.users});

  @override
  State<ListWebUpload> createState() => _ListWebUploadState();
}

class _ListWebUploadState extends State<ListWebUpload> {
  final statusValue = ValueNotifier('');
  final dropCategoria = ['Finalizado', 'Pendente'];
  AuthService authService = AuthService();
  //final List<Map<String, dynamic>>? files = [];
  List<Map<String, dynamic>>? files;

/////// delete
//   @override
//   void initState() {
//     super.initState();
//     fetchFiles(widget.users[0].id);
//   }

//   Future<void> fetchFiles(String userId) async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Clientes')
//           .doc(userId)
//           .get();

//       if (snapshot.exists) {
//         // Check if the 'docs' field is a List<Map<String, dynamic>>
//         dynamic docsData = snapshot.get('docs');

//         if (docsData is List) {
//           setState(() {
//             files = List<Map<String, dynamic>>.from(
//                 (docsData as List).whereType<Map<String, dynamic>>());
//           });
//         } else {
//           print('Invalid data structure for "docs" field in Firestore.');
//         }
//       } else {
//         print('Document not found for user $userId.');
//       }
//     } catch (e) {
//       print('Error fetching files: $e');
//     }
//   }

//   Future<void> deleteFile(String userId, String fileName) async {
//     try {
//       // Find the user in the list
//       Admin user = widget.users.firstWhere((user) => user.id == userId);

//       // Delete file from Firebase Storage
//       await FirebaseStorage.instance.ref('arquivos/$userId/$fileName').delete();

//       // Update Firestore collection after deletion
//       final updatedDocs = user.docs.where((doc) => doc != fileName).toList();

//       // Update the 'docs' field for the user in Firestore
//       await FirebaseFirestore.instance
//           .collection('Clientes')
//           .doc(userId)
//           .update({'docs': updatedDocs});

//       setState(() {
//         // Update local user's documents list after deletion
//         user.docs = updatedDocs;
//       });

//       print('User $userId - File $fileName deleted successfully!');
//     } catch (e) {
//       print('Error deleting file: $e');
//     }
//   }

// //////////// updata
//   List<PlatformFile> selectedFiles = [];

//   Future<List<Map<String, dynamic>>?>? selectFile() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.any, allowMultiple: true);

//     if (result != null) {
//       selectedFiles = result.files;
//       return selectedFiles
//           .map((file) => {
//                 'name': file.name,
//                 'bytes': file.bytes,
//               })
//           .toList();
//     }

//     return null;
//   }

//   Future<void> updateFiles(String userId) async {
//     List<String> fileNames = [];

//     for (var file in selectedFiles) {
//       try {
//         // Replace with the actual user ID
//         String fileName = file.name ?? 'unknown_file';

//         // Upload the file to Firebase Storage
//         await FirebaseStorage.instance
//             .ref('arquivos/$userId/$fileName')
//             .putData(file.bytes!.buffer.asUint8List());

//         // Adiciona o nome do arquivo à lista
//         fileNames.add(fileName);

//         // Atualiza a lista de arquivos no Firestore
//         await FirebaseFirestore.instance
//             .collection('Clientes')
//             .doc(userId)
//             .update({'docs': FieldValue.arrayUnion(fileNames)});

//         print('Files updated successfully!');
//       } catch (e) {
//         print('Error updating files: $e');
//       }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    TextEditingController pre = TextEditingController();
    TextEditingController nomeCliente = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController cpf = TextEditingController();
    TextEditingController data = TextEditingController();
    TextEditingController anotacoes = TextEditingController();

    final alladmin = widget.users;
    return ListView.builder(
        itemCount: alladmin.length,
        itemBuilder: (context, index) {
          final user = alladmin[index];

          return ListTile(
            title: Text(user.titulo),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => VideoPlayerScreen(video: video),
              //   ),
              // );
            },
          );
        });
  }
}
