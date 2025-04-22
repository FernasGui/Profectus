import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';
import 'package:profectus/principalPage.dart';

class MinhaEquipaPage extends StatefulWidget {
  const MinhaEquipaPage({Key? key}) : super(key: key);

  @override
  _MinhaEquipaPageState createState() => _MinhaEquipaPageState();
}

class _MinhaEquipaPageState extends State<MinhaEquipaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 1;
  bool _hasNotifications = false;
  bool _isLoading = true;
  Map<String, List<String>> _colaboradoresPorObjetivo = {};
  Map<String, String> _situacoesPorObjetivo = {};
  List<String> _objetivosOrdenados = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var notificacoes = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notificacoes')
          .limit(1)
          .get();

      var usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      Map<String, List<String>> tempColaboradores = {};
      Map<String, String> tempSituacoes = {};

      for (var userDoc in usersSnapshot.docs) {
        final nome = userDoc.data()['nome'] ?? 'Colaborador';
        final objetivosSnapshot = await userDoc.reference.collection('objetivos').get();

        for (var objetivoDoc in objetivosSnapshot.docs) {
          final data = objetivoDoc.data();
          final descricao = data['descricao'] ?? '';
          final situacao = data['pontoSituacao'] ?? '';

          if (!tempColaboradores.containsKey(descricao)) {
            tempColaboradores[descricao] = [];
            tempSituacoes[descricao] = situacao;
          }

          if (!tempColaboradores[descricao]!.contains(nome)) {
            tempColaboradores[descricao]!.add(nome);
          }
        }
      }

      setState(() {
        _hasNotifications = notificacoes.docs.isNotEmpty;
        _colaboradoresPorObjetivo = tempColaboradores;
        _situacoesPorObjetivo = tempSituacoes;
        _objetivosOrdenados = tempColaboradores.keys.toList()..sort();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DesafiosPage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PrincipalPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConfiguracaoPage()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MensagensPage()));
                },
              ),
              if (_hasNotifications)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Objetivos da Minha Equipa'),
                  const SizedBox(height: 20),
                  ..._objetivosOrdenados.map((descricao) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        title: Text(descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Colaboradores: ${_colaboradoresPorObjetivo[descricao]?.join(', ') ?? ''}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(_situacoesPorObjetivo[descricao] ?? 'Sem informação'),
                          ),
                        ],
                      ),
                    );
                  }),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF358932),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
