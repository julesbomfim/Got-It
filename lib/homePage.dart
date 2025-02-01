import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

////
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  List<double> _sectionPositions = [];
  int _selectedButtonIndex = 0;

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
    if (_selectedButtonIndex != newIndex) {
      setState(() {
        _selectedButtonIndex = newIndex;
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: Colors.blue,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildNavButton(0, 'Home'),
                buildNavButton(1, 'Sobre o Curso'),
                buildNavButton(2, 'Professor'),
                buildNavButton(3, 'Vídeo de Apresentação'),
                buildNavButton(4, 'Contato'),
                buildNavButton(-1, 'Login'),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/menu.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                BannerSection((double position) => _scrollToSection(_sectionPositions[0])),

                CourseInformationSection(),
                TeacherInformationSection(),
                VideoPresentationSection(),
                 PhotoGallerySection(),
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
   Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => true);
}

Widget buildNavButton(int index, String text) {
  return Stack(
    children: [
      TextButton(
        onPressed: () {
          if (index != -1) {
            setState(() {
              _selectedButtonIndex = index;
            });
            _scrollToSection(_sectionPositions[index]);
          } else {
            _onLoginButtonPressed(); // Chama a função para redirecionar para a página de login
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: _selectedButtonIndex == index ? Colors.blue : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      if (_selectedButtonIndex == index)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 2,
            color: Colors.blue,
          ),
        ),
    ],
  );
}

  void _calculateSectionPositions() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _sectionPositions.clear();
      for (int i = 0; i <= 4; i++) {
        RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          double position = renderBox
              .localToGlobal(Offset(0, 500 * i.toDouble()),
              ancestor: context.findRenderObject())
              .dy;
          _sectionPositions.add(position);
        }
      }
    });
  }
}

//////



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
                    fontSize: 90, // Aumentando o tamanho do texto do subtítulo
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    height: 0.5
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
                          size: 50, // Aumentando o tamanho do ícone
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Aulas didáticas e simples!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: [
                        Icon(
                          Icons.school,
                          color: Colors.blue,
                          size: 50, // Aumentando o tamanho do ícone
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Conteúdo programático completo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: [
                        SizedBox(height: 30),
                        Icon(
                          Icons.book,
                          color: Colors.blue,
                          size: 50, // Aumentando o tamanho do ícone
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Espaço para aprender coisas novas\n e tirar suas dúvidas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ],
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
//////////////////////


class TeacherInformationSection extends StatelessWidget {
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
        height: 400,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Margem externa
        decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
            image: AssetImage('assets/professoro.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20), // Borda arredondada
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Cor e opacidade da sombra
              spreadRadius: 2, // Espalhamento da sombra
              blurRadius: 5, // Desfoque da sombra
              offset: Offset(0, 3), // Deslocamento da sombra
            ),
          ],
        ),
        padding: EdgeInsets.all(20), // Espaçamento interno
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AnimationLimiter(
            child: Row(
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
                  // Widget para exibir a foto do professor em formato redondo
                  SizedBox(width: 200),
                  Container(
                    width: 300, // Largura da área da foto
                    height: 300, // Altura da área da foto
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle, // Formato redondo
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage('assets/professor.png'),
                        fit: BoxFit.cover, // Ajuste da imagem dentro da área
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Widget para exibir o texto sobre o professor
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Esse é o Gabriel, seu Professor de Inglês.',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MadeTommy', // Use a fonte personalizada aqui
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 600, // Ajuste a largura do container conforme necessário
                        child: Text(
                          'Professor poliglota com experiência com '
                          'ensino em escolas de idiomas tradicionais e estudos '
                          'de línguas no exterior. Desenvolveu o curso com a bagagem necessária '
                          'para ajudar as pessoas a começarem seus estudos com a língua inglesa '
                          'e aprender como aprender um idioma.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'MadeTommy', // Use a fonte personalizada aqui
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class VideoPresentationSection extends StatefulWidget {
  @override
  _VideoPresentationSectionState createState() =>
      _VideoPresentationSectionState();
}

class _VideoPresentationSectionState extends State<VideoPresentationSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'video.mp4') // Altere 'video.mp4' para o caminho do seu vídeo
      ..initialize().then((_) {
        // Garantir que o vídeo esteja pronto para ser reproduzido quando for inicializado
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller
        .dispose(); // Dispose do controlador de vídeo quando não for mais necessário
  }

  @override
  Widget build(BuildContext context) {
     return   Container(
           
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/menu.png'), // Adicione o caminho da sua imagem
                      fit: BoxFit.cover,
                    ),
                  ),
                child:  Container(
      height: 400,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/curso.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Descrição do Vídeo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Pellentesque et felis in nunc molestie ultrices. '
                    'Sed quis justo scelerisque, consectetur leo eget, '
                    'fringilla felis. Aenean in libero vestibulum, aliquet '
                    'sem eget, ullamcorper est.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          // Vídeo à esquerda
          Container(
            width: 500, // Defina o tamanho desejado para o vídeo
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(), // Mostrar um container vazio se o vídeo não estiver inicializado
            ),
          ),
          // Texto ao lado do vídeo
          SizedBox(
            width: 50,
          )
        ],
      ),
    ));
  }
}





class PhotoGallerySection extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/photo1.png', // Caminho das imagens do carrossel
    'assets/photo2.png',
    'assets/photo3.png',
    'assets/photo4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Bordas arredondadas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Sombra
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Galeria de Fotos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),

          // Carrossel de Imagens
          CarouselSlider(
            options: CarouselOptions(
              height: 300, // Defina a altura do carrossel
              autoPlay: true, // Ativa a rotação automática
              enlargeCenterPage: true, // Amplia a imagem central
              autoPlayInterval: Duration(seconds: 3), // Intervalo de 3 segundos
              viewportFraction: 0.8, // Espaço ocupado por cada imagem
            ),
            items: imagePaths.map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover, // Ajuste para cobrir o espaço disponível
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}









class ContactInformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return   Container(
           
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/menu.png'), // Adicione o caminho da sua imagem
                      fit: BoxFit.cover,
                    ),
                  ),
                child:  Container(
      height: 320,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
            image: DecorationImage(
                      image: AssetImage('assets/curso.png'), // Adicione o caminho da sua imagem
                      fit: BoxFit.cover,
                    ),
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 200),
        child: AnimationLimiter(
          child: Row(
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
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ContactDetail(
                  icon: Icons.phone,
                  label: 'Telefone',
                  value: '+55 11 98040-4392',
                ),
                SizedBox(width: 150,),
                ContactDetail(
                  icon: Icons.email,
                  label: 'E-mail',
                  value: 'gabrieldiaslsp@gmail.com',
                ),
                SizedBox(width: 150,),
                ContactDetail(
                  icon: FontAwesomeIcons.instagram,
                  label: 'Instagram',
                  value: '@gabrieldiaslz',
                ),
              ],
            ),
          ],
        ),
      ]),
    )))));
  }
}

class ContactDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactDetail({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: 30,
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class BannerSection extends StatelessWidget {
  final Function(double) scrollToCourseInfo;

  BannerSection(this.scrollToCourseInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
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
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
////////////////////////////////////////////////////////////////////////////////
///
///
///
///
///
///
/////////////////////////////////////////////

// class CourseInformationSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       color: const Color.fromARGB(255, 7, 116, 194),  // Fundo claro para contraste
//       height: 500,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o conteúdo
//         children: [
//           // Adicionando a imagem centralizada com bordas arredondadas e moldura
//           SizedBox(height: 50,),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.8,  // Ajustando a largura para 90% da tela
//             height: 350,  // Definindo uma altura específica
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20), // Bordas arredondadas
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26, // Cor da sombra
//                   spreadRadius: 5,
//                   blurRadius: 10,
//                   offset: Offset(0, 5), // Sombra abaixo da imagem
//                 ),
//               ],
//               border: Border.all(
//                 color: Colors.blueAccent, // Cor da borda (moldura)
//                 width: 3, // Largura da borda
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20), // Aplica o arredondamento à imagem
//               child: Image.asset(
//                 'assets/conhecanossocurso.png',  // Substitua pelo caminho correto da imagem
//                 fit: BoxFit.cover,  // Ajusta a imagem para cobrir o espaço disponível
//               ),
//             ),
//           ),
//           SizedBox(height: 20), // Espaçamento entre a imagem e o título

//           // Text(
//           //   'Conheça nosso curso',
//           //   style: TextStyle(
//           //     fontSize: 28,
//           //     fontWeight: FontWeight.bold,
//           //     color: Colors.blue[900],
//           //   ),
//           // ),
//           // SizedBox(height: 20),
//           // Text(
//           //   'Nosso curso é desenvolvido para ajudá-lo a alcançar fluência rapidamente. Com aulas interativas, tutores especializados, e materiais de apoio, você terá tudo o que precisa para dominar o idioma.',
//           //   textAlign: TextAlign.center,
//           //   style: TextStyle(fontSize: 16),
//           // ),
//           // SizedBox(height: 20),

//           // // Linha com ícones de funcionalidades
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //   children: [
//           //     buildFeature(
//           //       icon: Icons.lightbulb_outline,
//           //       title: 'Método Interativo',
//           //       description: 'Aprenda de forma prática e rápida com exemplos reais.',
//           //     ),
//           //     buildFeature(
//           //       icon: Icons.school,
//           //       title: 'Tutoria Especializada',
//           //       description: 'Nossos tutores são certificados e prontos para ajudar.',
//           //     ),
//           //     buildFeature(
//           //       icon: Icons.book,
//           //       title: 'Material Completo',
//           //       description: 'Conteúdo exclusivo e atualizado para maximizar seu aprendizado.',
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget buildFeature({required IconData icon, required String title, required String description}) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.blue, size: 60),  // Ícone grande e chamativo
//         SizedBox(height: 10),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue[900],
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           description,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.black54,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TeacherInformationSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       color: Color.fromARGB(255, 227, 227, 227), // Fundo claro
//       height: 500,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center, // Centralizando o conteúdo
//         children: [
//           // Text(
//           //   'Seu professor',
//           //   style: TextStyle(
//           //     fontSize: 28,
//           //     fontWeight: FontWeight.bold,
//           //     color: Colors.blue[900],
//           //   ),
//           // ),
//           SizedBox(height: 50,),

//           // Adicionando a imagem ocupando o espaço disponível, com moldura e bordas arredondadas
//           Container(
//             width: MediaQuery.of(context).size.width * 0.8,  // 90% da largura da tela
//             height: 350,  // Altura definida para a imagem
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20), // Bordas arredondadas
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26, // Cor da sombra
//                   spreadRadius: 5,
//                   blurRadius: 10,
//                   offset: Offset(0, 5), // Sombra abaixo da imagem
//                 ),
//               ],
//               border: Border.all(
//                 color: Colors.blueAccent, // Cor da borda (moldura)
//                 width: 3, // Largura da borda
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20), // Aplica o arredondamento à imagem
//               child: Image.asset(
//                 'assets/gabriel.png',  // Substitua pelo caminho correto da imagem
//                 fit: BoxFit.cover,  // Ajusta a imagem para cobrir o espaço disponível
//               ),
//             ),
//           ),

//           SizedBox(height: 20), // Espaçamento entre a imagem e o texto

//           // Texto descritivo sobre o professor
//           // Text(
//           //   'Nosso professor, Gabriel Dias, é especialista em ensino de línguas com mais de 10 anos de experiência. Ele tem paixão por ensinar e ajudará você a dominar o inglês com técnicas práticas e eficazes.',
//           //   textAlign: TextAlign.center,
//           //   style: TextStyle(fontSize: 16),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class PhotoGallerySection extends StatelessWidget {
//   final List<String> imagePaths = [
//     'assets/photo1.png', // Substitua pelos caminhos corretos das suas imagens
//     'assets/photo2.png',
//     'assets/photo3.png',
//     'assets/photo4.png',
//     // Adicione mais imagens conforme necessário
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       color: Colors.grey[100],  // Cor de fundo da galeria
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Galeria de Fotos',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[900],
//             ),
//           ),
//           SizedBox(height: 20),

//           // Carrossel de imagens
//           CarouselSlider(
//             options: CarouselOptions(
//               height: 400, // Altura do carrossel
//               autoPlay: true, // As imagens trocam automaticamente
//               enlargeCenterPage: true, // A imagem central é ampliada
//               aspectRatio: 16 / 9,
//               autoPlayInterval: Duration(seconds: 3), // Troca de imagem a cada 3 segundos
//               viewportFraction: 0.8, // Quantidade de espaço ocupada por cada imagem
//             ),
//             items: imagePaths.map((imagePath) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return Container(
//                     margin: EdgeInsets.symmetric(horizontal: 10), // Espaço entre as imagens
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20), // Bordas arredondadas
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26, // Sombra
//                           spreadRadius: 5,
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20), // Arredondamento da imagem
//                       child: Image.asset(
//                         imagePath,
//                         fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o espaço
//                         width: double.infinity, // Largura para cobrir todo o container
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPresentationSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       color: Colors.blue[50],
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Veja nossa apresentação',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[900],
//             ),
//           ),
//           SizedBox(height: 20),
//           Container(
//             height: 200,
//             child: Center(
//               child: Image.asset(
//                 'assets/play_video_placeholder.png',  // Coloque um placeholder de vídeo
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class ContactInformationSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       color: Colors.yellow[100],  // Um fundo mais chamativo para destacar a seção de contato
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Fale conosco',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[900],
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               buildContactInfo(Icons.phone, 'Telefone', '+55 11 99999-9999'),
//               buildContactInfo(Icons.email, 'E-mail', 'contato@curso.com'),
//               buildContactInfo(Icons.location_on, 'Endereço', 'Rua Exemplo, 123, São Paulo'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildContactInfo(IconData icon, String label, String info) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.blue, size: 30),
//         SizedBox(height: 10),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue[900],
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           info,
//           style: TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }
// }
