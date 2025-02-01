import 'package:flutter/material.dart';
import 'package:ingleswebsite/TeladoAluno.dart';
import 'package:ingleswebsite/admin.dart';
import 'package:ingleswebsite/telaAdmin.dart';
import 'package:ingleswebsite/uploadVideos.dart';

import 'package:lottie/lottie.dart';

class LoandingAdmin extends StatefulWidget {
  @override
  _LoandingAdminState createState() => _LoandingAdminState();
}

class _LoandingAdminState extends State<LoandingAdmin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.repeat(reverse: true);

    // Adiciona um atraso simulando um processo de carregamento
    Future.delayed(const Duration(seconds: 7), () {
      // Navega para a próxima tela após o atraso
      Navigator.pushNamedAndRemoveUntil(
          context, '/telaAdmin', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 2400),
                child: Container(
                  width: 2000,
                  height: 2000,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/menu.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: FadeTransition(
                      opacity: _animation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network(
                              "https://lottie.host/cafdaa3f-7f70-422c-bc17-3f2127ad1006/ViUtZ4i8Y1.json",
                              height: 350,
                              width: 350),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
