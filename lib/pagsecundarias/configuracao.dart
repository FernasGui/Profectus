import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/autenticacao/loginPage.dart';
import 'package:profectus/pagsecundarias/pontosituacao.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/principalPage.dart';

class ConfiguracaoPage extends StatefulWidget {
  @override
  _ConfiguracaoPageState createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 2; // Inicializado corretamente

  // Navegação pelo BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PontoSituacaoPage()),
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
    MaterialPageRoute(builder: (context) => MinhaEquipaPage()),
  );
        break;
    }
  }

  String _userName = 'Utilizador Anônimo';
  String _userEmail = 'No Email';
  String _anoEntrada = 'Desconhecido';
  String _area = 'Desconhecido';
  String _departamento = 'Desconhecido';
  String _chefe = 'Desconhecido';

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
          _anoEntrada = userData?['anoEntrada'] ?? 'Desconhecido';
          _area = userData?['area'] ?? 'Desconhecido';
          _departamento = userData?['departamento'] ?? 'Desconhecido';
          _chefe = userData?['chefe'] ?? 'Desconhecido';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('imagens/jmbranco.png', height: 40),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Foto de Perfil
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 10),

            // Nome do Utilizador
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // E-mail
            Text(
              _userEmail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),

            // Informações Pessoais
            _buildInfoTile(Icons.date_range, 'Ano de Entrada', _anoEntrada),
            _buildInfoTile(Icons.business_center, 'Área', _area),
            _buildInfoTile(Icons.apartment, 'Departamento', _departamento),
            _buildInfoTile(Icons.supervisor_account, 'Chefe Direto', _chefe),

            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Botão para Editar Perfil
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                // Ação para editar perfil
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Editar Perfil',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const SizedBox(height: 10),

            // Botão de Logout
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Terminar Sessão',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Ponto de situação'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha equipa'),
        ],
      ),
    );
  }

  // Widget para apresentar informações
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    );
  }
}