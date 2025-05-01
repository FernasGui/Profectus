import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profectus/pagsecundarias/notificacoes.dart';

class MinhaEquipaPage extends StatefulWidget {
  const MinhaEquipaPage({Key? key}) : super(key: key);

  @override
  _MinhaEquipaPageState createState() => _MinhaEquipaPageState();
}

class _MinhaEquipaPageState extends State<MinhaEquipaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _hasNotifications = false;
  List<Map<String, dynamic>> _meusProjetos = [];
  String? _userNome;
  String? _userCargo;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final nome = userDoc.data()?['nome'] ?? 'Sem Nome';
    final cargo = userDoc.data()?['cargo'] ?? 'Colaborador';

    final projetosSnapshot =
        await FirebaseFirestore.instance.collection('projetos').get();
    final notificacoes = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notificacoes')
        .limit(1)
        .get();

    List<Map<String, dynamic>> projetosUser = [];

    for (var doc in projetosSnapshot.docs) {
      final data = doc.data();
      final equipa = List.from(data['equipa'] ?? []);
      final equipaIds = equipa.map((e) => e.toString()).toList();

      if (equipaIds.contains(user.uid)) {
        List<Map<String, dynamic>> membrosDetalhes = [];

        for (var membroId in equipaIds) {
          if (membroId == user.uid) continue; // Ignorar chefe na lista

          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(membroId)
              .get();
          final nome = userDoc.data()?['nome'] ?? 'Sem Nome';

          final objetivosSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(membroId)
              .collection('objetivos')
              .get();

          final objetivos =
              objetivosSnapshot.docs.map((d) => d.data()).toList();

          int total = objetivos.length;
          int positivos = objetivos.where((o) {
            final r = (o['resultado'] ?? '').toString().toLowerCase();
            return r.contains('concluído') ||
                r.contains('concluido') ||
                r.contains('bom caminho');
          }).length;

          final cor =
              (total > 0 && (positivos / total) >= 0.51) ? Colors.green : Colors.amber;

          membrosDetalhes.add({
            "nome": nome,
            "cor": cor,
          });
        }

        projetosUser.add({
          "nomeProjeto": data['nome'] ?? 'Projeto Sem Nome',
          "membros": membrosDetalhes,
        });
      }
    }

    setState(() {
      _hasNotifications = notificacoes.docs.isNotEmpty;
      _meusProjetos = projetosUser;
      _userNome = nome;
      _userCargo = cargo;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF358932),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('imagens/jmbranco.png', height: 40),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MensagensPage()),
                  );
                },
              ),
              if (_hasNotifications)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _meusProjetos.length,
              itemBuilder: (context, i) {
                final projeto = _meusProjetos[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_userCargo: $_userNome',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ExpansionTile(
                        title: Text(projeto['nomeProjeto'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        children: projeto['membros'].map<Widget>((membro) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: membro['cor'],
                              radius: 8,
                            ),
                            title: Text(membro['nome']),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
