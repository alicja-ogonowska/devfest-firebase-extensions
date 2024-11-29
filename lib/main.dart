import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fir_extensions_demo/firebase_options.dart';
import 'package:fir_extensions_demo/ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Firebase Extensions Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5e7a6b)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
