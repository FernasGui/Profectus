import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // TEMPORARIAMENTE comentado
import 'package:profectus/firebase_options.dart';
import 'package:profectus/beginPage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env"); // <--- desativado temporariamente
  // print('Chave OpenAI: ${dotenv.env['OPENAI_API_KEY']}'); // <--- também comentado

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  primaryColor: Color(0xFF358932),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Color(0xFF358932),
    secondary: Color(0xFF66CC99), // ou outro tom verde que uses
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF083366)),
    bodyMedium: TextStyle(color: Color(0xFF666666)),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF358932),
    foregroundColor: Colors.white,
  ),
),

      navigatorKey: navigatorKey,
      home: SplashScreen(),
    );
  }
}
