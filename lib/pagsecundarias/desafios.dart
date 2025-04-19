import 'package:flutter/material.dart';
import 'package:profectus/pagsecundarias/ranking.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';
import 'package:profectus/principalPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesafiosPage extends StatefulWidget {
  @override
  _DesafiosPageState createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  int _selectedIndex = 0;
  String _userCargo = '';
  bool _showPopup = false;
  List<int> _completedObjectiveIndexes = [];
  List<Map<String, dynamic>> _objetivos = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      var objetivosSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('objetivos')
          .orderBy('descricao')
          .get();

      var objetivos = objetivosSnapshot.docs.map((doc) => doc.data()).toList();
      var completedIndexes = <int>[];
      for (int i = 0; i < objetivos.length; i++) {
        if ((objetivos[i]['pontos'] ?? 0) >= 100) {
          completedIndexes.add(i);
        }
      }

      setState(() {
        _userCargo = doc.data()?['cargo'] ?? '';
        _objetivos = objetivos;
        _completedObjectiveIndexes = completedIndexes;
        _showPopup = completedIndexes.isNotEmpty;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_userCargo == 'Trainee') {
      switch (index) {
        case 0:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrincipalPage()));
          break;
        case 1:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfiguracaoPage()));
          break;
      }
    } else {
      switch (index) {
        case 0:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MinhaEquipaPage()));
          break;
        case 1:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrincipalPage()));
          break;
        case 2:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfiguracaoPage()));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('imagens/jmbranco.png', height: 40),
          ],
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MensagensPage()),
                  );
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
      body: Stack(
        children: [
          _buildMainContent(context),
          if (_showPopup) _buildPopup(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _userCargo == 'Trainee'
            ? const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
              ]
            : const [
                BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha Equipa'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
              ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final colors = [
      Colors.lightGreen,
      Colors.green,
      Colors.teal,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.deepPurple,
      Colors.cyan,
      Colors.tealAccent,
      Colors.lime,
    ];

    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Os meus desafios', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_objetivos.length, (index) {
                  var obj = _objetivos[index];
                  var pontos = (obj['pontos'] ?? 0).toDouble();
                  var progress = (pontos / 100).clamp(0.0, 1.0);
                  var color = colors[index % colors.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildBar(progress, color, 'Objetivo ${index + 1}'),
                  );
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RankingPage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text('Veja a Classificação', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPopup(BuildContext context) {
    String objetivosText = _completedObjectiveIndexes.map((i) => 'Objetivo ${i + 1}').join(' e ');

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Parabéns!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 10),
                Text('Completou ${_completedObjectiveIndexes.length == 1 ? 'o' : 'os'} $objetivosText!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Image.asset('imagens/TROFEU.png', height: 100),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => setState(() => _showPopup = false),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double value, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 60,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 60,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 60,
                  height: (MediaQuery.of(context).size.height * 0.55) * value,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
