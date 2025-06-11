import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard.dart';

class PainelGeralPage extends StatefulWidget {
  const PainelGeralPage({super.key});

  @override
  State<PainelGeralPage> createState() => _PainelGeralPageState();
}

class _PainelGeralPageState extends State<PainelGeralPage> {
  int concluidos = 0;
  int bomCaminho = 0;
  int atrasados = 0;
  int totalColaboradores = 0;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      int c = 0, b = 0, a = 0, total = 0;

      for (var user in usersSnapshot.docs) {
        final objetivos = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('objetivos')
            .get();

        if (objetivos.docs.isEmpty) continue;

        total++;

        for (var obj in objetivos.docs) {
          final resultado = (obj['resultado'] ?? '').toString().toLowerCase();
          if (resultado.contains('concluído') || resultado.contains('concluido')) {
            c++;
          } else if (resultado.contains('bom caminho')) {
            b++;
          } else if (resultado.contains('precisa')) {
            a++;
          }
        }
      }

      setState(() {
        concluidos = c;
        bomCaminho = b;
        atrasados = a;
        totalColaboradores = total;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = concluidos + bomCaminho + atrasados;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Geral"),
        backgroundColor: const Color(0xFF358932),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFD9EFE0),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildKpiCard("Colaboradores com dados", "$totalColaboradores"),
                _buildKpiCard("Total objetivos", "$total"),
                _buildKpiCard("Concluídos", "$concluidos"),
                _buildKpiCard("Bom caminho", "$bomCaminho"),
                _buildKpiCard("Atrasados", "$atrasados"),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Distribuição de Objetivos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 50,
                      sections: [
                        PieChartSectionData(
                          value: concluidos.toDouble(),
                          color: Colors.green,
                          title: 'Concluídos\n$concluidos',
                          titleStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: bomCaminho.toDouble(),
                          color: Colors.yellow,
                          title: 'Bom Caminho\n$bomCaminho',
                          titleStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: atrasados.toDouble(),
                          color: Colors.red,
                          title: 'Atrasados\n$atrasados',
                          titleStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  width: 300,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text("Concluídos", style: TextStyle(color: Colors.black, fontSize: 12));
                                case 1:
                                  return const Text("Bom Caminho", style: TextStyle(color: Colors.black, fontSize: 12));
                                case 2:
                                  return const Text("Atrasados", style: TextStyle(color: Colors.black, fontSize: 12));
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      maxY: total > 0 ? total.toDouble() : 10,
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: concluidos.toDouble(), color: Colors.green)]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: bomCaminho.toDouble(), color: Colors.yellow)]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: atrasados.toDouble(), color: Colors.red)]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}
