import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:profectus/firebase_options.dart'; // Certifique-se de gerar este arquivo com o comando "flutterfire configure".
import 'beginPage.dart'; // Substitua pelo caminho correto da sua página inicial.



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Se estiver usando o App Check, ative-o aqui.
await FirebaseAppCheck.instance.activate();
  
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profectus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Configuração de cores principais e secundárias
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo, // Substitua por sua cor primária
          accentColor: const Color(0xFF66CC99), // Cor de destaque
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Fundo claro
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Color(0xFF003366)), // Texto principal
          bodyText2: TextStyle(color: Color(0xFF666666)), // Texto secundário
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366), // Cor da AppBar
          foregroundColor: Colors.white, // Cor do texto da AppBar
        ),
      ),
      navigatorKey: navigatorKey,
      home: SplashScreen(), // Tela inicial (substitua por `beginPage` ou outra página inicial)
    );
  }
}
