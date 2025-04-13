import 'package:flutter/material.dart';
import 'package:profectus/autenticacao/registerPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profectus/principalPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Tenta fazer o login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Vai buscar os dados do Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Atenção que a coleção chama-se 'users'
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        String nome = userData['nome'] ?? 'Utilizador';

        // Agora navega para a PrincipalPage COM o nome
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PrincipalPage(nome: nome)),
        );
      } else {
        // Caso o documento não exista, mostrar alerta
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Dados do utilizador não encontrados."),
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
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro de autenticação.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum utilizador encontrado para esse e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta.';
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
                  backgroundColor: const Color(0xFF358932),
                  foregroundColor: Colors.white,
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
                  // Aqui no futuro podes implementar a recuperação de senha
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPages()),
                  );
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
