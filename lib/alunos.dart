import 'dart:core';

class Alunos {
  String id;
  String nome;
  String email;
  String senha;
  String confirmarSenha;
  Map<String, double> progresso; 
  
  Alunos({
    this.id = '',
    required this.senha,
    required this.confirmarSenha,
    required this.nome,
    required this.email,
      required this.progresso, 
  }) ;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'confirmarSenha': confirmarSenha,
      'email': email,
      'senha': senha,
   'progresso': progresso,
  
    };
  }

  factory Alunos.fromJson(Map<String, dynamic> json) {
    return Alunos(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Nome não especificado',
      email: json['email'] ?? 'Email não especificado',
      senha: json['senha'] ?? '',
      confirmarSenha: json['confirmarSenha'] ?? '',
     progresso: Map<String, double>.from(json['progresso'] ?? {}),
    );
  }

  // deleteUserDocExercicios(String docName) {
  //   senha.removeWhere((doc) => doc == docName);
  // }

  // addUserDocExercicios(String docName) {
  //   senha.add(docName);
  // }

//   deleteUserDocVideos(String docName) {
//     confirmarSenha.removeWhere((doc) => doc == docName);
//   }

//   addUserDocVideos(String docName) {
//     confirmarSenha.add(docName);
//   }
// }
}


//  final List<FAQ> faqs = [
//     FAQ(
//       question: 'Qual é o horário de funcionamento?',
//       answer: 'Nosso horário de funcionamento é das 9h às 18h, de segunda a sexta-feira.',
//     ),
//     FAQ(
//       question: 'Como faço para solicitar um reembolso?',
//       answer: 'Você pode solicitar um reembolso entrando em contato com nossa equipe de suporte através do telefone ou e-mail fornecido no site.',
//     ),
//     FAQ(
//       question: 'Posso alterar meu pedido após a compra?',
//       answer: 'Sim, você pode alterar seu pedido antes que ele seja processado. Entre em contato conosco o mais rápido possível para fazer as alterações necessárias.',
//     ),
//   ];


//      ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: faqs.length,
//                       itemBuilder: (context, index) {
//                         return ExpansionTile(
//                           title: Text(
//                             faqs[index].question,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                               child: Text(faqs[index].answer),
//                             ),
//                           ],
//                         );
//                       },
//                     ),

//                     class FAQ {
//   final String question;
//   final String answer;

//   FAQ({
//     required this.question,
//     required this.answer,
//   });
// }