import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfectusBotPage extends StatefulWidget {
  const ProfectusBotPage({Key? key}) : super(key: key);

  @override
  State<ProfectusBotPage> createState() => _ProfectusBotPageState();
}

class _ProfectusBotPageState extends State<ProfectusBotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  String? _fase;
  List<Map<String, dynamic>> _objetivosFiltrados = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _enviarMensagemInicial();
  }

  void _enviarMensagemInicial() {
    _messages.add({
      "role": "bot",
      "content":
          "Olá! Em que situação te encontras?\n🟩 1️⃣ Em curso e precisa de acelerar\n🟩 2️⃣ Concluído\n🟩 3️⃣ Em curso e está num bom caminho\nResponde com 1, 2 ou 3."
    });
    setState(() {});
  }

  Future<void> _processarResposta(String input) async {
    if (_fase == null) {
      if (input == '1' || input == '2' || input == '3') {
        String estado = '';
        String resultado = '';

        switch (input) {
          case '1':
            estado = 'Em Curso';
            resultado = 'Precisa de acelerar';
            break;
          case '2':
            estado = 'Concluído';
            resultado = 'Concluído';
            break;
          case '3':
            estado = 'Em Curso';
            resultado = 'Está num bom caminho';
            break;
        }

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('objetivos')
              .where('estadoAtual', isEqualTo: estado)
              .where('resultado', isEqualTo: resultado)
              .get();

          _objetivosFiltrados = snapshot.docs
              .map((doc) => doc.data())
              .toList()
              .cast<Map<String, dynamic>>();

          if (_objetivosFiltrados.isNotEmpty) {
            _fase = input;
            String lista = _objetivosFiltrados
                .asMap()
                .entries
                .map((e) => "(${e.key + 1}) ${e.value['descricao']}")
                .join('\n');

            _messages.add({
              "role": "bot",
              "content": "Escolhe um objetivo para recomendações:\n$lista"
            });
          } else {
            _messages.add({
              "role": "bot",
              "content": "Não encontrei objetivos nessa situação. Tenta outra opção!"
            });
          }
        }
      } else {
        _messages.add({
          "role": "bot",
          "content": "Por favor responde apenas com 1, 2 ou 3 para escolher a situação."
        });
      }
    } else {
      int index = int.tryParse(input) ?? 0;
      if (index > 0 && index <= _objetivosFiltrados.length) {
        String objetivo = _objetivosFiltrados[index - 1]['descricao'];
        String resultado = _objetivosFiltrados[index - 1]['resultado'];

        String recomendacao;
        if (resultado.toLowerCase().contains('concluído')) {
          recomendacao =
              'Parabéns por concluir "$objetivo"! Considera partilhar boas práticas com colegas.';
        } else if (resultado.toLowerCase().contains('precisa')) {
          recomendacao =
              'Para o objetivo "$objetivo", tenta reorganizar prioridades e pedir feedback ao teu líder.';
        } else {
          recomendacao =
              'Estás no bom caminho com "$objetivo"! Mantém o foco e ajusta quando necessário.';
        }

        _messages.add({"role": "bot", "content": recomendacao});
        _fase = null; // reiniciar para nova pergunta
        _enviarMensagemInicial(); // perguntar de novo
      } else {
        _messages.add({
          "role": "bot",
          "content": "Escolhe um número válido da lista de objetivos."
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void _enviarMensagem() {
    final input = _textController.text.trim();
    if (input.isEmpty) return;

    _messages.add({"role": "user", "content": input});
    _textController.clear();
    _loading = true;
    setState(() {});

    _processarResposta(input);
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['role'] == 'user';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              backgroundColor: Color(0xFF358932),
              child: Icon(Icons.android, color: Colors.white),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF358932) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message['content'],
                style: TextStyle(
                    color: isUser ? Colors.white : Colors.black, fontSize: 15),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Color(0xFF358932),
              child: Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfectusBot'),
        backgroundColor: const Color(0xFF358932),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessage(_messages[index]),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Escreve a tua resposta...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _enviarMensagem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF358932),
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
