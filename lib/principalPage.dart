import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/autenticacao/loginPage.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = 'Utilizador Anônimo';
  String _userEmail = 'No Email';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        setState(() {
          _userName = userData?['nome'] ?? 'Utilizador Anônimo';
          _userEmail = user.email ?? 'No Email';
        });
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('imagens/logo_profectus.png', height: 60),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset('imagens/jmbranco.png', height: 50),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.mail_outline, color: Colors.white),
                  onPressed: () {},
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Objetivos Anuais',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Objetivo 1'),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF358932),
            ),
            const SizedBox(height: 10),
            const Text('Objetivo 2'),
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF358932),
            ),
            const SizedBox(height: 10),
            const Text('Objetivo 3'),
            LinearProgressIndicator(
              value: 0.2,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF358932),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('+Ver Mais',
                    style: TextStyle(color: Color(0xFF358932))),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'ProfectusBot',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF358932),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('imagens/bot.png', height: 40),
                  const SizedBox(width: 10),
                  const Text(
                    'Peça dicas de melhoria...',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Feedback Recebido\nHistórico de Feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Feedback Dado\nHistórico de Feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text.rich(
                TextSpan(
                  text: 'A Minha Situação Atual\n',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline, // Sublinhar
                  ),
                  children: [
                    TextSpan(
                      text:
                          '\nAtualmente encontra-se dentro dos objetivos definidos para o seu ano! Muito bem! Mas há sempre espaço para melhorar, fale com o ProfectusBot!',
                      style: TextStyle( 
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Colors.black,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white,
  currentIndex: 0, // Inicialize como 0
  onTap: (index) {
    setState(() {
      // Atualiza a página selecionada.
      // Se você não quer redirecionar, ajuste os rótulos do footer e ação.
    });
  },
  items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ponto de situação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Avaliar equipa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
