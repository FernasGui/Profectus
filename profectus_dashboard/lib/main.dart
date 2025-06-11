import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProfectusDashboardApp());
}

class ProfectusDashboardApp extends StatelessWidget {
  const ProfectusDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 🔥 remove banner DEBUG
      title: 'Profectus Dashboard Web',
      theme: ThemeData(
        primaryColor: const Color(0xFF358932),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF358932),
          secondary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF358932),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF358932),
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
