import 'package:flutter/material.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/principalPage.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int _selectedIndex = 0; // Controla o item selecionado no BottomNavigationBar

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

  // Função para navegar entre as páginas pelo BottomNavigationBar
  void _onItemTapped(int index) {
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
      body: Padding(
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
                  bool isHighlighted = index == 2; // Destacar o 3º lugar
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
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minha Equipa'),
           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
    );
  }
}