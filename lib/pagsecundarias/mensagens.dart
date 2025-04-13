import 'package:flutter/material.dart';
import 'package:profectus/pagsecundarias/desafios.dart';
import 'package:profectus/pagsecundarias/minhaequipa.dart';
import 'package:profectus/pagsecundarias/configuracao.dart';
import 'package:profectus/principalPage.dart';

class MensagensPage extends StatefulWidget {
  const MensagensPage({Key? key}) : super(key: key);

  @override
  _MensagensPageState createState() => _MensagensPageState();
}

class _MensagensPageState extends State<MensagensPage> {

  final List<Map<String, dynamic>> mensagens = [
    {'nome': 'Avaliação Submetida', 'texto': 'Olá! A tua avaliação a "Ricardo Alves" foi recebida com sucesso.', 'lida': false},
    {'nome': 'Parabéns!', 'texto': 'Subiste ao 3º lugar no Ranking Mensal. Continua assim!', 'lida': false},
    {'nome': 'Época de Avaliações', 'texto': 'O prazo final para submeteres as tuas avaliações está quase a terminar.', 'lida': true},
    {'nome': 'Ranking Mensal Março', 'texto': 'Consulta aqui os resultados do mês de março e a tua posição!', 'lida': true},
    {'nome': 'Ponto de situação', 'texto': 'Confere o teu ponto de situação atual relativamente aos objetivos definidos em Janeiro.', 'lida': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Center(
                child: Image.asset('imagens/jmbranco.png', height: 40),
              ),
            ),
            Image.asset('imagens/logo_profectus.png', height: 40),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mensagens.length,
        itemBuilder: (context, index) {
          return Card(
            color: mensagens[index]['lida'] ? Colors.white : Colors.grey[200],
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                mensagens[index]['nome'],
                style: TextStyle(
                  fontWeight: mensagens[index]['lida'] ? FontWeight.normal : FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                mensagens[index]['texto'],
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // Aqui podes abrir a conversa detalhada futuramente
              },
            ),
          );
        },
      ),
    );
  }
}