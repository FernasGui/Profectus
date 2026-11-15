import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'login_page.dart';
import 'painel_geral.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> projetos = [];
  bool isLoading = true;
  String? userId;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    userEmail = user?.email;
    carregarProjetos();
  }

  void carregarProjetos() async {
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance.collection('projetos').get();
      List<Map<String, dynamic>> lista = [];

      int i = 0;
      for (var doc in snapshot.docs) {
        final equipa = doc['equipa'] ?? [];
        if (equipa.contains(userId)) {
          final dados = gerarDadosEstatisticos(i);
          lista.add({
            'id': doc.id,
            'nome': doc['nome'] ?? 'Sem nome',
            ...dados,
          });
          i++;
        }
      }

      setState(() {
        projetos = lista;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar projetos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> gerarDadosEstatisticos(int index) {
    final simulados = [
      {
        'ativos': 128,
        'tempo': '6 min 24 s',
        'paginas': 'Chat com Bot, Objetivos, Feedback',
        'pontuacao': '4.6 / 5 ☆',
        'erros': 3,
        'ticketsAbertos': 5,
        'ticketsResolvidos': 12,
      },
      {
        'ativos': 87,
        'tempo': '4 min 12 s',
        'paginas': 'Feedback, Chat com Bot',
        'pontuacao': '4.2 / 5 ☆',
        'erros': 1,
        'ticketsAbertos': 3,
        'ticketsResolvidos': 9,
      },
      {
        'ativos': 103,
        'tempo': '5 min 45 s',
        'paginas': 'Objetivos, Perfil',
        'pontuacao': '4.8 / 5 ☆',
        'erros': 2,
        'ticketsAbertos': 2,
        'ticketsResolvidos': 15,
      },
      {
        'ativos': 66,
        'tempo': '3 min 58 s',
        'paginas': 'Dashboard, Feedback',
        'pontuacao': '4.3 / 5 ☆',
        'erros': 4,
        'ticketsAbertos': 6,
        'ticketsResolvidos': 8,
      }
    ];

    return simulados[index % simulados.length];
  }

  Widget _buildKpiCard(String label, String value, Color color, IconData icon) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

 Widget _buildBarChart(int ativos, int erros, int tickets) {
  final double maxValor = [ativos.toDouble(), erros.toDouble(), tickets.toDouble()].reduce((a, b) => a > b ? a : b);
  final double maxY = (maxValor < 10) ? 10 : (maxValor + 10).ceilToDouble();
  final double interval = (maxY / 5).ceilToDouble();

  return SizedBox(
    height: 200,
    child: BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: ativos.toDouble(), width: 16, color: Colors.green)
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: erros.toDouble(), width: 16, color: Colors.red)
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: tickets.toDouble(), width: 16, color: Colors.blue)
          ]),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: interval),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0: return const Text('Ativos', style: TextStyle(fontSize: 12));
                  case 1: return const Text('Erros', style: TextStyle(fontSize: 12));
                  case 2: return const Text('Tickets', style: TextStyle(fontSize: 12));
                  default: return const SizedBox.shrink();
                }
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF358932),
        title: Text(userEmail != null ? 'Projetos – $userEmail' : 'Projetos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PainelGeralPage()));
              },
              icon: const Icon(Icons.dashboard_customize, size: 18),
              label: const Text("Painel Geral"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C7A4F),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: projetos.map((p) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width >= 1000 ? MediaQuery.of(context).size.width / 2 - 32 : double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['nome'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildKpiCard("Ativos", p['ativos'].toString(), Colors.green, Icons.groups),
                                _buildKpiCard("Tempo médio", p['tempo'], Colors.blueGrey, Icons.timer),
                                _buildKpiCard("Top Páginas", p['paginas'], Colors.deepPurple, Icons.bar_chart),
                                _buildKpiCard("Pontuação", p['pontuacao'], Colors.orange, Icons.star),
                                _buildKpiCard("Erros", "${p['erros']} esta semana", Colors.red, Icons.error),
                                _buildKpiCard("Tickets", "${p['ticketsAbertos']} abertos / ${p['ticketsResolvidos']} resolvidos", Colors.blue, Icons.support_agent),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildBarChart(p['ativos'], p['erros'], p['ticketsAbertos']),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
