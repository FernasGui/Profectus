import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';

class FeedbackRecebidoPage extends StatefulWidget {
  const FeedbackRecebidoPage({Key? key}) : super(key: key);

  @override
  State<FeedbackRecebidoPage> createState() => _FeedbackRecebidoPageState();
}

class _FeedbackRecebidoPageState extends State<FeedbackRecebidoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;
  bool _hasNotifications = false;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _carregarUtilizador();
  }

  Future<void> _carregarUtilizador() async {
    final user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      final notificacoes = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('notificacoes')
          .limit(1)
          .get();

      setState(() {
        _hasNotifications = notificacoes.docs.isNotEmpty;
        _loadingUser = false;
      });
    }
  }

  Future<String> _buscarNome(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['nome'] ?? 'Anónimo';
      }
    } catch (e) {
      // erro ao obter nome
    }
    return 'Anónimo';
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser || _userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: const Text('Feedback Recebido'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MensagensPage()));
                },
              ),
              if (_hasNotifications)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .collection('feedbackrecebido')
            .orderBy('dataHora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feedbacks = snapshot.data!.docs;

          if (feedbacks.isEmpty) {
            return const Center(child: Text('Sem feedback recebido.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final data = feedbacks[index].data() as Map<String, dynamic>;
              final uid = data['uid'] ?? '';
              final dataHora = data['dataHora'] ?? '';
              final texto = data['mensagem'] ?? '';

              return FutureBuilder<String>(
                future: _buscarNome(uid),
                builder: (context, snapshot) {
                  final nome = snapshot.data ?? 'Anónimo';

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
                            nome,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            dataHora,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          texto,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
