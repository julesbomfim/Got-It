import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ingleswebsite/TeladoAluno.dart';
import 'package:ingleswebsite/alunos.dart';

import 'package:ingleswebsite/admin.dart';
import 'package:ingleswebsite/telaAdmin.dart';
import 'package:ingleswebsite/visualVideos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createAccount({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      // Verificar se o endereço de e-mail já está em uso
      final userCheck = await _auth.fetchSignInMethodsForEmail(email);
      if (userCheck.isNotEmpty) {
        print('O endereço de e-mail já está em uso.');
        return false;
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        final firestore = FirebaseFirestore.instance;
        await FirebaseFirestore.instance.collection('Alunos').doc(uid).set({
          "nome": nome,
          "email": email,
          "Senha": senha,
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao criar conta: $e');
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", userCredential.user!.uid);
        print(userCredential.user!.uid);
        Get.to(() => TelaDoAluno());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao fazer login: $e');
      return false;
    }
  }

  Future resetPassword(BuildContext context) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
  }

  Future<void> signOut(BuildContext context) async {
  // Exibe a caixa de diálogo de confirmação
  bool confirmSignOut = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar saída'),
        content: Text('Você tem certeza que deseja sair?'),
        actions: <Widget>[
         
          ElevatedButton(
            child: Text('Sair',  style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop(true); // Retorna verdadeiro para confirmar
            },
            style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 30, 98, 170)),
      ),
          ),
           ElevatedButton(
            child: Text('Cancelar',  style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop(false); // Retorna falso para cancelar
            },
            style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 255, 255, 255)),
      ),
          ),
        ],
      );
    },
  );

  // Verifica a escolha do usuário
  if (confirmSignOut == true) {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (Route<dynamic> route) => false,
    );
  }
}

  Future addUser(Admin user) async {
    final docUsua = await FirebaseFirestore.instance.collection('Videos').doc();

    user.id = docUsua.id;

    await docUsua.set(user.toJson());
  }

  Future deleteUser(String id) async {
    final docUsua =
        await FirebaseFirestore.instance.collection("Videos").doc(id);
    await docUsua.delete();
  }

  Future updateUser(Admin user) async {
    final docUsua =
        await FirebaseFirestore.instance.collection("Videos").doc(user.id);
    await docUsua.update(user.toJson());
  }

  Future addUser2(Alunos user) async {
    final docUsua = await FirebaseFirestore.instance.collection('Alunos').doc();

    user.id = docUsua.id;

    await docUsua.set(user.toJson());
  }

  Future<bool> updateAlunoAuth({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
        await user.updatePassword(password);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar email/senha do aluno na autenticação: $e');
      return false;
    }
  }

  Future<bool> updateAlunoData(
      {required String alunoId,
      required String nome,
      required String email,
      required String senha,
      required String confirmarSenha}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Alunos')
          .doc(alunoId)
          .update({
        'nome': nome,
        'email': email,
        'Senha': senha,
        'confirmarSenha': confirmarSenha
      });
      return true;
    } catch (e) {
      print('Erro ao atualizar dados do aluno no Firestore: $e');
      return false;
    }
  }
}

