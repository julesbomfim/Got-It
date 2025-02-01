import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final ScrollController _scrollController = ScrollController();
  List<double> _sectionPositions = [];
    int _selectedDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
    _calculateSectionPositions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double currentPosition = _scrollController.position.pixels;
    int newIndex = _calculateSelectedButtonIndex(currentPosition);
    if (_selectedDrawerIndex != newIndex) {
      setState(() {
        _selectedDrawerIndex = newIndex;
      });
    }
  }

  int _calculateSelectedButtonIndex(double currentPosition) {
    int selectedIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < _sectionPositions.length; i++) {
      double distance = (_sectionPositions[i] - currentPosition).abs();
      if (distance < minDistance) {
        selectedIndex = i;
        minDistance = distance;
      }
    }

    return selectedIndex;
  }

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      title: Text('Got It'),
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/menu.png', // Substitua pelo caminho da sua imagem de fundo da AppBar
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
    drawer: Drawer(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/menu.png', // Substitua pelo caminho da sua imagem de fundo do Drawer
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/identidade.png', // Substitua pelo caminho da sua imagem para o DrawerHeader
                  fit: BoxFit.cover,
                ),
              ),
              buildNavDrawerItem(0, 'Home'),
              buildNavDrawerItem(1, 'Sobre o Curso'),
              buildNavDrawerItem(2, 'Professor'),
              buildNavDrawerItem(3, 'Vídeo de Apresentação'),
              buildNavDrawerItem(4, 'Contato'),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Login'),
                onTap: _onLoginButtonPressed,
              ),
            ],
          ),
        ],
      ),
    ),
    body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              BannerSection((double position) => _scrollToSection(_sectionPositions[0])),
              CourseInformationSection(),
              TeacherInformationSection(),
              VideoPresentationSection(),
              ContactInformationSection(),
              Container(
                alignment: Alignment.center,
                color: Colors.grey[300],
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '© 2024 GotIt. Todos os direitos reservados.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  void _onLoginButtonPressed() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => true);
  }

    Widget buildNavDrawerItem(int index, String text) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: _selectedDrawerIndex == index ? Colors.blue : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        if (index != -1) {
          setState(() {
            _selectedDrawerIndex = index;
          });
          _scrollToSection(_sectionPositions[index]);
          Navigator.pop(context); // Close the drawer
        } else {
          _onLoginButtonPressed(); // Chama a função para redirecionar para a página de login
        }
      },
    );
  }


   

  void _calculateSectionPositions() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _sectionPositions.clear();
      for (int i = 0; i <= 4; i++) {
        RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          double position = renderBox
              .localToGlobal(Offset(0, 400 * i.toDouble()),
                  ancestor: context.findRenderObject())
              .dy;
          _sectionPositions.add(position);
        }
      }
    });
  }
}

class CourseInformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu.png'), // Adicione o caminho da sua imagem
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 400, // Aumentando a altura da seção
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Margem externa
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/curso.png'),
            fit: BoxFit.cover,
          ),
          color: const Color.fromARGB(255, 127, 129, 129),
          borderRadius: BorderRadius.circular(20), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Cor e opacidade da sombra
              spreadRadius: 2, // Espalhamento da sombra
              blurRadius: 5, // Desfoque da sombra
              offset: Offset(0, 3), // Deslocamento da sombra
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 3000),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Text(
                  'Conheça nosso',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25, // Aumentando o tamanho do texto do título
                    color: Colors.blue,
                    height: 1,
                  ),
                ),
                Text(
                  'curso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60, // Aumentando o tamanho do texto do subtítulo
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    height: 0.5,
                  ),
                ),
                SizedBox(height: 20),
                // Lista de recursos oferecidos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blue,
                          size: 30, // Aumentando o tamanho do ícone
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Aulas didáticas e simples!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10, ),
                    
                    Column(
                      children: [
                        SizedBox(height: 25,),
                        Icon(
                          Icons.school,
                          color: Colors.blue,
                          size: 30, // Aumentando o tamanho do ícone
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Conteúdo programático\n completo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                  
                  ],
                ),
                  Column(
                      children: [
                        SizedBox(height: 30),
                        Icon(
                          Icons.book,
                          color: Colors.blue,
                          size: 30, // Aumentando o tamanho do ícone
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Espaço para aprender coisas novas\n e tirar suas dúvidas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class TeacherInformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 400, // Aumentando a altura da seção
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Margem externa
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/professoro2.png'),
            fit: BoxFit.cover,
          ),
          color: const Color.fromARGB(255, 127, 129, 129),
          borderRadius: BorderRadius.circular(20), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Cor e opacidade da sombra
              spreadRadius: 2, // Espalhamento da sombra
              blurRadius: 5, // Desfoque da sombra
              offset: Offset(0, 3), // Deslocamento da sombra
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 3000),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Text(
                  'Esse é Gabriel, seu Professor de Inglês.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // Aumentando o tamanho do texto do subtítulo
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 70, // Aumentando o tamanho do avatar
                  backgroundImage: AssetImage('assets/professor.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Professor poliglota com experiência com '
                  'ensino em escolas de idiomas tradicionais e estudos '
                  'de línguas no exterior. Desenvolveu o curso com a bagagem necessária '
                  'para ajudar as pessoas a começarem seus estudos com a língua inglesa '
                  'e aprender como aprender um idioma.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class VideoPresentationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu.png'), // Adicione o caminho da sua imagem
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 400, // Aumentando a altura da seção
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Margem externa
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/curso.png'),
            fit: BoxFit.cover,
          ),
          color: const Color.fromARGB(255, 127, 129, 129),
          borderRadius: BorderRadius.circular(20), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Cor e opacidade da sombra
              spreadRadius: 2, // Espalhamento da sombra
              blurRadius: 5, // Desfoque da sombra
              offset: Offset(0, 3), // Deslocamento da sombra
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 3000),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Text(
                  'Vídeo de Apresentação',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25, // Aumentando o tamanho do texto do título
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: VideoPlayerScreen(), // Widget do vídeo player
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/apresentacao.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
class ContactInformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu.png'), // Adicione o caminho da sua imagem
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 400, // Aumentando a altura da seção
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Margem externa
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/curso.png'),
            fit: BoxFit.cover,
          ),
          color: const Color.fromARGB(255, 127, 129, 129),
          borderRadius: BorderRadius.circular(20), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Cor e opacidade da sombra
              spreadRadius: 2, // Espalhamento da sombra
              blurRadius: 5, // Desfoque da sombra
              offset: Offset(0, 3), // Deslocamento da sombra
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 3000),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                
                Text(
                  'Entre em contato',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25, // Aumentando o tamanho do texto do título
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
              
                Row(
                  children: [
                       SizedBox(width: 10),
                    Icon(FontAwesomeIcons.envelope, color: Colors.blue, size: 20),
                 SizedBox(width: 10),
                    Text(
                      'E-mail: gabrieldiaslsp@gmail.com',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(FontAwesomeIcons.phone, color: Colors.blue, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Telefone: +55 11 98040-4392',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(FontAwesomeIcons.instagram, color: Colors.blue, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Instagram: @gabrieldiaslz',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BannerSection extends StatelessWidget {
  final Function(double) scrollToCourseInfo;

  BannerSection(this.scrollToCourseInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/banner.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.1), // Adiciona uma leve transparência
            BlendMode
                .darken, // Aplica um tom mais escuro sobre a imagem de fundo
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Aprenda Inglês',
            //   style: TextStyle(
            //     fontSize: 32,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            // SizedBox(height: 10),
            // const Text(
            //   'Comece sua jornada para a fluência agora!',
            //   style: TextStyle(
            //     fontSize: 18,
            //     color: Colors.white,
            //   ),
            // ),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(
                  context, '/pagamento', (Route<dynamic> route) => true);
              },
              child: const Text(
                'Saiba Mais',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor de fundo do botão
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Borda arredondada
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

