import 'package:flutter/material.dart';
import 'package:ingleswebsite/alunos.dart';
import 'package:ingleswebsite/auth/authentic.dart';
import 'package:ingleswebsite/loginPage.dart';
import 'package:lottie/lottie.dart';



class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  AuthService authService = AuthService();

  bool _passwordsMatch = true;
  bool _isPasswordVisible = false;

 

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _checkPasswordsMatch() {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _passwordsMatch = false;
      });
    } else {
      setState(() {
        _passwordsMatch = true;
      });
    }
  }

  bool _validatePassword(String password) {
    return password.length >= 8;
  }

  bool _validateFields() {
    return nomeController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool _validateEmail(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  void _submitForm() async {
    if (!_validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!_validateEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira um endereço de e-mail válido.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!_validatePassword(passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A senha deve ter pelo menos 8 caracteres.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'As senhas não coincidem. Por favor, insira senhas idênticas.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Todas as validações passaram, criar conta
      final successs = await authService.createAccount(
        email: emailController.text.toLowerCase().trim(),
        senha: passwordController.text,
        nome: nomeController.text,
      );

      if (successs) {
        // Registro bem-sucedido
        final user = Alunos(
          nome: nomeController.text,
          email: emailController.text,
          senha: passwordController.text,
          confirmarSenha: confirmPasswordController.text,
          progresso: {},
        );

        setState(() {
          nomeController.text = '';
          emailController.text = '';
          passwordController.text = '';
          confirmPasswordController.text = '';
        });
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastro realizado com sucesso'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        // Erro ao criar conta, exiba uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar o cadastro, tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            // Se a largura da tela for menor que 600, exibe a versão móvel
            return _buildMobileRegisterScreen();
          } else {
            // Caso contrário, exibe a versão para notebook
            return _buildNotebookRegisterScreen();
          }
        },
      ),
    );
  }



 Widget _buildMobileRegisterScreen() {
    return Scaffold( 
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned(
          //   top: 50,
          //   left: 30,
          //   child: Lottie.network(
          //     'https://lottie.host/32028b78-21fc-4ebc-97db-72a2c03d1c62/0tJhGS6Few.json',
          //     width: 150,
          //     height: 150,
          //     fit: BoxFit.cover,
          //   ),
          // ),
         SingleChildScrollView( child:  Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Center(
                  child: Text(
                    'Cadastro',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50
                ),
                  //         Center( child:    
                  // Lottie.network(
                  //   'https://lottie.host/32028b78-21fc-4ebc-97db-72a2c03d1c62/0tJhGS6Few.json',
                  //   width: 100,
                  //   height: 100,
                  //   fit: BoxFit.cover,
                  // ),),
                  SizedBox(height: 20),

                _buildTextField(
                  controller: nomeController,
                  labelText: 'Nome',
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  labelText: 'Email',
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                _buildPasswordField(
                  controller: passwordController,
                  labelText: 'Senha',
                  isVisible: _isPasswordVisible,
                  toggleVisibility: _togglePasswordVisibility,
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  labelText: 'Confirmar Senha',
                  isVisible: _isPasswordVisible,
                  toggleVisibility: _togglePasswordVisibility,
                  errorText:
                      !_passwordsMatch ? 'As senhas não coincidem' : null,
                  onChanged: (_) {
                    _checkPasswordsMatch();
                  },
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Cadastrar',
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
       ) ],
      ),
    );
  }


  
  Widget _buildNotebookRegisterScreen() {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 30,
            child: Lottie.network(
              'https://lottie.host/32028b78-21fc-4ebc-97db-72a2c03d1c62/0tJhGS6Few.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Cadastro',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                _buildTextField(
                  controller: nomeController,
                  labelText: 'Nome',
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  labelText: 'Email',
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                _buildPasswordField(
                  controller: passwordController,
                  labelText: 'Senha',
                  isVisible: _isPasswordVisible,
                  toggleVisibility: _togglePasswordVisibility,
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 20),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  labelText: 'Confirmar Senha',
                  isVisible: _isPasswordVisible,
                  toggleVisibility: _togglePasswordVisibility,
                  errorText:
                      !_passwordsMatch ? 'As senhas não coincidem' : null,
                  onChanged: (_) {
                    _checkPasswordsMatch();
                  },
                  onSubmitted: (_) {
                    _submitForm();
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Cadastrar',
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
    ValueChanged<String>? onSubmitted,
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
          borderSide: BorderSide(color: Colors.blue), // Cor da borda azul
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Cor da borda azul
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? errorText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.blue),
        labelText: labelText,
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue), // Cor da borda azul
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Cor da borda azul
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }



}



 

