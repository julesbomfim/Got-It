import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ingleswebsite/TeladoAluno.dart';
import 'package:ingleswebsite/homePage.dart';
import 'package:ingleswebsite/homePage2.dart';
import 'package:ingleswebsite/homePageMAIN.dart';
import 'package:ingleswebsite/loandingAdminPrincipal.dart';
import 'package:ingleswebsite/loandingAlunoPrincipal.dart';
import 'package:ingleswebsite/loginPage.dart';
import 'package:ingleswebsite/pagamento.dart';
import 'package:ingleswebsite/primaryPage.dart';
import 'package:ingleswebsite/registrar.dart';
import 'package:ingleswebsite/telaAdmin.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyACaCem1uR2k8gLFptPoiGpG6JI4JB5bHg",
          authDomain: "ingles-ac531.firebaseapp.com",
          projectId: "ingles-ac531",
          storageBucket: "ingles-ac531.appspot.com",
          messagingSenderId: "840863626445",
          appId: "1:840863626445:web:057f8ff6c7acf6d6742584"));

 setUrlStrategy(PathUrlStrategy());
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Got It',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        
        '/primary': (context)=> PrimaryPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => homePageMAIN(),
        '/homePage': (context) => HomePage(),
        '/homePage2': (context) => HomePage2(),
        '/telaAdmin': (context) => TelaAdmin(),
        '/telaAluno': (context) => TelaDoAluno(),
        '/login': (context) => LoginPage(),
        '/loandingAluno': (context) => LoandingAluno(),
        '/loandingAdmin': (context) => LoandingAdmin(),
        '/atualizarDados': (context) => AtualizarPage(),
        '/meusAlunos': (context) => MeusAlunos(),
        '/aulas': (context) => VisualizarVideosAdmin(),
        '/pagamento': (context) => PaymentPage(),
        
     
        
        
      },
      initialRoute: '/primary',
      
    );
  }
}
