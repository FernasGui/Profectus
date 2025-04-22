import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';

class AnalisePreditivaPage extends StatefulWidget {
  const AnalisePreditivaPage({Key? key}) : super(key: key);

  @override
  State<AnalisePreditivaPage> createState() => _AnalisePreditivaPageState();
}

class _AnalisePreditivaPageState extends State<AnalisePreditivaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;
  bool _hasNotifications = false;
  bool _loading = true;

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
        _loading = false;
      });
    }
  }

  Color _getCorEstado(String estado) {
    switch (estado) {
      case 'Concluído':
        return Colors.green;
      case 'Precisa Acelerar':
        return Colors.orange.shade700;
      case 'Está num bom caminho':
      default:
        return Colors.blue;
    }
  }

  IconData _getIconEstado(String estado) {
    switch (estado) {
      case 'Concluído':
        return Icons.check_circle;
      case 'Precisa Acelerar':
        return Icons.warning_amber_rounded;
      default:
        return Icons.trending_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        title: const Text('Análise Preditiva'),
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
            .collection('objetivos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final objetivos = snapshot.data!.docs;

          if (objetivos.isEmpty) {
            return const Center(child: Text('Nenhum objetivo disponível.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: objetivos.length,
            itemBuilder: (context, index) {
              final data = objetivos[index].data() as Map<String, dynamic>;
              final titulo = data['descricao'] ?? 'Sem descrição';
              final estado = data['resultado'] ?? 'Sem estado';

              final corEstado = _getCorEstado(estado);
              final iconeEstado = _getIconEstado(estado);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(iconeEstado, color: corEstado, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              estado,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: corEstado,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        titulo,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black87),
                      ),
                      if (estado == 'Precisa Acelerar')
                        const Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(
                            'Consulte o ProfectusBot para dicas de melhoria.',
                            style: TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}