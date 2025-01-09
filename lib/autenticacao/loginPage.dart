import 'package:flutter/material.dart';
import 'package:profectus/autenticacao/registerPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profectus/principalPage.dart'; // Import da página principal

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _loginButtonPressed() async {
    // Versão com autenticação no Firebase
    /*
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // Tenta fazer o login com o e-mail e senha
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Login bem-sucedido: ${userCredential.user}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PrincipalPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Trata erros de autenticação
      String errorMessage =
          'Ocorreu um erro ao fazer login. Por favor, tente novamente.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum utilizador encontrado para esse e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta fornecida para esse utilizador.';
      }

      // Mostra um diálogo de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erro de Login"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    */

    // Versão sem autenticação (direciona diretamente para a PrincipalPage)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PrincipalPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset('imagens/logo_profectus.png', width: 135, height: 135),
              const SizedBox(height: 60),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF358932),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _loginButtonPressed,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  // Placeholder para recuperação de senha
                },
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(color: Color(0xFF358932)),
                ),
              ),
              TextButton(
                child: const Text(
                  'Não tem uma conta? Registe-se aqui.',
                  style: TextStyle(color: Color(0xFF358932)),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPages()));
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
