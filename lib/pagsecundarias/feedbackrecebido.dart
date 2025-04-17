import 'package:flutter/material.dart';

class FeedbackRecebidoPage extends StatelessWidget {
  const FeedbackRecebidoPage({Key? key}) : super(key: key);

  // Lista de feedbacks recebidos
  final List<Map<String, String>> feedbacksRecebidos = const [
    {
      'nome': 'João Silva',
      'data': '12/04/2025',
      'categoria': 'Comunicação',
      'texto': 'Excelente forma de comunicar a visão do projeto para a equipa.'
    },
    {
      'nome': 'Maria Lopes',
      'data': '10/04/2025',
      'categoria': 'Trabalho em Equipa',
      'texto': 'Colaborou eficazmente e contribuiu para o sucesso coletivo.'
    },
    {
      'nome': 'Carlos Pinto',
      'data': '05/04/2025',
      'categoria': 'Iniciativa',
      'texto': 'Demonstrou grande proatividade na resolução de problemas.'
    },
    {
      'nome': 'Sofia Costa',
      'data': '03/04/2025',
      'categoria': 'Responsabilidade',
      'texto': 'Assumiu responsabilidades importantes e entregou resultados com qualidade.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: const Text('Feedback Recebido'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: feedbacksRecebidos.length,
        itemBuilder: (context, index) {
          final feedback = feedbacksRecebidos[index];
          return Card(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    feedback['nome']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    feedback['data']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF358932),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      feedback['categoria']!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback['texto']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              trailing: const Icon(Icons.add, color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}