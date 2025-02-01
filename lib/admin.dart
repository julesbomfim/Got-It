import 'dart:core';

class Admin {
  String id;
  String titulo;
  String? descricao;
  String? material;
  String? material2;
  String? material3;
  String docsExercicios;
  String? docsVideos;
  final DateTime uploadDate;
  Admin({
    this.id = '',
    required this.docsExercicios,
    required this.docsVideos,
    required this.titulo,
    required this.descricao,
    required this.material,
    required this.material2,
    required this.material3,
    required this.uploadDate
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'docsVideos': docsVideos,
      'descricao': descricao,
      'material' : material,
      'material2' : material2,
      'material3' : material3,
      'docsExercicios': docsExercicios,
      'uploadDate': uploadDate.toIso8601String(), 
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        id: json['id'],
        titulo: json['titulo'],
        descricao: json['descricao'],
        material: json['material'],
        material2: json['material2'],
        material3: json['material3'],
        docsExercicios: json['docsExercicios'],
        docsVideos: json['docsVideos'],
        uploadDate: DateTime.parse(json['uploadDate'])
        );
  }

  // deleteUserDocExercicios(String docName) {
  //   docsExercicios.removeWhere((doc) => doc == docName);
  // }

  // addUserDocExercicios(String docName) {
  //   docsExercicios.add(docName);
  // }

//   deleteUserDocVideos(String docName) {
//     docsVideos.removeWhere((doc) => doc == docName);
//   }

//   addUserDocVideos(String docName) {
//     docsVideos.add(docName);
//   }
// }
}
