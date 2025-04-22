import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';

class VerMaisPage extends StatefulWidget {
  @override
  _VerMaisPageState createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = '';
  String _userCargo = '';
  bool _isLoading = true;
  int _selectedIndex = 0;
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
          _userName = userData['nome'] ?? 'Sem nome';
          _userCargo = userData['cargo'] ?? 'Sem cargo';
          await _getObjetivos(user.uid);
        }
      } catch (e) {
        _userName = 'Erro ao carregar';
        _userCargo = 'Erro ao carregar';
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getObjetivos(String userId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('objetivos')
          .get();

      var objetivos = snapshot.docs.map((doc) => doc.data()).toList();

      objetivos.sort((a, b) {
        final aNumero = a['numero'] ?? 0;
        final bNumero = b['numero'] ?? 0;
        return aNumero.compareTo(bNumero);
      });

      setState(() {
        _objetivos = objetivos;
      });
    } catch (e) {
      print('Erro ao carregar objetivos: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_userCargo == 'Trainee') {
      if (index == 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DesafiosPage()));
      } else if (index == 1) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfiguracaoPage()));
      }
    } else {
      switch (index) {
        case 0:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DesafiosPage()));
          break;
        case 1:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MinhaEquipaPage()));
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
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MensagensPage())),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text(' ', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(_userCargo, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                      const Icon(Icons.person, size: 60),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Data: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),
                  const Text('Objetivos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ..._objetivos.map((obj) {
                    final numero = obj['numero'] ?? '—';
                    final descricao = obj['descricao'] ?? '';
                    final progressoRelativo = (obj['progressoRelativo'] ?? 0.0) * 100;
                    final dataLimite = (obj['dataLimite'] as Timestamp).toDate();
                    final percentagem = (progressoRelativo / 100).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Objetivo $numero: $descricao', style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: percentagem,
                            backgroundColor: const Color(0xFFBDBDBD),
                            color: const Color(0xFF358932),
                            minHeight: 6,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  descricao,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text('Progresso: ${progressoRelativo.toStringAsFixed(0)}% | Data limite: ${dataLimite.day}/${dataLimite.month}/${dataLimite.year}',
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
}
