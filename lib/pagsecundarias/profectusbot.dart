import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfectusBotPage extends StatefulWidget {
  const ProfectusBotPage({Key? key}) : super(key: key);

  @override
  State<ProfectusBotPage> createState() => _ProfectusBotPageState();
}

class _ProfectusBotPageState extends State<ProfectusBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _objetivosFiltrados = [];
  String? _fase; // null, "objetivo", "continuar"
  bool _loading = false;
  bool _jaMostrouIntro = false;

  @override
  void initState() {
    super.initState();
    _mostrarPerguntaInicial();
  }

  void _mostrarPerguntaInicial() {
    _fase = null;

    final texto = _jaMostrouIntro
        ? "Diz-me o tipo de objetivo que queres discutir e vamos juntos encontrar o melhor caminho! 👇"
        : "Hey! 👋 Pronto para conquistar os teus objetivos? Diz-me o tipo de objetivo que queres discutir e vamos juntos encontrar o melhor caminho! 👇";

    _messages.add({
      "role": "bot",
      "content": texto,
      "buttons": [
        {"label": "Precisa de acelerar", "value": "1"},
        {"label": "Concluído", "value": "2"},
        {"label": "Está num bom caminho", "value": "3"},
      ]
    });

    _jaMostrouIntro = true;
    setState(() {});
  }

  Future<void> _processar(String input) async {
    final inputLower = input.trim().toLowerCase();

    if (_fase == null) {
      final userInput = {
        "1": "Precisa de acelerar",
        "2": "Concluído",
        "3": "Está num bom caminho"
      }[input];

      if (userInput == null) {
        _adicionarMensagemBot("Por favor escolhe 1, 2 ou 3 para continuar.");
        return;
      }

      _messages.add({"role": "user", "content": userInput});
      _loading = true;
      setState(() {});

      String estado = input == "2" ? "Concluído" : "Em Curso";
      String resultado = {
        "1": "Precisa Acelerar",
        "2": "Concluído",
        "3": "Está num bom caminho"
      }[input]!;

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('objetivos')
            .get();

        _objetivosFiltrados = snapshot.docs
            .map((e) => e.data())
            .where((obj) =>
                (obj['estadoAtual'] ?? '').toString().toLowerCase().trim() ==
                    estado.toLowerCase().trim() &&
                (obj['resultado'] ?? '').toString().toLowerCase().trim() ==
                    resultado.toLowerCase().trim())
            .cast<Map<String, dynamic>>()
            .toList();
      }

      if (_objetivosFiltrados.isNotEmpty) {
        _fase = "objetivo";
        String lista = _objetivosFiltrados
            .asMap()
            .entries
            .map((e) => "(${e.key + 1}) ${e.value['descricao']}")
            .join("\n");

        _adicionarMensagemBot("Escolhe um objetivo para recomendações:\n$lista");
      } else {
        _adicionarMensagemBot("Não encontrei objetivos nessa situação. Tenta outra opção!");
        _mostrarPerguntaInicial();
      }

      _loading = false;
      setState(() {});
      return;
    }

    if (_fase == "objetivo") {
      int index = int.tryParse(input) ?? -1;
      if (index >= 1 && index <= _objetivosFiltrados.length) {
        final obj = _objetivosFiltrados[index - 1];
        final descricao = obj['descricao'];
        final resultado = (obj['resultado'] ?? '').toString().toLowerCase();

        String resposta;
        if (resultado.contains("concluído")) {
          resposta =
              'Parabéns por concluir "$descricao"! 🎉 Considera partilhar boas práticas com colegas.';
        } else if (resultado.contains("precisa")) {
          resposta =
              'Para "$descricao", tenta rever prioridades, pedir apoio ao teu líder e definir prazos claros.';
        } else {
          resposta =
              'Estás no bom caminho com "$descricao"! Mantém o foco e continua a acompanhar o progresso.';
        }

        _messages.add({"role": "user", "content": input});
        _adicionarMensagemBot(resposta);
        _fase = "continuar";
        _adicionarMensagemBot("Precisas de ajuda com outro objetivo? (sim / não)");
      } else {
        _adicionarMensagemBot("Escolhe um número válido da lista de objetivos.");
      }

      setState(() {});
      return;
    }

    if (_fase == "continuar") {
      final normalized = input.toLowerCase().replaceAll("ã", "a").replaceAll("á", "a");
      _messages.add({"role": "user", "content": input});

      if (["sim", "s"].contains(normalized)) {
        _mostrarPerguntaInicial();
      } else if (["nao", "n"].contains(normalized)) {
        _adicionarMensagemBot("Tudo bem! Sempre que precisares, estarei por aqui. 💬");
        _fase = "fim";
      } else {
        _adicionarMensagemBot("Por favor responde com 'sim' ou 'não'.");
      }

      setState(() {});
    }
  }

  void _adicionarMensagemBot(String texto) {
    _messages.add({"role": "bot", "content": texto});
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    final content = msg['content'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF358932),
              backgroundImage: AssetImage('imagens/bot.png'),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF358932) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (!isUser && msg['buttons'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: List<Widget>.from(
                        msg['buttons'].map<Widget>((btn) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF358932),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => _processar(btn['value']),
                            child: Text(btn['label']),
                          );
                        }),
                      ),
                    ),
                  ),
              ],
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
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
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
                    controller: _controller,
                    onSubmitted: (text) {
                      if (!_loading) {
                        _processar(text.trim());
                        _controller.clear();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Escreve a tua resposta...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                          _processar(_controller.text.trim());
                          _controller.clear();
                        },
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
