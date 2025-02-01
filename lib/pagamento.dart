

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
///// corretoooooooooooooooooooooooooooooooo
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:universal_html/html.dart';

// class PaymentService {
//   final String publicKey = 'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354';

//   Future<void> startCheckout() async {
//     final url = Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 1.0,
//           }
//         ],
//         'payer': {
//           'email': 'jules_bomfim@hotmail.com'
//         },
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];

//       // Abrir URL do checkout
//       // Navegador padrão para Flutter Web
//       window.open(checkoutUrl, '_self');
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }
// }



// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _paymentService.startCheckout();
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }
// }


///////////////////////////////
///
///
///
///
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:html';
// import 'package:flutter/material.dart';

// class PaymentService {
//   final String publicKey = 'TEST-393368402860510-072715-9e3e5831d8429e0ffd8f026fe8d4d394-593363354';

//   Future<void> startCheckout(BuildContext context) async {
//     try {
//       final url = Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'items': [
//             {
//               'title': 'Produto',
//               'quantity': 1,
//               'unit_price': 10.0,
//             }
//           ],
//           'payer': {
//             'email': 'test_user_12345@testuser.com'
//           },
//         }),
//       );

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final checkoutUrl = data['init_point'];

//         // Abrir URL do checkout
//         window.open(checkoutUrl, '_self');

//         // Navegar para a tela de sucesso após um tempo para o pagamento ser processado
//         Future.delayed(Duration(seconds: 5), () {
//           Navigator.pushNamed(context, '/register');
//         });
//       } else {
//         print('Falha ao criar preferência de checkout: ${response.statusCode} ${response.body}');
//         _showErrorDialog(context, 'Failed to create checkout preference.');
//       }
//     } catch (e) {
//       print('Erro ao iniciar o checkout: $e');
//       _showErrorDialog(context, 'Erro ao iniciar o checkout: $e');
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Erro'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }




// class SuccessPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sucesso'),
//       ),
//       body: Center(
//         child: Text(
//           'Pagamento efetuado com sucesso!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }



// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await _paymentService.startCheckout(context);
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }
// }

///////
///
////
// ////
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;
// import 'package:universal_html/js.dart';

// class PaymentService {
//   final String publicKey =
//       'TEST-393368402860510-072715-9e3e5831d8429e0ffd8f026fe8d4d394-593363354';

//   Future<void> startCheckout() async {
//     final url = Uri.parse(
//         'https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 0.01,
//           }
//         ],
//         'back_urls': {
//           'success': 'https://ingles-ac531.web.app/#/register',
//           'failure': 'https://ingles-ac531.web.app/#/register',
//           'pending': 'https://ingles-ac531.web.app/#/register',
//         },
//         'auto_return': 'approved',
      
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];

//       // Abrir URL do checkout
//       // Navegador padrão para Flutter Web
//       html.window.open(checkoutUrl, '_self');
      
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }
  
// }


// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//               _paymentService.startCheckout().catchError((error) {
//               // Handle the error appropriately here
//               print('Error during checkout: $error');
//             });
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }
// }
/////////////
///
///
// ///
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;

// class PaymentService {
//   final String publicKey =
//       'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354';
//   String? preferenceId;

//   Future<void> startCheckout(BuildContext context) async {
//     final url = Uri.parse(
//         'https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 0.01,
//           }
//         ],
//         'back_urls': {
//           'success': 'https://yourapp.com/#/result?status=success',
//           'failure': 'https://yourapp.com/#/result?status=failure',
//           'pending': 'https://yourapp.com/#/result?status=pending',
//         },
//         'auto_return': 'approved',
//         'payment_methods': {
//           'excluded_payment_types': [
//             {'id': 'ticket'}, // Exclude payment methods you don't want, or leave empty for all methods
//           ],
//           'installments': 12 // Maximum number of installments for credit card payments
//         },
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];
//       preferenceId = data['id']; // Assign the preferenceId here

//       // Open the checkout URL in the default browser for Flutter Web
//       html.window.open(checkoutUrl, '_self');

//       await Future.delayed(Duration(seconds: 10)); // Wait to simulate payment processing time
//       _checkPaymentStatus(context);
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }

//   Future<void> _checkPaymentStatus(BuildContext context) async {
//     if (preferenceId == null) return;

//     final url = Uri.parse(
//         'https://api.mercadopago.com/v1/payments/search?preference_id=$preferenceId&access_token=$publicKey');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final results = data['results'];
//       if (results.isNotEmpty) {
//         final status = results[0]['status'];
//         if (status == 'approved') {
//           Navigator.pushNamed(context, '/register');
//         } else {
//           Navigator.pushNamed(context, '/payment-failure');
//         }
//       }
//     } else {
//       throw Exception('Failed to check payment status.');
//     }
//   }
// }

// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//               _paymentService.startCheckout(context).catchError((error) {
//               // Handle the error appropriately here
//               print('Error during checkout: $error');
//             });
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;

// class PaymentService {
//   final String publicKey = 'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354';

//   Future<void> startCheckout(String sessionId) async {
//     final url = Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 0.01,
            
//           }
//         ],
//         'back_urls': {
//           'success': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=success',
//           'failure': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=failure',
//           'pending': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=pending',
//         },
//         'auto_return': 'approved',
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];
//       html.window.open(checkoutUrl, '_self');
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }
// }

// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             final sessionId = _generateSessionId();
//             _paymentService.startCheckout(sessionId).catchError((error) {
//               print('Error during checkout: $error');
//             });
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }

//   String _generateSessionId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;

// class PaymentService {
//   final String publicKey = 'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354';

//   Future<void> startCheckout(String sessionId) async {
//     final url = Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 0.01,
//           }
//         ],
//         'back_urls': {
//           'success': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=success',
//           'failure': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=failure',
//           'pending': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=pending',
//         },
//         'notification_url': 'https://ingles-ac531.web.app/webhook',
//         'metadata': {
//           'sessionId': sessionId
//         },
//         'auto_return': 'approved',
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];
//       html.window.open(checkoutUrl, '_self');
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }
// }


// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final PaymentService _paymentService = PaymentService();
//   Timer? _timer;
//   String _sessionId = '';

//   @override
//   void initState() {
//     super.initState();
//     _sessionId = _generateSessionId();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _startPaymentProcess() {
//     _paymentService.startCheckout(_sessionId).catchError((error) {
//       print('Error during checkout: $error');
//     });

//     // Start polling
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       _checkPaymentStatus();
//     });
//   }

//   Future<void> _checkPaymentStatus() async {
//     final response = await http.get(Uri.parse('https://ingles-ac531.web.app/payment-status?sessionId=$_sessionId'));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == 'approved') {
//         _timer?.cancel();
//         Navigator.pushNamed(context, '/register');
//       }
//     } else {
//       print('Failed to check payment status.');
//     }
//   }

//   String _generateSessionId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _startPaymentProcess,
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }
// }
//////
///
///
///
// ///
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;

// class PaymentService {
//   final String publicKey = 'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354';

//   Future<void> startCheckout(String sessionId) async {
//     final url = Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 0.01,
//           }
//         ],
//         'back_urls': {
//           'success': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=success',
//           'failure': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=failure',
//           'pending': 'https://ingles-ac531.web.app/#/register?sessionId=$sessionId&status=pending',
//         },
//         'auto_return': 'approved',
//         'payment_methods': {
//           'excluded_payment_types': [
//             {'id': 'atm'}, // Exclude only ATM payments
//           ],
//           'default_payment_method_id': null, // No default payment method
//           'installments': 12, // Allow payments up to 12 installments
//         },
//         'binary_mode': false, // Disable binary mode for flexible payments
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];
//       html.window.open(checkoutUrl, '_self');
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }
// }



// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             final sessionId = _generateSessionId();
//             _paymentService.startCheckout(sessionId).catchError((error) {
//               print('Error during checkout: $error');
//             });
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }

//   String _generateSessionId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }import 'package:flutter/material.dart';





/////////sdfsdfsdf///////////////sdfsdfs/d///////////////////



// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;

// class PaymentService {
//   final String publicKey =
//       'APP_USR-5789704230948779-061511-5307ddeb5715b5d517f5d3690a798d87-593363354';

//   Future<void> startCheckout() async {
//     final url = Uri.parse(
//         'https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'items': [
//           {
//             'title': 'Produto',
//             'quantity': 1,
//             'unit_price': 0.01,
//           }
//         ],
//         'back_urls': {
//           'success': 'https://ingles-ac531.web.app/#/register',
//           'failure': 'https://ingles-ac531.web.app/#/register',
//           'pending': 'https://ingles-ac531.web.app/#/register',
//         },
//         'auto_return': 'approved',
      
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final checkoutUrl = data['init_point'];
//       final paymentId = data['id']; // Pegue o ID do pagamento

//       // Abrir URL do checkout
//       // Navegador padrão para Flutter Web
//       html.window.open(checkoutUrl, '_self');

//       // Após o pagamento, verificar o status do pagamento
//       await Future.delayed(Duration(minutes: 2)); // Esperar alguns minutos antes de checar o status
//       checkPaymentStatus(paymentId);
      
//     } else {
//       throw Exception('Failed to create checkout preference.');
//     }
//   }
  
//   Future<void> checkPaymentStatus(String paymentId) async {
//     final url = Uri.parse('http://localhost:3000/payment-status/$paymentId'); // URL do backend
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final status = data['status'];
//       // Processar o status do pagamento
//       print('Status do pagamento: $status');
//     } else {
//       throw Exception('Failed to fetch payment status.');
//     }
//   }
// }



// class PaymentPage extends StatelessWidget {
//   final PaymentService _paymentService = PaymentService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/menu.png'), // Caminho da sua imagem de fundo
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               if (constraints.maxWidth < 600) {
//                 // Layout para dispositivos móveis
//                 return buildMobileLayout(context);
//               } else {
//                 // Layout para dispositivos maiores (tablets, desktops)
//                 return buildDesktopLayout(context);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildMobileLayout(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16.0),
//                 image: DecorationImage(
//                   image: AssetImage('assets/identidade.png'), // Caminho da imagem do curso
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16.0),
//                 border: Border.all(
//                   color: Colors.blue, // Cor da borda azul
//                   width: 2.0, // Largura da borda
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Preço: R\$ 99,99',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'O Que Você Vai Adquirir:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.0),
//                   buildFeatureSection(
//                     'Aulas Gravadas:',
//                     [
//                       'Acesso a aulas semanais.',
//                       'Gravações das aulas para revisão a qualquer momento.',
//                     ],
//                   ),
//                   SizedBox(height: 12.0),
//                   buildFeatureSection(
//                     'Material Didático Completo:',
//                     [
//                       'Apostilas e livros digitais cobrindo gramática, vocabulário e exercícios práticos.',
//                       'Acesso a uma plataforma online com atividades interativas.',
//                     ],
//                   ),
//                   SizedBox(height: 12.0),
//                   buildFeatureSection(
//                     'Ambiente de Prática:',
//                     [
//                       'Fórum de discussões para interação com outros alunos e professores.',
//                       'Monitoramento do progresso.',
//                     ],
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Vantagens do Nosso Curso:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.0),
//                   buildAdvantagesSection(),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Matricule-se agora e comece a transformar seu futuro com o domínio do inglês!',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Para mais informações, entre em contato pelo WhatsApp +55 (11) 98040-4392',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       _paymentService.startCheckout().catchError((error) {
//                         // Handle the error appropriately here
//                         print('Error during checkout: $error');
//                       });
//                     },
//                     child: Text(
//                       'Matricule-se',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith(
//                           (states) => Color.fromARGB(255, 30, 98, 170)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDesktopLayout(BuildContext context) {
//     return Center(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.7,
//         height: MediaQuery.of(context).size.height * 0.8,
//         padding: EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16.0),
//           border: Border.all(
//             color: Colors.blue, // Cor da borda azul
//             width: 2.0, // Largura da borda
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Lado Esquerdo: Imagem
//             Column( children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.3,
//               height: MediaQuery.of(context).size.height * 0.7,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16.0),
//                 image: DecorationImage(
//                   image: AssetImage('assets/identidade.png'), // Caminho da imagem do curso
//                   fit: BoxFit.cover,
//                 ),
//               ),
             
                    
//             ),
//               ElevatedButton(
//                       onPressed: () {
//                         _paymentService.startCheckout().catchError((error) {
//                           // Handle the error appropriately here
//                           print('Error during checkout: $error');
//                         });
//                       },
//                       child: Text(
//                         'Matricule-se',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.resolveWith(
//                             (states) => Color.fromARGB(255, 30, 98, 170)),
//                       ),
//                     ),
//             ]),
//             SizedBox(width: 16.0), // Espaço entre a imagem e as informações
//             // Lado Direito: Informações do Curso
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Preço: R\$ 99,99',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'O Que Você Vai Adquirir:',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     buildFeatureSection(
//                       'Aulas Gravadas:',
//                       [
//                         'Acesso a aulas semanais.',
//                         'Gravações das aulas para revisão a qualquer momento.',
//                       ],
//                     ),
//                     SizedBox(height: 12.0),
//                     buildFeatureSection(
//                       'Material Didático Completo:',
//                       [
//                         'Apostilas e livros digitais cobrindo gramática, vocabulário e exercícios práticos.',
//                         'Acesso a uma plataforma online com atividades interativas.',
//                       ],
//                     ),
//                     SizedBox(height: 12.0),
//                     buildFeatureSection(
//                       'Ambiente de Prática:',
//                       [
//                         'Fórum de discussões para interação com outros alunos e professores.',
//                         'Monitoramento do progresso.',
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'Vantagens do Nosso Curso:',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     buildAdvantagesSection(),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'Matricule-se agora e comece a transformar seu futuro com o domínio do inglês!',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'Para mais informações, entre em contato pelo WhatsApp +55 (11) 98040-4392',
//                       style: TextStyle(fontSize: 16),
//                     ),
                   
//                   ],
//                 ),
               
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildFeatureSection(String title, List<String> features) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8.0),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: features.map((feature) => buildFeatureItem(feature)).toList(),
//         ),
//       ],
//     );
//   }

//   Widget buildFeatureItem(String feature) {
//     return Padding(
//       padding: EdgeInsets.only(left: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.check_circle, color: Colors.green),
//           SizedBox(width: 8.0),
//           Flexible(
//             child: Text(feature),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildAdvantagesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildAdvantageItem('Flexibilidade de horários para se adaptar à sua rotina.'),
//         buildAdvantageItem('Métodos de ensino modernos e eficazes.'),
//         buildAdvantageItem('Suporte contínuo durante todo o curso.'),
//       ],
//     );
//   }

//   Widget buildAdvantageItem(String advantage) {
//     return Padding(
//       padding: EdgeInsets.only(left: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.check_circle, color: Colors.green),
//           SizedBox(width: 8.0),
//           Flexible(
//             child: Text(advantage),
//           ),
//         ],
//       ),
//     );
//   }
// }



////////////////////////fdgdfgdgdgf//////////////////////////gffgdgfdgd
///
///






// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;


// class PaymentService {
//   final String publicKey = 'APP_USR-393368402860510-072715-3b26213f5d9920026b84ba3cb075962c-593363354';

//   Future<void> startCheckout() async {
//     final url = Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
    
//     // JSON body being sent
//     final body = jsonEncode({
//       'items': [
//         {
//           'title': 'Produto',
//           'quantity': 1,
//           'unit_price': 0.01,
//           'currency_id': 'BRL'
//         }
//       ],
//       'back_urls': {
//         'success': 'https://ingles-ac531.web.app/register',
//         'failure': 'https://ingles-ac531.web.app/register',
//         'pending': 'https://ingles-ac531.web.app/register',
//       },
//       'auto_return': 'all', // Certifique-se de que esta configuração está correta
//       'notification_url': 'https://9cd4-2804-4364-ced4-3000-109c-71ef-a022-dc85.ngrok-free.app/webhook'
//     });
    
//     print('Sending JSON body: $body'); // Log the JSON body being sent

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );

//     print('Received response: ${response.body}'); // Log the response body

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       print('Checkout preference created: $data'); // Log de depuração
//       final checkoutUrl = data['init_point'];
//       final paymentId = data['id']; // Pegue o ID do pagamento

//       // Abrir URL do checkout
//       html.window.open(checkoutUrl, '_self');

//   //     // Após o pagamento, verificar o status do pagamento
//   //     await Future.delayed(Duration(minutes: 2)); // Esperar alguns minutos antes de checar o status
//   //     checkPaymentStatus(paymentId);
//   //   } else {
//   //     print('Failed to create checkout preference. Status code: ${response.statusCode} Response: ${response.body}'); // Log de erro
//   //     throw Exception('Failed to create checkout preference.');
//   //   }
//   // }

//   // Future<void> checkPaymentStatus(String paymentId) async {
//   //   final url = Uri.parse('https://9cd4-2804-4364-ced4-3000-109c-71ef-a022-dc85.ngrok-free.app/payment-status/$paymentId'); // URL do backend
//   //   final response = await http.get(url);

//   //   print('Received response for payment status: ${response.body}'); // Log the response body

//   //   if (response.statusCode == 200) {
//   //     final data = jsonDecode(response.body);
//   //     final status = data['status'];
//   //     // Processar o status do pagamento
//   //     print('Status do pagamento: $status');
//   //   } else {
//   //     print('Failed to fetch payment status. Status code: ${response.statusCode} Response: ${response.body}'); // Log de erro
//   //     throw Exception('Failed to fetch payment status.');
//   //   }
//   // }
// }}}

// class PaymentPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             PaymentService().startCheckout().catchError((error) {
//               print('Error during checkout: $error');
//             });
//           },
//           child: Text('Pagar'),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:universal_html/html.dart' as html;

import 'package:crypto/crypto.dart';
class PaymentService {
  final String publicKey =
      'APP_USR-4583221855453770-062809-30be773f48a6a6d4bf6d7b350b61d964-1620217202';

  Future<void> startCheckout() async {
    final url = Uri.parse(
        'https://api.mercadopago.com/checkout/preferences?access_token=$publicKey');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'items': [
          {
            'title': 'Curso - Got It',
            'quantity': 1,
            'unit_price': 100.00,
            'currency_id': 'BRL'
          }
        ],
        'back_urls': {
           'success': 'https://ingles-ac531.web.app/redirect.html',
          'failure': 'https://ingles-ac531.web.app/redirect2.html',
          'pending': 'https://ingles-ac531.web.app/redirect2.html',
        },
        'auto_return': 'approved',
          'payment_methods': {
          'excluded_payment_types': [
            {'id': 'ticket'}
          ],
          'excluded_payment_methods': [
   
            {'id': 'bolbradesco'} // código para boleto bancário
          ]
        },
        
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final checkoutUrl = data['init_point'];

      // Abrir URL do checkout
      html.window.open(checkoutUrl, '_self');
    } else {
      print('Erro: ${response.statusCode}');
      print('Resposta: ${response.body}');
      throw Exception('Failed to create checkout preference.');
    }
  }
}

class PaymentPage extends StatelessWidget {
  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menu.png'), // Caminho da sua imagem de fundo
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Layout para dispositivos móveis
                return buildMobileLayout(context);
              } else {
                // Layout para dispositivos maiores (tablets, desktops)
                return buildDesktopLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: AssetImage('assets/identidade.png'), // Caminho da imagem do curso
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Colors.blue, // Cor da borda azul
                  width: 2.0, // Largura da borda
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preço: R\$ 99,99',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'O Que Você Vai Adquirir:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  buildFeatureSection(
                    'Aulas Gravadas:',
                    [
                      'Acesso a aulas semanais.',
                      'Gravações das aulas para revisão a qualquer momento.',
                    ],
                  ),
                  SizedBox(height: 12.0),
                  buildFeatureSection(
                    'Material Didático Completo:',
                    [
                      'Apostilas e livros digitais cobrindo gramática, vocabulário e exercícios práticos.',
                      'Acesso a uma plataforma online com atividades interativas.',
                    ],
                  ),
                  SizedBox(height: 12.0),
                  buildFeatureSection(
                    'Ambiente de Prática:',
                    [
                      'Fórum de discussões para interação com outros alunos e professores.',
                      'Monitoramento do progresso.',
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Vantagens do Nosso Curso:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  buildAdvantagesSection(),
                  SizedBox(height: 16.0),
                  Text(
                    'Matricule-se agora e comece a transformar seu futuro com o domínio do inglês!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Para mais informações, entre em contato pelo WhatsApp +55 (11) 98040-4392',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _showPaymentDialog(context);
                    },
                    child: Text(
                      'Matricule-se',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Color.fromARGB(255, 30, 98, 170)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.blue, // Cor da borda azul
            width: 2.0, // Largura da borda
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lado Esquerdo: Imagem
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: AssetImage('assets/identidade.png'), // Caminho da imagem do curso
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showPaymentDialog(context);
                  },
                  child: Text(
                    'Matricule-se',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color.fromARGB(255, 30, 98, 170)),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.0), // Espaço entre a imagem e as informações
            // Lado Direito: Informações do Curso
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preço: R\$ 99,99',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'O Que Você Vai Adquirir:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    buildFeatureSection(
                      'Aulas Gravadas:',
                      [
                        'Acesso a aulas semanais.',
                        'Gravações das aulas para revisão a qualquer momento.',
                      ],
                    ),
                    SizedBox(height: 12.0),
                    buildFeatureSection(
                      'Material Didático Completo:',
                      [
                        'Apostilas e livros digitais cobrindo gramática, vocabulário e exercícios práticos.',
                        'Acesso a uma plataforma online com atividades interativas.',
                      ],
                    ),
                    SizedBox(height: 12.0),
                    buildFeatureSection(
                      'Ambiente de Prática:',
                      [
                        'Fórum de discussões para interação com outros alunos e professores.',
                        'Monitoramento do progresso.',
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Vantagens do Nosso Curso:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    buildAdvantagesSection(),
                    SizedBox(height: 16.0),
                    Text(
                      'Matricule-se agora e comece a transformar seu futuro com o domínio do inglês!',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Para mais informações, entre em contato pelo WhatsApp +55 (11) 98040-4392',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureSection(String title, List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: features.map((feature) => buildFeatureItem(feature)).toList(),
        ),
      ],
    );
  }

  Widget buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(feature),
          ),
        ],
      ),
    );
  }

  Widget buildAdvantagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAdvantageItem('Flexibilidade de horários para se adaptar à sua rotina.'),
        buildAdvantageItem('Métodos de ensino modernos e eficazes.'),
        buildAdvantageItem('Suporte contínuo durante todo o curso.'),
      ],
    );
  }

  Widget buildAdvantageItem(String advantage) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(advantage),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pagamento via PIX'),
          content: Text(
              'Para pagamentos via PIX, você receberá um e-mail de confirmação do pagamento \ne os próximos passos para o cadastro.'),
          actions: <Widget>[
            TextButton(
                  style: TextButton.styleFrom(
                backgroundColor:  Color.fromARGB(255, 30, 98, 170),
                foregroundColor: Colors.white, // Cor do texto do botão
              ),
              child: Text('Ok'),
              onPressed: () {
                   _paymentService.startCheckout().catchError((error) {
                        // Handle the error appropriately here
                        print('Error during checkout: $error');
                      });
              },
            ),
          ],
        );
      },
    );
  }
}
