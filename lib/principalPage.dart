import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profectus/autenticacao/loginPage.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/vermais.dart';
import 'package:profectus/pagsecundarias/mensagens.dart';
import 'package:profectus/pagsecundarias/feedbackrecebido.dart';
import 'package:profectus/pagsecundarias/feedbackdado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrincipalPage extends StatefulWidget {
  final String? nome;

  const PrincipalPage({Key? key, this.nome}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = '';
  String _userEmail = '';
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          String nome = userData['nome'] ?? 'Sem nome';

          setState(() {
            _userName = nome;
            _userEmail = user.email ?? 'No Email';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _userName = 'Erro ao carregar';
          _userEmail = 'No Email';
          _isLoading = false;
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => DesafiosPage()));
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MensagensPage()));
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: 16),
                  _buildObjectivesCard(),
                  const SizedBox(height: 16),
                  _buildBotCard(),
                  const SizedBox(height: 16),
                  _buildFeedbackCard(),
                  const SizedBox(height: 16),
                  _buildSituationCard(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Desafios'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha equipa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
    );
  }

Widget _buildProfileSection() {
  return Center(
    child: Column(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          child: Icon(Icons.person, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 8), // menos espaço entre avatar e nome
        Text(
          _userName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildObjectivesCard() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), // <- reduzido o top padding (16 → 12)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Objetivos Anuais', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6), // <- menos espaço entre título e primeiro objetivo
          _buildProgressRow('Objetivo 1', 0.7),
          const SizedBox(height: 8),
          _buildProgressRow('Objetivo 2', 0.5),
          const SizedBox(height: 8),
          _buildProgressRow('Objetivo 3', 0.2),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VerMaisPage()));
              },
              child: const Text('+ Ver Mais', style: TextStyle(color: Color(0xFF358932), fontSize: 12)),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildProgressRow(String label, double value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[300],
                color: const Color(0xFF358932),
                minHeight: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBotCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF358932),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('imagens/bot.png', height: 40),
            const SizedBox(width: 10),
            const Text('Peça dicas de melhoria...', style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildFeedbackButton('Feedback Recebido', FeedbackRecebidoPage()),
                const SizedBox(height: 10),
                _buildFeedbackButton('Feedback Dado', FeedbackDadoPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(String text, Widget page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF358932),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

Widget _buildSituationCard() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF358932),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'A Minha Situação Atual',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Está dentro dos objetivos anuais! Mas há sempre espaço para melhorar.',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

}
