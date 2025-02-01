import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ingleswebsite/TeladoAluno.dart';
import 'package:ingleswebsite/auth/authentic.dart';
import 'package:ingleswebsite/loandingAdminPrincipal.dart';
import 'package:ingleswebsite/loandingAlunoPrincipal.dart';
import 'package:ingleswebsite/registrar.dart';
import 'package:ingleswebsite/telaAdmin.dart';
import 'package:ingleswebsite/visualVideos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AuthService authController = AuthService();

  bool _isObscured = true;
  bool _isRememberMeChecked = false;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  void _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRememberMeChecked = prefs.getBool('remember_me') ?? false;
      if (_isRememberMeChecked) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void _saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_isRememberMeChecked) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('remember_me');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    // ... Seu código atual para o diálogo de recuperação de senha ...
  }

  void _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    // Realiza o login
    final result = await authController.login(
      email: email,
      password: password,
    );

    if (result) {
      _saveUserCredentials(); // Salva as credenciais se necessário

      // Verifica se o email é do administrador
      if (email == 'admin@gmail.com') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/telaAdmin',
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/telaAluno',
          (Route<dynamic> route) => false,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logado com sucesso.'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email ou senha incorretos. Por favor, tente novamente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Fecha o teclado virtual após tentativa de login
    FocusManager.instance.primaryFocus?.unfocus();
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
        child: 
      LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
     ) );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: Stack(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
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
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.blue),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onFieldSubmitted: (_) {
                    _login();
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
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
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.blue),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (_) {
                    _login();
                  },
                ),
                SizedBox(height: 10),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.blue, // Cor da borda do checkbox quando não está selecionado
          ),
          child: Checkbox(
            value: _isRememberMeChecked,
            onChanged: (value) {
              setState(() {
                _isRememberMeChecked = value!;
              });
            },
            activeColor: Colors.blue, // Cor de fundo do checkbox quando está selecionado
            checkColor: Colors.white, // Cor do ícone de seleção dentro do checkbox
          ),
        ),
        Text(
          'Lembre-me',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    ),
    TextButton(
      onPressed: () {
        _showForgotPasswordDialog(context);
      },
      child: Text(
        'Esqueci a senha',
        style: TextStyle(color: Colors.blue),
      ),
    ),
  ],
),


                SizedBox(height: 10),
                Row(
                  children: [
                  
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/pagamento', (Route<dynamic> route) => true);
                      },
                      child: Text(
                        'Registrar-se',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        'Logar',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color.fromARGB(255, 30, 98, 170)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color.fromARGB(255, 30, 98, 170)),
                      ),
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 120),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
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
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.blue),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onFieldSubmitted: (_) {
                    _login();
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
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
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.blue),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (_) {
                    _login();
                  },
                ),
                SizedBox(height: 10),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.blue, // Cor da borda do checkbox quando não está selecionado
          ),
          child: Checkbox(
            value: _isRememberMeChecked,
            onChanged: (value) {
              setState(() {
                _isRememberMeChecked = value!;
              });
            },
            activeColor: Colors.blue, // Cor de fundo do checkbox quando está selecionado
            checkColor: Colors.white, // Cor do ícone de seleção dentro do checkbox
          ),
        ),
        Text(
          'Lembre-me',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    ),
    TextButton(
      onPressed: () {
        _showForgotPasswordDialog(context);
      },
      child: Text(
        'Esqueci a senha',
        style: TextStyle(color: Colors.blue),
      ),
    ),
  ],
),


            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/pagamento', (Route<dynamic> route) => true);
                      },
                      child: Text(
                        'Registrar-se',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        'Logar',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color.fromARGB(255, 30, 98, 170)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color.fromARGB(255, 30, 98, 170)),
                      ),
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
}


// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   AuthService authController = AuthService();

//   bool _isObscured = true;

//   void _showForgotPasswordDialog(BuildContext context) {
//     TextEditingController emailInputController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Esqueceu sua senha?"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: emailInputController,
//                 decoration: InputDecoration(
//                   labelText: 'E-mail',
//                   labelStyle: TextStyle(color: Colors.blue),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide:
//                         BorderSide(color: Colors.blue), // Cor da borda azul
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(color: Colors.blue), // Cor da borda azul
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Fechar o diálogo
//               },
//               child: Text(
//                 "Cancelar",
//                 style: TextStyle(color: Colors.blue),
//               ),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.resolveWith(
//                     (states) => Color.fromARGB(255, 255, 255, 255)),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String email = emailInputController.text.trim();
//                 if (email.isNotEmpty) {
//                   try {
//                     await FirebaseAuth.instance
//                         .sendPasswordResetEmail(email: email);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             "Um e-mail de redefinição de senha foi enviado para $email"),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             "Erro ao enviar e-mail de redefinição de senha: $e"),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                   Navigator.of(context).pop(); // Fechar o diálogo
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Por favor, insira um e-mail."),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: Text("Enviar", style: TextStyle(color: Colors.white)),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.resolveWith(
//                     (states) => Color.fromARGB(255, 30, 98, 170)),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//     @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth < 1000) {
//             // Layout para dispositivos móveis
//             return _buildMobileLayout();
//           } else {
//             // Layout para desktop/notebook
//             return _buildDesktopLayout();
//           }
//         },
//       ),
//     );
//   }


//   Widget _buildMobileLayout() {
//     return Center(
//       child:
//         Stack(
//         children: [
//           // Imagem de fundo
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/menu.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Login',
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   labelText: 'Email',
//                   labelStyle: TextStyle(color: Colors.blue),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 onFieldSubmitted: (_) {
//                   _login();
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: _isObscured,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   labelText: 'Senha',
//                   labelStyle: TextStyle(color: Colors.blue),
//                   filled: true,
//                   fillColor: Colors.white,
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _isObscured = !_isObscured;
//                       });
//                     },
//                     icon: Icon(
//                       _isObscured ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 onFieldSubmitted: (_) {
//                   _login();
//                 },
//               ),
//               SizedBox(height: 10),
//              Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     Spacer(), // Adiciona um espaço flexível à esquerda
//     TextButton(
//       onPressed: () {
//         _showForgotPasswordDialog(context);
//       },
//       child: Text(
//         'Esqueci a senha',
//         style: TextStyle(color: Colors.blue),
//       ),
//     ),
//   ],
// ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Não tem uma conta?'),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil(
//                           context, '/pagamento', (Route<dynamic> route) => true);
//                     },
//                     child: Text(
//                       'Registrar-se',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     ElevatedButton(
//       onPressed: _login,
//       child: Text(
//         'Logar',
//         style: TextStyle(color: Colors.white),
//       ),
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.resolveWith(
//             (states) => Color.fromARGB(255, 30, 98, 170)),
//       ),
//     ),
//     ElevatedButton(
//       onPressed: () {
//         Navigator.pushNamedAndRemoveUntil(
//             context, '/', (Route<dynamic> route) => false);
//       },
//       child: Text(
//         'Home',
//         style: TextStyle(color: Colors.white),
//       ),
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.resolveWith(
//             (states) => Color.fromARGB(255, 30, 98, 170)),
//       ),
//     ),
//   ],
// ),

//         ]),
//     )]),
//     );
//   }

//   Widget _buildDesktopLayout() {
//     return 
    
//     Scaffold(
//       body: Stack(
//         children: [
//           // Imagem de fundo
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/menu.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 20, horizontal: 400),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Center(
//                 child: Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 120,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide:
//                         BorderSide(color: Colors.blue), // Cor da borda azul
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(color: Colors.blue), // Cor da borda azul
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   labelText: 'Email',
//                   labelStyle: TextStyle(color: Colors.blue),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 onFieldSubmitted: (_) {
//                   _login();
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: _isObscured,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide:
//                         BorderSide(color: Colors.blue), // Cor da borda azul
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(color: Colors.blue), // Cor da borda azul
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   labelText: 'Senha',
//                   labelStyle: TextStyle(color: Colors.blue),
//                   filled: true,
//                   fillColor: Colors.white,
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _isObscured = !_isObscured;
//                       });
//                     },
//                     icon: Icon(
//                       _isObscured ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 onFieldSubmitted: (_) {
//                   _login();
//                 },
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       _showForgotPasswordDialog(context);
//                     },
//                     child: Text(
//                       'Esqueci a senha',
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Não tem uma conta?'),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil(
//                           context, '/pagamento', (Route<dynamic> route) => true);
//                     },
//                     child: Text(
//                       'Registrar-se',
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment
//                     .spaceEvenly, // Alinha os botões igualmente espaçados
//                 children: [
//                   ElevatedButton(
//                     onPressed: _login,
//                     child: Text(
//                       'Logar',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith(
//                           (states) => Color.fromARGB(255, 30, 98, 170)),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navegar para a homepage
//                       Navigator.pushNamedAndRemoveUntil(
//                           context, '/', (Route<dynamic> route) => false);
//                     },
//                     child: Text(
//                       'Home',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith(
//                           (states) => Color.fromARGB(255, 30, 98, 170)),
//                     ),
//                   ),
//                 ],
//               ),
//             ]),
//           )
//         ],
//       ),
//     );
//   }
// void _login() async {
//   final email = emailController.text;
//   final password = passwordController.text;

//   // Realiza o login
//   final result = await authController.login(
//     email: email,
//     password: password,
//   );



//   if (result) {
//     // Verifica se o email é do administrador
//     if (email == 'admin@gmail.com') {
//       Navigator.pushNamedAndRemoveUntil(
//         context, 
//         '/telaAdmin', 
//         (Route<dynamic> route) => false,
//       );
//     } else {
//       Navigator.pushNamedAndRemoveUntil(
//         context, 
//         '/telaAluno', 
//         (Route<dynamic> route) => false,
//       );
//     }
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Logado com sucesso.'),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Email ou senha incorretos. Por favor, tente novamente.',
//         ),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   // Fecha o teclado virtual após tentativa de login
//   FocusManager.instance.primaryFocus?.unfocus();
// }

// }