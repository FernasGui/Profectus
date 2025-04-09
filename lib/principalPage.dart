import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/autenticacao/loginPage.dart';
import 'package:profectus/pagsecundarias/pontosituacao.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/vermais.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = 'Utilizador Anônimo';
  String _userEmail = 'No Email';
  int _selectedIndex = 0;

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
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => PontoSituacaoPage()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MinhaEquipaPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConfiguracaoPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('imagens/logo_profectus.png', height: 40),
            const SizedBox(width: 8),
            Expanded(
              child: Center(
                child: Image.asset('imagens/jmbranco.png', height: 40),
              ),
            ),
          ],
        ),
        actions: [
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Objetivos Anuais', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: 0.7, backgroundColor: Colors.grey, color: Color(0xFF358932)),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: 0.5, backgroundColor: Colors.grey, color: Color(0xFF358932)),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: 0.2, backgroundColor: Colors.grey, color: Color(0xFF358932)),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF358932),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerMaisPage()));
                },
                child: const Text('+ Ver Mais', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            const Text('ProfectusBot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: Color(0xFF358932), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('imagens/bot.png', height: 40),
                  const SizedBox(width: 10),
                  const Text('Peça dicas de melhoria...', style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text('Feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      fixedSize: const Size.fromHeight(80),
                    ),
                    onPressed: () {},
                    child: const Text('Feedback Recebido\nHistórico de Feedback', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      fixedSize: const Size.fromHeight(80),
                    ),
                    onPressed: () {},
                    child: const Text('Feedback Dado\nHistórico de Feedback', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
              child: const Text.rich(
                TextSpan(
                  text: 'A Minha Situação Atual\n',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  children: [
                    TextSpan(
                      text: '\nEstá dentro dos objetivos anuais! Mas há sempre espaço para melhorar.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Ponto de Situação'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha equipa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
    );
  }
}