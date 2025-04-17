import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/mensagens.dart';

class VerMaisPage extends StatefulWidget {
  @override
  _VerMaisPageState createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  String _userName = '';
  String _userCargo = '';
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

          setState(() {
            _userName = userData['nome'] ?? 'Sem nome';
            _userCargo = userData['cargo'] ?? 'Sem cargo'; // <-- Adicionado
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = 'Sem nome';
            _userCargo = 'Sem cargo'; // <-- Adicionado
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Erro ao buscar nome/cargo: $e');
        setState(() {
          _userName = 'Erro ao carregar';
          _userCargo = 'Erro ao carregar'; // <-- Adicionado
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DesafiosPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MinhaEquipaPage()),
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
            Image.asset('imagens/jmbranco.png', height: 40),
          ],
        ),
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
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
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
                          Text(
                            _userName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _userCargo, // <-- Aqui vai agora buscar o cargo certo
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Icon(Icons.person, size: 60),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Data: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Objetivos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildObjectiveProgress('Objetivo 1', 0.9),
                  const SizedBox(height: 10),
                  _buildObjectiveDetails(
                    'Objetivo 1 - 10 contratos com novos clientes',
                    'Falta apenas 1 contrato para atingir a sua meta anual!',
                    'Está a ',
                    '10%',
                    ' de atingir o seu objetivo anual. O ideal seria estar a ',
                    '0%',
                    ' nesta altura do ano. Mas não desanime, o nosso ',
                    'chatbot',
                    ' pode ajudar!',
                    Colors.yellow,
                  ),
                  const SizedBox(height: 20),
                  _buildObjectiveProgress('Objetivo 2', 0.8),
                  const SizedBox(height: 10),
                  _buildObjectiveDetails(
                    'Objetivo 2 - Participar em 15 eventos de promoção da marca',
                    'Faltam 3 eventos para atingir a sua meta anual!',
                    'Está a ',
                    '20%',
                    ' de atingir o seu objetivo anual.',
                    '',
                    '',
                    '',
                    '',
                    Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  _buildObjectiveProgress('Objetivo 3', 0.5),
                  const SizedBox(height: 10),
                  _buildObjectiveDetails(
                    'Objetivo 3 - Melhorar o desempenho da equipa',
                    'Faltam algumas metas para serem atingidas!',
                    'Está a ',
                    '50%',
                    ' de atingir o seu objetivo anual.',
                    '',
                    '',
                    '',
                    '',
                    Colors.red,
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Desafios'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha equipa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
    );
  }

  Widget _buildObjectiveProgress(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          color: const Color(0xFF358932),
          minHeight: 10,
        ),
      ],
    );
  }

  Widget _buildObjectiveDetails(
    String title,
    String description,
    String prefix,
    String highlight,
    String suffix,
    String prefix2,
    String highlight2,
    String suffix2,
    String highlight3,
    Color highlightColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(fontSize: 14, color: Colors.white)),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: prefix, style: const TextStyle(color: Colors.white)),
                TextSpan(
                  text: highlight,
                  style: TextStyle(color: highlightColor, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: suffix, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
