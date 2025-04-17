import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/principalPage.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userCargo = '';
  bool _isLoading = true;
  int _selectedIndex = 0;

  final List<Map<String, String>> rankingData = [
    {'posicao': '1º Lugar', 'pontuacao': '19/25'},
    {'posicao': '2º Lugar', 'pontuacao': '18/25'},
    {'posicao': '3º Lugar', 'pontuacao': '15/25'},
    {'posicao': '4º Lugar', 'pontuacao': '14/25'},
    {'posicao': '5º Lugar', 'pontuacao': '13/25'},
    {'posicao': '6º Lugar', 'pontuacao': '12/25'},
    {'posicao': '7º Lugar', 'pontuacao': '11/25'},
    {'posicao': '8º Lugar', 'pontuacao': '10/25'},
    {'posicao': '9º Lugar', 'pontuacao': '9/25'},
    {'posicao': '10º Lugar', 'pontuacao': '8/25'},
    {'posicao': '11º Lugar', 'pontuacao': '7/25'},
    {'posicao': '12º Lugar', 'pontuacao': '6/25'},
    {'posicao': '13º Lugar', 'pontuacao': '5/25'},
    {'posicao': '14º Lugar', 'pontuacao': '4/25'},
    {'posicao': '15º Lugar', 'pontuacao': '3/25'},
  ];

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
          setState(() {
            _userCargo = userData['cargo'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (_userCargo == 'Trainee' && index == 0) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MinhaEquipaPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PrincipalPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConfiguracaoPage()),
        );
        break;
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('imagens/jmbranco.png', height: 50),
          ],
        ),
        centerTitle: true,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Ranking Mensal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rankingData.length,
                      itemBuilder: (context, index) {
                        bool isHighlighted = index == 2;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isHighlighted ? Colors.green : Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                rankingData[index]['posicao']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            trailing: Text(
                              rankingData[index]['pontuacao']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  ),
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
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
    ];

    if (_userCargo != 'Trainee') {
      items.insert(0, const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha Equipa'));
    }

    return items;
  }
}
