// import 'package:flutter/material.dart';

// class PrimaryPage extends StatefulWidget {
//   @override
//   _PrimaryPageState createState() => _PrimaryPageState();
// }

// class _PrimaryPageState extends State<PrimaryPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     );

//     _animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(_controller);

//     _controller.repeat(reverse: true);

//     // Adiciona um atraso simulando um processo de carregamento
//     Future.delayed(const Duration(seconds: 6), () {
//       // Navega para a próxima tela após o atraso
//       Navigator.pushNamedAndRemoveUntil(
//           context, '/home', (Route<dynamic> route) => false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Imagem de fundo
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/menu.png'), // Imagem de fundo
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Imagem sobreposta com animação
//           Center(
//             child: AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: _animation.value, // Ângulo de rotação conforme a animação
//                   child: Container(
//                     width: 400, // Largura da imagem sobreposta
//                     height: 400, // Altura da imagem sobreposta
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/primaryPage.png'), // Caminho da outra imagem
//                         fit: BoxFit.contain, // Ajuste da imagem
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
// import 'package:flutter/material.dart';

// class PrimaryPage extends StatefulWidget {
//   @override
//   _PrimaryPageState createState() => _PrimaryPageState();
// }

// class _PrimaryPageState extends State<PrimaryPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     );

//     _animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(_controller);

//     _controller.repeat(reverse: true);

//     // Adiciona um atraso simulando um processo de carregamento
//     Future.delayed(const Duration(seconds: 6), () {
//       // Navega para a próxima tela após o atraso
//       Navigator.pushNamedAndRemoveUntil(
//           context, '/home', (Route<dynamic> route) => false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Imagem de fundo
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/menu.png'), // Imagem de fundo
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Imagens lado a lado com uma delas animada
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Imagem estática
//                 Container(
//                   width: 300, // Largura da primeira imagem
//                   height: 300, // Altura da primeira imagem
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/primaryPage.png'), // Caminho da imagem estática
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10), // Ajuste o espaçamento conforme necessário
//                 // Imagem animada
//                 AnimatedBuilder(
//                   animation: _animation,
//                   builder: (context, child) {
//                     return Transform.rotate(
//                       angle: _animation.value, // Ângulo de rotação conforme a animação
//                       child: Container(
//                         width: 100, // Largura da segunda imagem
//                         height: 100, // Altura da segunda imagem
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage('assets/check.png'), // Caminho da outra imagem
//                             fit: BoxFit.contain, // Ajuste da imagem
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'dart:math'; // Importa o pacote math

class PrimaryPage extends StatefulWidget {
  @override
  _PrimaryPageState createState() => _PrimaryPageState();
}

class _PrimaryPageState extends State<PrimaryPage>
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

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _controller.repeat(reverse: false);

    // Adiciona um atraso simulando um processo de carregamento
    Future.delayed(const Duration(seconds: 6), () {
      // Navega para a próxima tela após o atraso
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'), // Imagem de fundo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagem estática
                Container(
                  width: 200, // Largura da primeira imagem
                  height: 300, // Altura da primeira imagem
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/primaryPage.png'), // Caminho da imagem estática
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Imagem animada
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animation.value, // Ângulo de rotação conforme a animação
                          child: Container(
                            width: 50, // Largura da segunda imagem
                            height: 50, // Altura da segunda imagem
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/check.png'), // Caminho da outra imagem
                                fit: BoxFit.contain, // Ajuste da imagem
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
