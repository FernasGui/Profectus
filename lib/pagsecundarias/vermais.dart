import 'package:flutter/material.dart';
import 'package:profectus/pagsecundarias/pontosituacao.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';

class VerMaisPage extends StatefulWidget {
  @override
  _VerMaisPageState createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage> {
  int _selectedIndex = 0; // Define "Ponto de situação" como selecionado

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
            // Nome e Cargo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Tomás Fernandes',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Trainee',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
                const Icon(Icons.person, size: 60),
              ],
            ),
            const SizedBox(height: 20),

            // Data
          Text(
          'Data: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
            const SizedBox(height: 20),

            // Objetivos Anuais
            const Text(
              'Objetivos Anuais',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Objetivo 1
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

            // Objetivo 2
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

            // Objetivo 3
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Ponto de Situação'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha equipa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
    );
  }

  // Barra de Progresso dos Objetivos
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

  // Detalhes dos Objetivos
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