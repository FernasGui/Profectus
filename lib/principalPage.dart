import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/autenticacao/loginPage.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/vermais.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';
import 'package:profectus/pagsecundarias/feedbackrecebido.dart';
import 'package:profectus/pagsecundarias/feedbackdado.dart';
import 'package:profectus/pagsecundarias/analisepreditiva.dart';
import 'package:profectus/pagsecundarias/profectusbot.dart';

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
  String _userCargo = '';
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _hasNotifications = false;
  List<Map<String, dynamic>> _objetivos = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          String nome = userData['nome'] ?? 'Sem nome';
          String cargo = userData['cargo'] ?? '';

          var snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('objetivos')
              .get();

          var notificacoesSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('notificacoes')
              .limit(1)
              .get();

          var objetivos = snapshot.docs.map((doc) => doc.data()).toList();
          objetivos.sort((a, b) =>
              ((b['progressoRelativo'] ?? 0) as num).compareTo((a['progressoRelativo'] ?? 0) as num));

          setState(() {
            _userName = nome;
            _userCargo = cargo;
            _userEmail = user.email ?? 'No Email';
            _objetivos = objetivos;
            _hasNotifications = notificacoesSnapshot.docs.isNotEmpty;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_userCargo == 'Trainee') {
      switch (index) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => DesafiosPage()));
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ConfiguracaoPage()));
          break;
      }
    } else {
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
              if (_hasNotifications)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
        items: _buildNavigationItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Desafios'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
    ];

    if (_userCargo != 'Trainee') {
      items.insert(1, const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha equipa'));
    }

    return items;
  }

  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildObjectivesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Objetivos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ..._objetivos.take(3).map((obj) {
              final numero = obj['numero'] ?? 0;
              final progressoRelativo = (obj['progressoRelativo'] ?? 0).toDouble();
              final percentagem = progressoRelativo.clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Objetivo $numero', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: percentagem,
                            backgroundColor: Colors.grey[400],
                            color: const Color(0xFF358932),
                            minHeight: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('${(percentagem * 100).toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
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

  Widget _buildBotCard() {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfectusBotPage()));
    },
    child: Card(
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
  // Verifica se todos os objetivos estão concluídos
  bool todosConcluidos = _objetivos.isNotEmpty &&
      _objetivos.every((obj) => (obj['progressoRelativo'] ?? 0.0).toDouble() >= 1.0);

  // Calcular a moda dos resultados
 Map<String, int> frequencias = {};
for (var obj in _objetivos) {
  String? resultado = obj['resultado'];
  if (resultado != null && resultado.isNotEmpty) {
    frequencias[resultado] = (frequencias[resultado] ?? 0) + 1;
  }
}

  // Define a frase final com base nas condições
String frase = '';
if (_objetivos.every((obj) => (obj['progressoRelativo'] ?? 0.0).toDouble() >= 1.0)) {
  frase = 'Concluiu com sucesso todos os objetivos!';
} else if (frequencias.isNotEmpty) {
  String moda = frequencias.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  frase = '$moda! Clique para obter mais informações.';
} else {
  frase = 'Está dentro dos objetivos anuais! Mas há sempre espaço para melhorar.';
}

  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalisePreditivaPage()));
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF358932),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A Minha Situação Atual',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  frase,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 12,
            top: 12,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
}