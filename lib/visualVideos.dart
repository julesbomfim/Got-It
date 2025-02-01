// import 'dart:convert';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:ingleswebsite/admin.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';

// class VisualizarVideos extends StatefulWidget {
//   const VisualizarVideos({Key? key}) : super(key: key);

//   @override
//   _VisualizarVideosState createState() => _VisualizarVideosState();
// }

// class _VisualizarVideosState extends State<VisualizarVideos> {
//   List<Admin> videos = [];

//   @override
//   void initState() {
//     super.initState();
//     // Carregar vídeos do Firestore
//     loadVideos();
//   }

//   Future<void> loadVideos() async {
//     final QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection('Videos').get();

//     setState(() {
//       videos = querySnapshot.docs
//           .map((doc) => Admin.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lista de Vídeos'),
//       ),
//       body: videos.isNotEmpty
//           ? ListView.builder(
//               itemCount: videos.length,
//               itemBuilder: (context, index) {
//                 final video = videos[index];
//                 return ListTile(
//                   title: Text(video.titulo),
//                   subtitle: Text(video.descricao ?? 'Sem descrição'),
//                   leading: Container(
//                     width: 100, // Largura fixa para a miniatura do vídeo
//                     height: 100, // Altura fixa para a miniatura do vídeo
//                     child: FutureBuilder<String>(
//                       future:
//                           _getVideoThumbnail(video), // Obter miniatura do vídeo
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return CircularProgressIndicator(
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.blue),
//                           );
//                         } else if (snapshot.hasError || snapshot.data == null) {
//                           return Icon(Icons.error); // Ícone de erro padrão
//                         } else {
//                           final thumbnailUrl = snapshot.data!;
//                           return Image.network(
//                             thumbnailUrl,
//                             width: 100, // Largura fixa para a imagem
//                             height: 100, // Altura fixa para a imagem
//                             fit: BoxFit
//                                 .cover, // Ajustar a imagem dentro do Container
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => VideoPlayerScreen(video: video),
//                       ),
//                     );
//                   },
//                 );
//               },
//             )
//           : Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               ),
//             ),
//     );
//   }

//   Future<String> _getVideoThumbnail(Admin video) async {
//     final fileNames = video.docsVideos;

//     // Verificar se a lista de fileNames não é nula e não está vazia
//     if (fileNames != null && fileNames.isNotEmpty) {
//       // Verificar se algum dos fileNames corresponde a um formato de vídeo reconhecido
//       for (final fileName in fileNames.split(', ')) {
//         if (_isVideo(fileName)) {
//           final videoUrl = await FirebaseStorage.instance
//               .ref('arquivos/${video.id}/$fileName')
//               .getDownloadURL();

//           final uint8list = await VideoThumbnail.thumbnailData(
//             video: videoUrl,
//             imageFormat: ImageFormat.PNG,
//             maxWidth: 100,
//             quality: 25,
//           );

//           // Convertendo os bytes para base64
//           final base64String = uint8list != null ? base64Encode(uint8list) : '';

//           return 'data:image/png;base64,$base64String';
//         }
//       }
//     }

//     // Retorna uma string vazia se não encontrar um arquivo de vídeo
//     return '';
//   }

// // Função auxiliar para verificar se um nome de arquivo corresponde a um formato de vídeo reconhecido
//   bool _isVideo(String fileName) {
//     final videoExtensions = [
//       '.mp4',
//       '.mov',
//       '.avi',
//       '.mkv',
//       '.wmv',
//       '.flv',
//       '.webm'
//     ];
//     return videoExtensions.any((ext) => fileName.toLowerCase().endsWith(ext));
//   }
// }

// class VideoPlayerScreen extends StatefulWidget {
//   final Admin video;

//   const VideoPlayerScreen({required this.video});

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late Future<ChewieController> _chewieControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _chewieControllerFuture = _initializePlayer();
//   }

//   Future<ChewieController> _initializePlayer() async {
//     final fileNames = widget.video.docsVideos;
//     print('object:, $fileNames');
//     final videoUrl = await FirebaseStorage.instance
//         .ref('arquivos/${widget.video.id}/$fileNames')
//         .getDownloadURL();

//     final chewieController = ChewieController(
//       autoPlay: true,
//       looping: false,
//       aspectRatio: 16 / 9,
//       videoPlayerController: VideoPlayerController.network(videoUrl),
//     );
//     return chewieController;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player'),
//       ),
//       body: FutureBuilder<ChewieController>(
//         future: _chewieControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               ),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           final chewieController = snapshot.data!;
//           return Chewie(controller: chewieController);
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _chewieControllerFuture.then((chewieController) {
//       chewieController.dispose();
//     });
//   }
// }
