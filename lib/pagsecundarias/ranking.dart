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
  List<Map<String, dynamic>> _rankingData = [];
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _loadRankingData();
  }

  Future<void> _loadRankingData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      var usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> data = [];

      for (var userDoc in usersSnapshot.docs) {
        var objetivosSnapshot = await userDoc.reference.collection('objetivos').get();
        int completed = objetivosSnapshot.docs
            .where((doc) => (doc.data()['pontos'] ?? 0) >= 100)
            .length;

        data.add({
          'uid': userDoc.id,
          'nome': userDoc.data()['nome'] ?? 'Sem Nome',
          'completos': completed
        });
      }

      data.sort((a, b) => b['completos'].compareTo(a['completos']));

      setState(() {
        _rankingData = data;
        _userCargo = usersSnapshot.docs.firstWhere((d) => d.id == _currentUserId).data()['cargo'] ?? '';
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                      itemCount: _rankingData.length,
                      itemBuilder: (context, index) {
                        var user = _rankingData[index];
                        bool isCurrentUser = user['uid'] == _currentUserId;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.green : Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                '${index + 1}º Lugar',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
