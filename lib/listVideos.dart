// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:ingleswebsite/admin.dart';
// import 'package:ingleswebsite/auth/authentic.dart';
// import 'package:ingleswebsite/geral/user.dart';
// import 'package:ingleswebsite/geral/user_docs_dialog_body.dart';

// class ListaVideos extends StatefulWidget {
//   final List<Admin> users;

//   ListaVideos({required this.users});

//   @override
//   State<ListaVideos> createState() => _ListaVideosState();
// }

// class _ListaVideosState extends State<ListaVideos> {
//   final statusValue = ValueNotifier('');
//   final dropCategoria = ['Finalizado', 'Pendente'];
//   AuthService authService = AuthService();
//   //final List<Map<String, dynamic>>? files = [];
//   List<Map<String, dynamic>>? files;

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController titulo = TextEditingController();
//     TextEditingController descricao = TextEditingController();

//     final alladmin = widget.users;
//     return ListView.builder(
//         itemCount: alladmin.length,
//         itemBuilder: (context, index) {
//           final user = alladmin[index];

//           return Card(
//               elevation: 8,
//               color: const Color(0xFF1b263b),
//               child: ExpansionTile(
//                   iconColor: Colors.white,
//                   collapsedIconColor: Colors.white,
//                   title: Text(user.titulo,
//                       style:
//                           const TextStyle(color: Colors.white, fontSize: 20)),
//                   leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: const Color(0xFF1b263b).withOpacity(0.5),
//                             border: Border.all(
//                               color: Color.fromARGB(255, 255, 255, 255),
//                             )),
//                       )),
//                   // Define the shape of the card
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(9),
//                       side: const BorderSide(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                       )),
//                   // Define how the card's content should be clipped

//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   // Define the child widget of the card
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         // Add padding around the row widget
//                         Padding(
//                           padding: const EdgeInsets.all(15),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               // Add an image widget to display an image

//                               // Add some spacing between the image and the text
//                               Container(width: 20),
//                               // Add an expanded widget to take up the remaining horizontal space
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     // Add some spacing between the top of the card and the title

//                                     // Add a title widget Container(height: 10),
//                                     Text('Serviço: ${user.titulo.toString()}',
//                                         style: const TextStyle(
//                                             color: Colors.white, fontSize: 20)),

//                                     // Add some spacing between the title and the subtitle
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                   child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: <Widget>[
//                                     const SizedBox(
//                                       height: 40,
//                                     ),
//                                     Row(children: [
//                                       SizedBox(
//                                         width: 120,
//                                       ),
//                                       Container(
//                                         child: TextButton(
//                                           onPressed: () {
//                                             showDialog(
//                                                 context: context,
//                                                 builder: ((context) =>
//                                                     AlertDialog(
//                                                       insetPadding:
//                                                           const EdgeInsets.all(
//                                                               6),
//                                                       backgroundColor:
//                                                           const Color(
//                                                               0xFF1b263b),
//                                                       // content:
//                                                       //     UserDocsDialogBody(
//                                                       //         user: user),
//                                                     )));
//                                           },
//                                           child: const Icon(
//                                             Icons.description,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           child: TextButton(
//                                               onPressed: () {
//                                                 String _radioValue = '';
//                                                 titulo.text = user.titulo;
//                                                 descricao.text =
//                                                     user.descricao.toString();

//                                                 showDialog(
//                                                     context: context,
//                                                     builder:
//                                                         ((context) =>
//                                                             AlertDialog(
//                                                               insetPadding:
//                                                                   const EdgeInsets
//                                                                       .all(6),
//                                                               backgroundColor:
//                                                                   const Color(
//                                                                       0xFF1b263b),
//                                                               content:
//                                                                   SingleChildScrollView(
//                                                                       child:
//                                                                           Container(
//                                                                 child: Column(
//                                                                   children: [
//                                                                     Container(
//                                                                       height:
//                                                                           650,
//                                                                       width:
//                                                                           650,
//                                                                       decoration: BoxDecoration(
//                                                                           borderRadius: BorderRadius.circular(10),
//                                                                           color: const Color(0xFF1b263b).withOpacity(0.5),
//                                                                           border: Border.all(
//                                                                             color:
//                                                                                 const Color(0xFF1b263b),
//                                                                           )),
//                                                                       child:
//                                                                           Column(
//                                                                         children: [
//                                                                           Row(
//                                                                             mainAxisAlignment:
//                                                                                 MainAxisAlignment.center,
//                                                                             children: [
//                                                                               Container(
//                                                                                 margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
//                                                                                 child: SizedBox(
//                                                                                   height: 60,
//                                                                                   width: 350,
//                                                                                   child: TextFormField(
//                                                                                       controller: titulo,
//                                                                                       style: const TextStyle(fontSize: 15, color: Colors.white),
//                                                                                       decoration: const InputDecoration(
//                                                                                           focusedBorder: OutlineInputBorder(
//                                                                                             borderSide: BorderSide(
//                                                                                               color: Color.fromARGB(255, 255, 255, 255),
//                                                                                             ),
//                                                                                           ),
//                                                                                           border: UnderlineInputBorder(),
//                                                                                           labelText: 'Nome',
//                                                                                           labelStyle: TextStyle(color: Colors.white, fontSize: 10))),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           Column(
//                                                                               children: [
//                                                                                 Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                   Container(
//                                                                                     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
//                                                                                     child: SizedBox(
//                                                                                       height: 60,
//                                                                                       width: 250,
//                                                                                       child: TextFormField(
//                                                                                           controller: descricao,
//                                                                                           style: const TextStyle(fontSize: 15, color: Colors.white),
//                                                                                           decoration: const InputDecoration(
//                                                                                               focusedBorder: OutlineInputBorder(
//                                                                                                 borderSide: BorderSide(
//                                                                                                   color: Color.fromARGB(255, 255, 255, 255),
//                                                                                                 ),
//                                                                                               ),
//                                                                                               border: UnderlineInputBorder(),
//                                                                                               labelText: 'descricao',
//                                                                                               labelStyle: TextStyle(color: Colors.white, fontSize: 10))),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Container(
//                                                                                     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
//                                                                                     child: SizedBox(
//                                                                                       height: 60,
//                                                                                       width: 140,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ]),
//                                                                                 Column(
//                                                                                   children: [
//                                                                                     Container(
//                                                                                       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
//                                                                                       child: SizedBox(
//                                                                                         width: 560,
//                                                                                         child: TextField(
//                                                                                           maxLines: 5,
//                                                                                           controller: descricao,
//                                                                                           style: const TextStyle(fontSize: 15, color: Colors.white),
//                                                                                           decoration: const InputDecoration(
//                                                                                               fillColor: Color.fromARGB(255, 21, 30, 46),
//                                                                                               filled: true,
//                                                                                               focusedBorder: OutlineInputBorder(
//                                                                                                 borderSide: BorderSide(
//                                                                                                   color: Color.fromARGB(255, 255, 255, 255),
//                                                                                                 ),
//                                                                                               ),
//                                                                                               border: UnderlineInputBorder(),
//                                                                                               labelText: 'Anotações',
//                                                                                               labelStyle: TextStyle(color: Colors.white, fontSize: 10)),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ],
//                                                                                 ),
//                                                                                 Column(children: [
//                                                                                   Row(children: [
//                                                                                     Expanded(
//                                                                                       child: Column(
//                                                                                         children: <Widget>[
//                                                                                           Container(
//                                                                                             margin: EdgeInsets.symmetric(horizontal: 30),
//                                                                                             child: ListTile(
//                                                                                               title: Text("PROJETO BB", style: TextStyle(color: Colors.white)),
//                                                                                               leading: Radio(
//                                                                                                   value: 'PROJETO BB',
//                                                                                                   activeColor: Color.fromARGB(255, 255, 255, 255),
//                                                                                                   groupValue: _radioValue,
//                                                                                                   onChanged: (value) {
//                                                                                                     setState(() {
//                                                                                                       _radioValue = value.toString();
//                                                                                                     });
//                                                                                                   }),
//                                                                                             ),
//                                                                                           ),
//                                                                                           Container(
//                                                                                             margin: const EdgeInsets.symmetric(horizontal: 30),
//                                                                                             child: ListTile(
//                                                                                               title: const Text("CCIR e ITR", style: TextStyle(color: Colors.white)),
//                                                                                               leading: Radio(
//                                                                                                   value: 'CCIR e ITR',
//                                                                                                   activeColor: const Color.fromARGB(255, 255, 255, 255),
//                                                                                                   groupValue: _radioValue,
//                                                                                                   onChanged: (value) {
//                                                                                                     setState(() {
//                                                                                                       _radioValue = value.toString();
//                                                                                                     });
//                                                                                                   }),
//                                                                                             ),
//                                                                                           ),
//                                                                                           Container(
//                                                                                             margin: const EdgeInsets.symmetric(horizontal: 30),
//                                                                                             child: ListTile(
//                                                                                               title: const Text("GEO", style: TextStyle(color: Colors.white)),
//                                                                                               leading: Radio(
//                                                                                                   value: 'GEO',
//                                                                                                   groupValue: _radioValue,
//                                                                                                   activeColor: const Color.fromARGB(255, 255, 255, 255),
//                                                                                                   onChanged: (value) {
//                                                                                                     setState(() {
//                                                                                                       _radioValue = value.toString();
//                                                                                                     });
//                                                                                                   }),
//                                                                                             ),
//                                                                                           ),
//                                                                                           Container(
//                                                                                               margin: const EdgeInsets.symmetric(horizontal: 30),
//                                                                                               child: ListTile(
//                                                                                                 title: const Text("CAR/CEFIR", style: TextStyle(color: Colors.white)),
//                                                                                                 leading: Radio(
//                                                                                                     value: 'CAR/CEFIR',
//                                                                                                     groupValue: _radioValue,
//                                                                                                     activeColor: const Color.fromARGB(255, 255, 255, 255),
//                                                                                                     onChanged: (value) {
//                                                                                                       setState(() {
//                                                                                                         _radioValue = value.toString();
//                                                                                                       });
//                                                                                                     }),
//                                                                                               ))
//                                                                                         ],
//                                                                                       ),
//                                                                                     ),
//                                                                                     Expanded(
//                                                                                       child: Container(
//                                                                                         padding: const EdgeInsets.all(60),
//                                                                                         child: ValueListenableBuilder(
//                                                                                             valueListenable: statusValue,
//                                                                                             builder: (BuildContext context, String value, _) {
//                                                                                               return SizedBox(
//                                                                                                 child: DropdownButtonFormField(
//                                                                                                   dropdownColor: const Color(0xFF1b263b),
//                                                                                                   focusColor: const Color.fromARGB(255, 255, 255, 255),
//                                                                                                   style: const TextStyle(color: Colors.white),
//                                                                                                   isExpanded: true,
//                                                                                                   hint: const Text(
//                                                                                                     'Selecione a opção',
//                                                                                                     style: TextStyle(color: Colors.white),
//                                                                                                   ),
//                                                                                                   decoration: InputDecoration(
//                                                                                                     fillColor: const Color.fromARGB(255, 255, 255, 255),
//                                                                                                     labelText: 'Status',
//                                                                                                     labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
//                                                                                                     border: OutlineInputBorder(
//                                                                                                       borderRadius: BorderRadius.circular(6),
//                                                                                                       borderSide: const BorderSide(
//                                                                                                         color: Color.fromARGB(255, 255, 255, 255),
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                     focusedBorder: const OutlineInputBorder(
//                                                                                                       borderSide: BorderSide(
//                                                                                                         color: Color.fromARGB(255, 255, 255, 255),
//                                                                                                       ), //<-- SEE HERE
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   value: (value.isEmpty) ? null : value,
//                                                                                                   onChanged: (escolha) => statusValue.value = escolha.toString(),
//                                                                                                   items: dropCategoria
//                                                                                                       .map(
//                                                                                                         (op) => DropdownMenuItem(
//                                                                                                           child: Text(op),
//                                                                                                           value: op,
//                                                                                                         ),
//                                                                                                       )
//                                                                                                       .toList(),
//                                                                                                 ),
//                                                                                               );
//                                                                                             }),
//                                                                                       ),
//                                                                                     )
//                                                                                   ])
//                                                                                 ]),
//                                                                               ]),
//                                                                           Container(
//                                                                               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 25.0),
//                                                                               child: SizedBox(
//                                                                                 height: 40,
//                                                                                 width: 200,
//                                                                                 child: ElevatedButton(
//                                                                                     onPressed: () async {
//                                                                                       final newUser = Admin(id: user.id, titulo: titulo.text, descricao: descricao.text, docsVideos: user.docsVideos);

//                                                                                       //   await authService.updateUser(newUser);

//                                                                                       Navigator.pop(context);

//                                                                                       setState(() {
//                                                                                         titulo.text = '';
//                                                                                         descricao.text = '';
//                                                                                       });
//                                                                                     },
//                                                                                     style: ButtonStyle(
//                                                                                       backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xFF0d1b2a)),
//                                                                                     ),
//                                                                                     child: Row(
//                                                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                                                       children: [
//                                                                                         Icon(Icons.update, color: Colors.white),
//                                                                                         Padding(
//                                                                                           padding: EdgeInsets.all(7),
//                                                                                           child: Text('Atualizar', style: TextStyle(color: Colors.white)),
//                                                                                         ),
//                                                                                       ],
//                                                                                     )),
//                                                                               ))
//                                                                         ],
//                                                                       ),
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               )),
//                                                             )));
//                                               },
//                                               child: const Icon(Icons.edit,
//                                                   size: 30,
//                                                   color: Colors.greenAccent))),
//                                       Container(
//                                           child: TextButton(
//                                               onPressed: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     builder: (context) =>
//                                                         AlertDialog(
//                                                           title: Text(
//                                                             'Deseja apagar os dados do(a) cliente ${user.titulo}?',
//                                                             style: TextStyle(
//                                                                 fontSize: 15),
//                                                           ),
//                                                           actions: [
//                                                             ElevatedButton(
//                                                                 onPressed:
//                                                                     () async {
//                                                                   await authService
//                                                                       .deleteUser(
//                                                                           user.id);
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 },
//                                                                 child: Text(
//                                                                   'Sim',
//                                                                   style: TextStyle(
//                                                                       color: Color(
//                                                                           0xFF1b263b)),
//                                                                 )),
//                                                             ElevatedButton(
//                                                                 onPressed: () {
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 },
//                                                                 child: Text(
//                                                                   'Não',
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: Color(
//                                                                         0xFF1b263b),
//                                                                   ),
//                                                                 ))
//                                                           ],
//                                                         ));
//                                               },
//                                               child: const Icon(
//                                                 Icons.delete_outline,
//                                                 size: 30,
//                                                 color: Colors.redAccent,
//                                               )))
//                                     ])
//                                   ]))
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ]));
//         });
//   }
// }
