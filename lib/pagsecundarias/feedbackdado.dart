import 'package:flutter/material.dart';

class FeedbackDadoPage extends StatelessWidget {
  const FeedbackDadoPage({Key? key}) : super(key: key);

  // Lista de feedbacks enviados
  final List<Map<String, String>> feedbacksEnviados = const [
    {
      'nome': 'Ana Pereira',
      'data': '15/04/2025',
      'categoria': 'Liderança',
      'texto': 'Reconhecimento pela liderança inspiradora durante o projeto.'
    },
    {
      'nome': 'Bruno Matos',
      'data': '15/04/2025',
      'categoria': 'Criatividade',
      'texto': 'Excelentes ideias criativas aplicadas nos desafios recentes.'
    },
    {
      'nome': 'Sofia Costa',
      'data': '15/04/2025',
      'categoria': 'Colaboração',
      'texto': 'Contribuiu significativamente para o trabalho em equipa e para o meu crescimento profissional.'
    },
    {
      'nome': 'Carlos Pinto',
      'data': '15/04/2025',
      'categoria': 'Responsabilidade',
      'texto': 'Demonstrou elevado grau de responsabilidade nas tarefas atribuídas.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: const Text('Feedback Dado'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: feedbacksEnviados.length,
        itemBuilder: (context, index) {
          final feedback = feedbacksEnviados[index];
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
