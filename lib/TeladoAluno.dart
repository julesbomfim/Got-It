import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ingleswebsite/admin.dart';
import 'package:ingleswebsite/alunos.dart';
import 'package:ingleswebsite/auth/authentic.dart';
import 'package:ingleswebsite/telaAdmin.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:math' as math;

class TelaDoAluno extends StatefulWidget {
  @override
  _TelaDoAlunoState createState() => _TelaDoAlunoState();
}

class _TelaDoAlunoState extends State<TelaDoAluno> {
  int _selectedIndex = 0;
  AuthService authService = AuthService();

   void _onItemTapped(int index) {
    setState(() {
      if (index == 3) {
        // Logout
        // Implemente aqui a lógica para fazer o logout, como limpar as informações de autenticação e navegar para a tela de login
        // Exemplo: Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundoHome.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Row(
        children: [
          // Sidebar Fixo
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight:
                  Radius.circular(20), // Borda curva no canto superior direito
              bottomRight:
                  Radius.circular(20), // Borda curva no canto inferior direito
            ),
            child: Container(
              width: 70,
              color: Color.fromARGB(255, 216, 215, 215),
              child: ListView(
                children: [
              ListTile(
  leading: Icon(
    _selectedIndex == 0 ? Icons.play_arrow : Icons.play_arrow_outlined,
    color: _selectedIndex == 0 ? Colors.blue : Colors.black,
  ),
  title: Tooltip(
    message: 'Aulas', // Nome a ser exibido ao passar o mouse
  ),
  onTap: () {
    _onItemTapped(0);
  },
  selected: _selectedIndex == 0,
),

                ListTile(
  leading: Icon(
    _selectedIndex == 1 ? Icons.person : Icons.person_outline,
    color: _selectedIndex == 1 ? Colors.blue : Colors.black,
  ),
  title: Tooltip(
    message: 'Atualizar dados', // Nome a ser exibido ao passar o mouse
  ),
  onTap: () {
    _onItemTapped(1);
  },
  selected: _selectedIndex == 1,
),

                  ListTile(
  leading: _selectedIndex == 2 
    ? Icon(Icons.forum, color: Colors.blue) 
    : Icon(Icons.forum_outlined, color: Colors.black),
  onTap: () {
    _onItemTapped(2);
  },
  selected: _selectedIndex == 2,
),

                   ListTile(
  leading: const Icon(
    Icons.logout, // Ícone de logout
    color: Colors.black,
  ),
  onTap: () async {
    _onItemTapped(3); // Logout
    await authService.signOut(context);
  },
)


                ],
              ),
            ),
          ),
          // Espaçador
          VerticalDivider(width: 0),
          // Conteúdo da Página
          Expanded(
            child: _selectedIndex == 0
                ? const VisualizarVideos()
                : _selectedIndex == 1
                        ? AtualizarPage() 
                
                            :  ForumScreen()
          ),
        ],
      ),
    ]));
  }
}





class VisualizarVideos extends StatefulWidget {
  const VisualizarVideos({Key? key}) : super(key: key);

  @override
  _VisualizarVideosState createState() => _VisualizarVideosState();
}

class _VisualizarVideosState extends State<VisualizarVideos> with TickerProviderStateMixin {
  List<Admin> videos = [];
  Alunos? alunoAtual;
  List<bool> watchedVideos = [];
  int? hoveredIndex;
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    loadAlunoProgresso();
    loadVideos();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> loadAlunoProgresso() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final alunoSnapshot = await FirebaseFirestore.instance
          .collection('Alunos')
          .doc(user.uid)
          .get();

      final alunoData = alunoSnapshot.data();
      if (alunoData != null) {
        if (mounted) {
          setState(() {
            alunoAtual = Alunos.fromJson(alunoData);
          });
        }
      }
    }
  }

  Future<void> loadVideos() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Videos').get();

    if (mounted) {
      setState(() {
        videos = querySnapshot.docs
            .map((doc) => Admin.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        watchedVideos = List<bool>.filled(videos.length, false);
        _animationControllers = List.generate(
          videos.length,
          (index) => AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 300),
          ),
        );

        if (alunoAtual != null) {
          for (int i = 0; i < videos.length; i++) {
            if (alunoAtual!.progresso.containsKey('video$i') &&
                alunoAtual!.progresso['video$i'] == 1.0) {
              watchedVideos[i] = true;
            }
          }
        }
      });
    }
  }

  void markVideoAsWatched(int index) async {
    if (mounted) {
      setState(() {
        watchedVideos[index] = true;
      });
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && alunoAtual != null) {
      // Atualizar o progresso localmente
      alunoAtual!.progresso['video$index'] = 1.0;

      // Atualizar o progresso no Firestore
      final alunoDocRef =
          FirebaseFirestore.instance.collection('Alunos').doc(user.uid);
      await alunoDocRef.set(alunoAtual!.toJson(), SetOptions(merge: true));
    }
  }
 Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false;
  }

  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
      WillPopScope(
        onWillPop: _onWillPop,
        child:  LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            // Layout para dispositivos móveis
            return _buildMobileLayout();
          } else {
            // Layout para desktop/notebook
            return _buildDesktopLayout();
          }
        },
      ),
    ));
  }


Widget _buildMobileLayout() {
  final watchedCount = watchedVideos.where((watched) => watched).length;
  final progress = videos.isEmpty ? 0.0 : watchedCount / videos.length.toDouble();
  final progressPercentage = (progress * 100).toStringAsFixed(1);

  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/menu.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      
        Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Aulas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              animation: true,
              percent: progress,
              center: Text(
                'Seu progresso\n$progressPercentage%',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
              circularStrokeCap: CircularStrokeCap.round,
            ),
        
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: videos.isNotEmpty
                    ? ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: MouseRegion(
                              onEnter: (_) {
                                if (mounted) {
                                  setState(() {
                                    hoveredIndex = index;
                                  });
                                  _animationControllers[index].forward();
                                }
                              },
                              onExit: (_) {
                                if (mounted) {
                                  setState(() {
                                    hoveredIndex = null;
                                  });
                                  _animationControllers[index].reverse();
                                }
                              },
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(hoveredIndex == index ? -0.3 : 0),
                                alignment: Alignment.center,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.blue, width: 2),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: AssetImage('assets/menu.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (mounted) {
                                          markVideoAsWatched(index);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerScreenAdmin(
                                                video: video,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                video.titulo,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            InkWell(
                                              onTap: () {
                                                if (mounted) {
                                                  markVideoAsWatched(index);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoPlayerScreenAdmin(
                                                        video: video,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                'assets/play.svg',
                                                color: Colors.blue,
                                                height: 24,
                                                width: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


 Widget _buildDesktopLayout() {
    final watchedCount = watchedVideos.where((watched) => watched).length;
    final progress = videos.isEmpty ? 0.0 : watchedCount / videos.length.toDouble();
    final progressPercentage = (progress * 100).toStringAsFixed(1);
   
    videos.sort((a, b) => a.uploadDate.compareTo(b.uploadDate));
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 230,
            right: 40,
            child: Lottie.network(
              'https://lottie.host/a24f24be-8b8e-47bb-ad13-d46b9033a48c/u2KIQ2AJw2.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50,
            left: 40,
            child: Lottie.network(
              'https://lottie.host/e0498829-c3d1-439f-8f1b-084b2231967f/dDWdL2Rysy.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 24),
              Text(
                'Aulas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 13.0,
                animation: true,
                percent: progress,
                center: Text(
                  'Seu progresso\n$progressPercentage%',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.grey,
                progressColor: Colors.blue,
                circularStrokeCap: CircularStrokeCap.round,
              ),
      //        SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 300),
                  child: videos.isNotEmpty
                      ? ListView.builder(
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              child: MouseRegion(
                                onEnter: (_) {
                                  if (mounted) {
                                    setState(() {
                                      hoveredIndex = index;
                                    });
                                    _animationControllers[index].forward();
                                  }
                                },
                                onExit: (_) {
                                  if (mounted) {
                                    setState(() {
                                      hoveredIndex = null;
                                    });
                                    _animationControllers[index].reverse();
                                  }
                                },
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateX(hoveredIndex == index ? -0.3 : 0),
                                  alignment: Alignment.center,
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.blue, width: 2),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage('assets/menu.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (mounted) {
                                            markVideoAsWatched(index);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoPlayerScreenAdmin(
                                                  video: video,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              // Texto do título
                                              Expanded(
                                                child: Text(
                                                  video.titulo,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              // Ícone de play
                                              InkWell(
                                                onTap: () {
                                                  if (mounted) {
                                                    markVideoAsWatched(index);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoPlayerScreenAdmin(
                                                          video: video,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/play.svg',
                                                  color: Colors.blue,
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              // Adicione mais ícones conforme necessário
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/*
class VisualizarVideos extends StatefulWidget {
  const VisualizarVideos({Key? key}) : super(key: key);

  @override
  _VisualizarVideosState createState() => _VisualizarVideosState();
}

class _VisualizarVideosState extends State<VisualizarVideos> with TickerProviderStateMixin {
  List<Admin> videos = [];
  Alunos? alunoAtual;
  List<bool> watchedVideos = [];
  int? hoveredIndex;
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    loadAlunoProgresso();
    loadVideos();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> loadAlunoProgresso() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final alunoSnapshot = await FirebaseFirestore.instance
          .collection('Alunos')
          .doc(user.uid)
          .get();

      final alunoData = alunoSnapshot.data();
      if (alunoData != null) {
        if (mounted) {
          setState(() {
            alunoAtual = Alunos.fromJson(alunoData);
          });
        }
      }
    }
  }

  Future<void> loadVideos() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Videos').get();

    if (mounted) {
      setState(() {
        videos = querySnapshot.docs
            .map((doc) => Admin.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        watchedVideos = List<bool>.filled(videos.length, false);
        _animationControllers = List.generate(
          videos.length,
          (index) => AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 300),
          ),
        );

        if (alunoAtual != null) {
          for (int i = 0; i < videos.length; i++) {
            if (alunoAtual!.progresso.containsKey('video$i') &&
                alunoAtual!.progresso['video$i'] == 1.0) {
              watchedVideos[i] = true;
            }
          }
        }
      });
    }
  }

  void markVideoAsWatched(int index) async {
    if (mounted) {
      setState(() {
        watchedVideos[index] = true;
      });
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && alunoAtual != null) {
      // Atualizar o progresso localmente
      alunoAtual!.progresso['video$index'] = 1.0;

      // Atualizar o progresso no Firestore
      final alunoDocRef =
          FirebaseFirestore.instance.collection('Alunos').doc(user.uid);
      await alunoDocRef.set(alunoAtual!.toJson(), SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchedCount = watchedVideos.where((watched) => watched).length;
    final progress = videos.isEmpty ? 0.0 : watchedCount / videos.length.toDouble();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 230,
            right: 40,
            child: Lottie.network(
              'https://lottie.host/a24f24be-8b8e-47bb-ad13-d46b9033a48c/u2KIQ2AJw2.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50,
            left: 40,
            child: Lottie.network(
              'https://lottie.host/e0498829-c3d1-439f-8f1b-084b2231967f/dDWdL2Rysy.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 24),
              Text(
                'Aulas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 100, horizontal: 300),
                  child: videos.isNotEmpty
                      ? ListView.builder(
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              child: MouseRegion(
                                onEnter: (_) {
                                  if (mounted) {
                                    setState(() {
                                      hoveredIndex = index;
                                    });
                                    _animationControllers[index].forward();
                                  }
                                },
                                onExit: (_) {
                                  if (mounted) {
                                    setState(() {
                                      hoveredIndex = null;
                                    });
                                    _animationControllers[index].reverse();
                                  }
                                },
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateX(hoveredIndex == index ? -0.3 : 0),
                                  alignment: Alignment.center,
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.blue, width: 2),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage('assets/menu.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (mounted) {
                                            markVideoAsWatched(index);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoPlayerScreenAdmin(
                                                  video: video,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              // Texto do título
                                              Expanded(
                                                child: Text(
                                                  video.titulo,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              // Ícone de play
                                              InkWell(
                                                onTap: () {
                                                  if (mounted) {
                                                    markVideoAsWatched(index);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoPlayerScreenAdmin(
                                                          video: video,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/play.svg',
                                                  color: Colors.blue,
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              // Adicione mais ícones conforme necessário
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/



/*
class VisualizarVideos extends StatefulWidget {
  const VisualizarVideos({Key? key}) : super(key: key);

  @override
  _VisualizarVideosState createState() => _VisualizarVideosState();
}

class _VisualizarVideosState extends State<VisualizarVideos>
    with TickerProviderStateMixin {
  List<Admin> videos = [];
  List<Alunos> alunos = [];
  int? hoveredIndex;
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      videos.length,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );
    loadVideos();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  
  

  Future<void> loadVideos() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Videos').get();

    setState(() {
      videos = querySnapshot.docs
          .map((doc) => Admin.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      _animationControllers = List.generate(
        videos.length,
        (index) => AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 300),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 230,
            right: 40,
            child: Lottie.network(
              'https://lottie.host/a24f24be-8b8e-47bb-ad13-d46b9033a48c/u2KIQ2AJw2.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50,
            left: 40,
            child: Lottie.network(
              'https://lottie.host/e0498829-c3d1-439f-8f1b-084b2231967f/dDWdL2Rysy.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
        
          Column(
            children: [
              SizedBox(height: 24),
              Text(
                'Aulas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 100, horizontal: 300),
                  child: videos.isNotEmpty
                      ? ListView.builder(
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    hoveredIndex = index;
                                  });
                                  _animationControllers[index].forward();
                                },
                                onExit: (_) {
                                  setState(() {
                                    hoveredIndex = null;
                                  });
                                  _animationControllers[index].reverse();
                                },
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateX(hoveredIndex == index ? -0.3 : 0),
                                  alignment: Alignment.center,
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                          color: Colors.blue, width: 2),
                                    ),
                                    child:Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      image: DecorationImage(
        image: AssetImage('assets/menu.png'),
        fit: BoxFit.cover,
      ),
    ),
    child:  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreenAdmin(
                                              video: video,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            // Texto do título
                                            Expanded(
                                              child: Text(
                                                video.titulo,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            // Ícone de play
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayerScreenAdmin(
                                                      video: video,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                'assets/play.svg',
                                                color: Colors.blue,
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                            // Adicione mais ícones conforme necessário
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                ),
              ),
            
            ],
          ),
        ],
      ),
    );
  }
    }*/



/////updatedados

class AtualizarPage extends StatefulWidget {
  @override
  _AtualizarPageState createState() => _AtualizarPageState();
}

class _AtualizarPageState extends State<AtualizarPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _passwordsMatch = true;
  bool _isPasswordVisible = false;

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Um e-mail de redefinição de senha foi enviado para $email"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao enviar e-mail de redefinição de senha: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
 Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false;
  }

     @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: 
      WillPopScope(
        onWillPop: _onWillPop,
        child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            // Layout para dispositivos móveis
            return _buildMobileLayout();
          } else {
            // Layout para desktop/notebook
            return _buildDesktopLayout();
          }
        },
      ),
    ));
  }
 Widget _buildMobileLayout() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Atualizar cadastro',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                _buildTextField(
                  controller: nomeController,
                  labelText: 'Nome',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (nomeController.text.isNotEmpty) {
                      try {
                        User? user = _auth.currentUser;

                        if (user != null) {
                          await _firestore
                              .collection('Alunos')
                              .doc(user.uid)
                              .update({
                            'nome': nomeController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nome atualizado com sucesso.'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      } catch (error) {
                        print('Erro ao atualizar o nome: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao atualizar o nome: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, insira um nome.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Atualizar',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color.fromARGB(255, 30, 98, 170)),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  labelText: 'E-mail',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    resetPassword(emailController.text, context);
                  },
                  child: Text(
                    'Enviar email de redefinição de senha',
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
    );
  }
  
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Atualizar cadastro',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 120),
                _buildTextField(
                  controller: nomeController,
                  labelText: 'Nome',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (nomeController.text.isNotEmpty) {
                      try {
                        User? user = _auth.currentUser;

                        if (user != null) {
                          await _firestore
                              .collection('Alunos')
                              .doc(user.uid)
                              .update({
                            'nome': nomeController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nome atualizado com sucesso.'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      } catch (error) {
                        print('Erro ao atualizar o nome: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao atualizar o nome: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, insira um nome.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Atualizar',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color.fromARGB(255, 30, 98, 170)),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  labelText: 'E-mail',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    resetPassword(emailController.text, context);
                  },
                  child: Text(
                    'Enviar email de redefinição de senha',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

/////////////////////////////
///
///
///
///
///import 'dart:async';import 'package:flutter/material.dart';
///
///
class Comment {
  final String id;
  final String userName;
  final String text;
  final List<Comment> replies;
  bool showReplyField; // Nova propriedade para controlar a exibição do campo de resposta

  Comment({
    required this.id,
    required this.userName,
    required this.text,
    this.replies = const [],
    this.showReplyField = false, // Inicialmente, o campo de resposta está oculto
  });
}

class VideoPlayerScreenAdmin extends StatefulWidget {
  final Admin video;

  const VideoPlayerScreenAdmin({required this.video});

  @override
  _VideoPlayerScreenAdminState createState() => _VideoPlayerScreenAdminState();
}

class _VideoPlayerScreenAdminState extends State<VideoPlayerScreenAdmin> {
  late Future<ChewieController> _chewieControllerFuture;
  TextEditingController commentController = TextEditingController();
  bool isLiked = false;
  int likesCount = 0;
  List<Comment> comments = [];
  bool hasComments = false;
  late String currentUserName;
  bool _showLottie = true;
   bool showReplyField = false;
Timer? _timer;
late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _chewieControllerFuture = _initializePlayer();
    loadUserName();
    loadComments();

    // Define um temporizador para ocultar o Lottie após 5 segundos
    _timer = Timer(Duration(seconds: 7), () {
    if (mounted) { // Verifique se o widget ainda está montado antes de chamar setState()
      setState(() {
        _showLottie = false;
      });
    }
  });
  }
  

 void _updateStateSafely() {
    // Verificar se o widget ainda está montado antes de chamar setState
    if (mounted) {
      setState(() {
        // Atualizar o estado aqui
      });
    }
  }
  Future<ChewieController> _initializePlayer() async {
    final fileNames = widget.video.docsVideos;
    final videoUrl = await FirebaseStorage.instance
        .ref('arquivos/${widget.video.id}/$fileNames')
        .getDownloadURL();

    final videoPlayerController = VideoPlayerController.network(videoUrl);
    await videoPlayerController.initialize();
    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      allowMuting: true,
      showControlsOnInitialize: false,
      allowPlaybackSpeedChanging: false,
      allowFullScreen: true,
    );
    return chewieController;
  }

  Future<void> downloadFile(String userId, String fileName) async {
    try {
      String downloadURL = await FirebaseStorage.instance
          .ref('arquivos/$userId/$fileName')
          .getDownloadURL();

      final html.AnchorElement anchor = html.AnchorElement(href: downloadURL)
        ..target = 'webbrowser_download';

      html.document.body!.children.add(anchor);
      anchor.click();

      html.document.body!.children.removeLast();

      print('File $fileName downloaded successfully for user $userId!');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserName = user.displayName ?? 'Seu comentário';
      });
    } else {
      setState(() {
        currentUserName = 'Seu comentário';
      });
    }
  }


////
///
////
////
////
///
Future<void> loadComments() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('comments')
      .where('videoId', isEqualTo: widget.video.id)
      .get();
  List<Comment> loadedComments = [];
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    // Verifica se o campo 'userId' existe no documento antes de acessá-lo
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('userId')) {
      String userId = doc.get('userId');
      DocumentSnapshot? userSnapshot = await FirebaseFirestore.instance
          .collection('Alunos')
          .doc(userId)
          .get();
      // Verifica se o campo 'nome' existe no documento do usuário antes de acessá-lo
      if (userSnapshot != null) {
        String userName = userSnapshot.get('nome');
        List<Comment> replies = await loadReplies(doc.reference);
        loadedComments.add(
          Comment(
            id: doc.id,
            text: doc.get('text'),
            userName: userName,
            replies: replies,
          ),
        );
      }
    }
  }
  setState(() {
    comments = loadedComments;
    hasComments = comments.isNotEmpty;
  });
}



  Future<List<Comment>> loadReplies(DocumentReference commentRef) async {
    QuerySnapshot replySnapshot = await commentRef.collection('replies').get();
    List<Comment> replies = [];
    for (QueryDocumentSnapshot replyDoc in replySnapshot.docs) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Alunos')
          .doc(replyDoc.get('userId'))
          .get();
      String userName = userSnapshot.get('nome');
      replies.add(
        Comment(
          id: replyDoc.id,
          text: replyDoc.get('replyText'),
          userName: userName,
        ),
      );
    }
    return replies;
  }

  void saveComment() {
    String commentText = commentController.text.trim();
    if (commentText.isNotEmpty) {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      String currentUserName =
          this.currentUserName; // Obtém o nome de usuário atual
      // if (currentUserName == null) {
      //   // Se o nome de usuário ainda não foi carregado, use "Seu comentário"
      //   currentUserName = 'Seu comentário';
      // }
      Comment newComment = Comment(
        id: UniqueKey().toString(),
        userName:
            currentUserName, // Usa o nome de usuário atual ao criar o comentário
        text: commentText,
      );

      setState(() {
        // Adiciona o novo comentário à lista local imediatamente
        comments.insert(0, newComment);
      });

      FirebaseFirestore.instance.collection('comments').add({
        'text': commentText,
        'videoId': widget.video.id,
        'userId': currentUserId,
        'userName': currentUserName,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((docRef) {
        // Limpa o campo de texto após salvar o comentário
        commentController.clear();
      }).catchError((error) {
        print('Erro ao salvar o comentário: $error');
      });
    }
  }

  void saveReply(String commentId, String replyText) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .add({
      'replyText': replyText,
      'userId': currentUserId,
      'userName': currentUserName,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((docRef) {
      // Após adicionar a resposta, adicione-a à lista de respostas local
      Comment reply = Comment(
        id: docRef.id,
        text: replyText,
        userName: currentUserName,
      );
      // Encontre o comentário correspondente na lista de comentários
      for (int i = 0; i < comments.length; i++) {
        if (comments[i].id == commentId) {
          // Crie uma nova lista de respostas com a nova resposta adicionada
          List<Comment> updatedReplies = List.from(comments[i].replies)
            ..add(reply);
          // Crie um novo objeto Comment com as respostas atualizadas
          Comment updatedComment = Comment(
            id: comments[i].id,
            userName: comments[i].userName,
            text: comments[i].text,
            replies: updatedReplies,
          );
          // Atualize o comentário correspondente na lista de comentários
          setState(() {
            comments[i] = updatedComment;
          });
          break;
        }
      }
    }).catchError((error) {
      print('Erro ao salvar a resposta: $error');
    });
  }
  
  Widget buildComment(
  Comment comment,
  bool isParentComment,
  String currentUserName,
) {
  TextEditingController replyController = TextEditingController();

  return Card(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    elevation: isParentComment ? 2.0 : 4.0,
    shape: isParentComment
        ? RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          )
        : null,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            leading: Icon(Icons.comment, color: Colors.blue),
            title: Text(
              comment.userName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              comment.text,
              style: TextStyle(
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
          if (comment.replies.isNotEmpty)
            Column(
              children: comment.replies
                  .map((reply) => buildComment(reply, false, currentUserName))
                  .toList(),
            ),
          SizedBox(height: 8),
          if (isParentComment && comment.showReplyField) // Mostra o campo de resposta se `showReplyField` for verdadeiro
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: replyController,
                      decoration: InputDecoration(
                        hintText: 'Digite sua resposta...',
                      ),
                    ),
                  ),
                   IconButton(
          icon: Icon(
            Icons.cancel,
            color: Colors.red, // Cor do ícone de cancelar
          ),
          onPressed: () {
            // Lógica para cancelar a resposta
            setState(() {
              comment.showReplyField = false; // Oculta o campo de resposta
            });
            replyController.clear();
          },
        ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      // Lógica para salvar a resposta
                      String replyText = replyController.text.trim();
                      if (replyText.isNotEmpty) {
                        saveReply(
                          comment.id,
                          replyText,
                        );
                        replyController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          if (isParentComment && !comment.showReplyField) // Mostra o botão "Responder" se `showReplyField` for falso
            TextButton(
              onPressed: () {
                setState(() {
                  comment.showReplyField = true; // Alterna o estado `showReplyField` ao clicar no botão "Responder"
                });
              },
              child: Text(
                'Responder',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    ),
  );
}

void _launchURL(String? url2) {
  if (url2 != null) {
    // Gerar um identificador único para cada nova aba
    final String uniqueTabId = '${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(999999)}';
    // Abrir a URL em uma nova aba com o identificador único
    html.window.open(url2, uniqueTabId);
  }
}

void _launchURL2(String? url2) {
  if (url2 != null) {
    // Gerar um identificador único para cada nova aba
    final String uniqueTabId = '${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(999999)}';
    // Abrir a URL em uma nova aba com o identificador único
    html.window.open(url2, uniqueTabId);
  }
}

void _launchURL3(String? url3) {
  if (url3 != null) {
    // Gerar um identificador único para cada nova aba
    final String uniqueTabId = '${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(999999)}';
    // Abrir a URL em uma nova aba com o identificador único
    html.window.open(url3, uniqueTabId);
  }
}
Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false;
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      WillPopScope(
        onWillPop: _onWillPop,
        child:  LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            // Layout para dispositivos móveis
            return _buildMobileLayout();
          } else {
            // Layout para desktop/notebook
            return _buildDesktopLayout();
          }
        },
      ),
    ));
  }


Widget _buildMobileLayout() {
  return Scaffold(
    body: Stack( children: [ Container(
           
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
    
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           
          FutureBuilder<ChewieController>(
            future: _chewieControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Visibility(
                  visible: _showLottie,
                  child: 
                   Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox( height: 250),
        Center( child: 
           Lottie.network(
                    'https://lottie.host/beaac985-9aaa-465b-b2ac-44f2c4cec3a6/LZoHljxBcc.json',
                    width: 250,
                    height: 250,
                  
                    fit: BoxFit.cover,
                  ),)
         ]) );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final chewieController = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    child: Chewie(controller: chewieController),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.titulo,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.video.descricao ?? 'Descrição não disponível',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                'Materiais',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                downloadFile(
                                    widget.video.id, widget.video.docsExercicios);
                              },
                              leading: Icon(
                                Icons.download,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                          Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.2),
                      child: Text(
                        'Links para estudos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                   

Padding(
  padding: EdgeInsets.symmetric(horizontal: 1),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'Link 1: ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: widget.video.material ?? '',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(widget.video.material);
                },
            ),
          ],
        ),
      ),
    ],
  ),
),

                    SizedBox(height: 20),
                   

Padding(
  padding: EdgeInsets.symmetric(horizontal: 1),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'Link 2 : ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: widget.video.material2 ?? '',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL2(widget.video.material2);
                },
            ),
          ],
        ),
      ),
    ],
  ),
),
                SizedBox(height: 20),
                   

Padding(
  padding: EdgeInsets.symmetric(horizontal: 1),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'Link 3 : ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: widget.video.material3 ?? '',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL3(widget.video.material3);
                },
            ),
          ],
        ),
      ),
    ],
  ),
),
SizedBox(height: 20,),
 
                        Text(
                          'Comentários',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Digite seu comentário...',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  saveComment();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            onSubmitted: (value) {
                              saveComment();
                            },
                          ),
                        ),
                      
                        SizedBox(height: 15),
                        hasComments
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return buildComment(
                                      comments[index], true, currentUserName);
                                },
                              )
                            : Text(
                                'Ainda não existem comentários sobre este vídeo.',
                                style: TextStyle(fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  ]));
}

  


  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menu.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FutureBuilder<ChewieController>(
            future: _chewieControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
             
                return Visibility(
                  visible: _showLottie,
                  child: Lottie.network(
                    'https://lottie.host/beaac985-9aaa-465b-b2ac-44f2c4cec3a6/LZoHljxBcc.json',
                    width: 350,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final chewieController = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 500,
                      child: Chewie(controller: chewieController),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        widget.video.titulo,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        widget.video.descricao ?? 'Descrição não disponível',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: Card(
                          child: ListTile(
                            title: Text(
                              'Materiais',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              downloadFile(
                                  widget.video.id, widget.video.docsExercicios);
                            },
                            leading: Icon(
                              Icons.download,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                       SizedBox(height: 20),
                Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Links para estudos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                   

Padding(
  padding: EdgeInsets.symmetric(horizontal: 50),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'Link 1: ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: widget.video.material ?? '',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(widget.video.material);
                },
            ),
          ],
        ),
      ),
    ],
  ),
),

                    SizedBox(height: 20),
                   

Padding(
  padding: EdgeInsets.symmetric(horizontal: 50),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'Link 2 : ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: widget.video.material2 ?? '',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL2(widget.video.material2);
                },
            ),
          ],
        ),
      ),
    ],
  ),
),

                    SizedBox(height: 20),
                   

Padding(
  padding: EdgeInsets.symmetric(horizontal: 50),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: 'Link 3 : ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: widget.video.material3 ?? '',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL3(widget.video.material3);
                },
            ),
          ],
        ),
      ),
    ],
  ),
),

                     SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Comentários',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.6, // Altera o tamanho do TextField
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Digite seu comentário...',
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                saveComment();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue), // Cor da borda azul
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          onSubmitted: (value) {
              saveComment(); // Chama _replyComment() quando o Enter é pressionado no teclado
            },
                        ),
                      ),
                    ),
                   
                    SizedBox(height: 8),
                    hasComments
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 200),
                            alignment: Alignment
                                .centerLeft, // Alinha a lista de comentários à esquerda da tela
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return buildComment(
                                    comments[index], true, currentUserName);
                              },
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'Ainda não existem comentários sobre este vídeo.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieControllerFuture.then((chewieController) {
      chewieController.dispose();
    });
      _timer?.cancel();
  }
}

/////////////


class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<Forum> comments = []; // Lista de comentários
  Map<String, List<Forum>> repliesMap = {};

  TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController(); // Controlador para o campo de resposta

  User? currentUser; // Armazena o usuário autenticado atualmente

  // Mapa para rastrear os campos de resposta para cada comentário
  Map<String, bool> replyFields = {};
  final List<FAQ> faqs = [
    FAQ(
      question: 'Há material didático incluso no curso?',
      answer: 'Sim, todo o material didático necessário para o curso está incluso no valor do curso. Os alunos receberão acesso a exercícios, apostilas, e recursos online.',
    ),
    FAQ(
      question: 'Há suporte técnico para problemas com a plataforma online?',
      answer: 'Sim, nossa equipe de suporte técnico está disponível para ajudar com qualquer problema relacionado à plataforma online. Você pode entrar em contato através de chat, e-mail ou telefone.',
    ),
    FAQ(
      question: 'Posso acessar o material do curso de qualquer dispositivo?',
      answer: 'Sim, nossa plataforma online é acessível de qualquer dispositivo com acesso à internet, incluindo computadores, tablets e smartphones.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Obtém o usuário autenticado atualmente
    currentUser = FirebaseAuth.instance.currentUser;
    // Carrega os comentários quando o widget é iniciado
    _loadComments();
  }

 Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: 
      WillPopScope(
        onWillPop: _onWillPop,
        child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            // Layout para dispositivos móveis
            return _buildMobileLayout();
          } else {
            // Layout para desktop/notebook
            return _buildDesktopLayout();
          }
        },
      ),
    ));
  }

 Widget _buildMobileLayout() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/menu.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Perguntas e dúvidas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Text(
                  'Perguntas frequentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              faqs[index].question,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                faqs[index].answer,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Text(
                  'Tire suas dúvidas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Digite sua dúvida...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        _saveComment();
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    _saveComment();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blue, width: 2),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.comment, size: 24, color: Colors.blue),
                                    SizedBox(width: 10),
                                    FutureBuilder(
                                      future: _getUserName(comments[index].userId),
                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Text('Carregando...');
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Erro: ${snapshot.error}');
                                        }
                                        return Text(
                                          snapshot.data ?? 'Usuário Anônimo',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 60,
                                  child: Text(
                                    comments[index].text,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (repliesMap.containsKey(comments[index].id))
                                  ...repliesMap[comments[index].id]!
                                      .map((reply) => _buildReplyCard(reply))
                                      .toList(),
                                Visibility(
                                  visible: !(replyFields[comments[index].id] ?? false),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          replyFields[comments[index].id] = !(replyFields[comments[index].id] ?? false);
                                        });
                                      },
                                      child: Text(
                                        'Responder',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: replyFields[comments[index].id] ?? false,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: replyController,
                                            decoration: InputDecoration(
                                              hintText: 'Responda aqui...',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                ),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                ),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.cancel, color: Colors.red),
                                                    onPressed: () {
                                                      setState(() {
                                                        replyFields[comments[index].id] = false;
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.send, color: Colors.blue),
                                                    onPressed: () {
                                                      _replyComment(comments[index]);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onSubmitted: (value) {
                                              _replyComment(comments[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildDesktopLayout() {
    return Scaffold(
    
      body: SingleChildScrollView(
        child:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menu.png'),
            fit: BoxFit.cover,
          ),
        ) , child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Center( child:  Text(
                'Perguntas e dúvidas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 70,),
            Center( child:  Text(
                'Perguntas frequentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 20),
              child:
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.blue, width: 2.0), // Adiciona uma borda azul
                  ),
                  child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          
                  child: ExpansionTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        faqs[index].question,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          faqs[index].answer,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),),
           Center( child:  Text(
                'Tire suas dúvidas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 20),
  child: TextField(
    controller: commentController,
    decoration: InputDecoration(
      hintText: 'Digite sua dúvida...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: IconButton(
        icon: Icon(Icons.send, color: Colors.blue),
        onPressed: () {
          _saveComment();
        },
      ),
    ),
    onSubmitted: (value) {
      _saveComment(); // Chama _saveComment() quando o Enter é pressionado no teclado
    },
  ),
),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 20),
              child:
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue, width: 2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.comment, size: 30, color: Colors.blue,),
                                SizedBox(width: 10),
                                FutureBuilder(
                                  future: _getUserName(comments[index].userId),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Carregando...');
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Erro: ${snapshot.error}');
                                    }
                                    return Text(
                                      snapshot.data ?? 'Usuário Anônimo',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                             Container(
                              height: 60, // Altura fixa para o card
                              child: Expanded(
                                child: Text(
                                comments[index].text,
                                 maxLines: 3, 
          overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),),
                            // Exibe o campo de texto de resposta apenas para o comentário correspondente
                            if (repliesMap.containsKey(comments[index].id))
                              ...repliesMap[comments[index].id]!
                                  .map((reply) => _buildReplyCard(reply))
                                  .toList(),
                            // Botão "Responder" após as respostas
                            Visibility(
                              visible: !(replyFields[comments[index].id] ?? false),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      replyFields[comments[index].id] = !(replyFields[comments[index].id] ?? false);
                                    });
                                  },
                                  child: Text('Responder', style: TextStyle(color: Colors.blue),),
                                ),
                              ),
                            ),
                           Visibility(
  visible: replyFields[comments[index].id] ?? false,
  child: Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: replyController,
            decoration: InputDecoration(
              hintText: 'Responda aqui...',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        replyFields[comments[index].id] = false;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      _replyComment(comments[index]);
                    },
                  ),
                ],
              ),
            ),
            onSubmitted: (value) {
              _replyComment(comments[index]); // Chama _replyComment() quando o Enter é pressionado no teclado
            },
          ),
        ),
      ],
    ),
  ),
),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
         ) ],
        ),
      ),
     ) );
  }





Widget _buildReplyCard(Forum reply) {
  return Container(
    height: 150, // Altura fixa para os cards de resposta
    child: Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.comment, size: 20, color: Colors.blue), // Ícone de comentário
              SizedBox(width: 8), // Espaçamento entre o ícone e o nome
              Flexible( // Substituído o Expanded por Flexible
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _getUserName(reply.userId),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Carregando...', style: TextStyle(fontSize: 12));
                        }
                        if (snapshot.hasError) {
                          return Text('Erro: ${snapshot.error}', style: TextStyle(fontSize: 12));
                        }
                        return Text(
                          snapshot.data ?? 'Usuário Anônimo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      reply.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  // Método para carregar os comentários do Firestore
  void _loadComments() {
    FirebaseFirestore.instance.collection('Forum').get().then((querySnapshot) {
      setState(() {
        comments = querySnapshot.docs.map((doc) => Forum(
          id: doc.id, // Adicionando o id do documento
          text: doc['text'],
          userId: doc['userId'],
        )).toList();
        // Inicializa o mapa de campos de resposta para cada comentário
        comments.forEach((comment) {
          replyFields[comment.id] = false;
        });
      });

      // Carregar respostas
      _loadReplies();
    }).catchError((error) {
      print('Erro ao carregar comentários: $error');
    });
  }

  // Método para carregar as respostas dos comentários do Firestore
  void _loadReplies() {
    comments.forEach((comment) {
      FirebaseFirestore.instance.collection('Forum').doc(comment.id).collection('Replies').get().then((querySnapshot) {
        setState(() {
          repliesMap[comment.id] = querySnapshot.docs.map((doc) => Forum(
            id: doc.id,
            text: doc['text'],
            userId: doc['userId'],
          )).toList();
        });
      }).catchError((error) {
        print('Erro ao carregar respostas: $error');
      });
    });
  }

  // Método para obter o nome do aluno com base no ID do usuário
  Future<String> _getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Alunos').doc(userId).get();
    return userSnapshot['nome'];
  }

  // Método para salvar um novo comentário
  void _saveComment() {
    String commentText = commentController.text.trim();
    if (commentText.isNotEmpty) {
      String currentUserId = currentUser?.uid ?? 'Anonymous';
      FirebaseFirestore.instance.collection('Forum').add({
        'text': commentText,
        'userId': currentUserId,
      }).then((_) {
        // Limpa o campo de texto após salvar o comentário
        commentController.clear();
        // Recarrega os comentários após adicionar um novo
        _loadComments();
      }).catchError((error) {
        print('Erro ao salvar o comentário: $error');
      });
    }
  }

  // Método para responder a um comentário
  void _replyComment(Forum comment) {
    String replyText = replyController.text.trim();
    if (replyText.isNotEmpty) {
      String currentUserId = currentUser?.uid ?? 'Anonymous';
      FirebaseFirestore.instance.collection('Forum').doc(comment.id).collection('Replies').add({
        'text': replyText,
        'userId': currentUserId,
        'timestamp': DateTime.now(),
      }).then((_) {
        // Limpa o campo de texto após enviar a resposta
        replyController.clear();
        // Recarrega os comentários após adicionar uma nova resposta
        _loadComments();
      }).catchError((error) {
        print('Erro ao responder ao comentário: $error');
      });
    }
  }
}

// Classe para representar um comentário
class Forum {
  final String id; // Adicionando o id do documento
  final String text;
  final String userId;

  Forum({
    required this.id, // Adicionando o id do documento
    required this.text,
    required this.userId,
  });
}

class FAQ {
  final String question;
  final String answer;

  FAQ({
    required this.question,
    required this.answer,
  });
}
