import 'package:flutter/material.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/principalPage.dart';

class MinhaEquipaPage extends StatefulWidget {
  const MinhaEquipaPage({Key? key}) : super(key: key);

  @override
  _MinhaEquipaPageState createState() => _MinhaEquipaPageState();
}

class _MinhaEquipaPageState extends State<MinhaEquipaPage> {
  int _selectedIndex = 1; // Define "Minha Equipa" como selecionado

  // Navegação pelo BottomNavigationBar
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
        backgroundColor: Color(0xFF358932),
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
            _buildSectionTitle('A Minha Equipa'),
            const SizedBox(height: 20),

            // Projeto 1
            _buildExpandableProject('Projeto 1 - Cliente Jeronymo'),
            const SizedBox(height: 20),

            // Projeto 2
            _buildExpandableProject('Projeto 2 - Cliente BP'),
            const SizedBox(height: 20),

            // Projeto 3
            _buildExpandableProject('Projeto 3 - Cliente Continente'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
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

  // Título da Seção
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Método para criar projetos expansíveis
  Widget _buildExpandableProject(String projectTitle) {
    return ExpansionTile(
      title: Text(
        projectTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
      children: [
        const SizedBox(height: 10),
        _buildExpandableTile('Ponto de Situação'),
        const SizedBox(height: 10),
        _buildExpandableTile('Análise Preditiva'),
      ],
    );
  }

  // Método para criar os botões expansíveis internos
  Widget _buildExpandableTile(String title) {
    return ExpansionTile(
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      children: [
        _buildColaboradoresList(['Colaborador 1', 'Colaborador 2', 'Colaborador 3']),
      ],
    );
  }

  // Lista de colaboradores
  Widget _buildColaboradoresList(List<String> colaboradores) {
    return Column(
      children: colaboradores.map((colaborador) {
        return ListTile(
          title: Text(colaborador),
          trailing: const Icon(Icons.circle, color: Colors.green),
        );
      }).toList(),
    );
  }
}