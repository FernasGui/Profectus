import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('imagens/logo_profectus.png', height: 30),
            const SizedBox(width: 10),
            const Text(
              'Jerónimo Martins',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          List<String> posicoes = [
            '1º Lugar',
            '2º Lugar',
            '3º Lugar',
            '4º Lugar',
            '5º Lugar',
            '6º Lugar',
            '7º Lugar',
            '8º Lugar',
          ];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(posicoes[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}
