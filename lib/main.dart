import 'package:flutter/material.dart';
import 'routing.dart'; // Import for appRoutes
import 'screens/main_screen.dart'; // Import for MainScreen as home

void main() {
  // As per ChatGPT's instructions, Firebase init is not here yet.
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const SwiftTaskerApp());
}

class SwiftTaskerApp extends StatelessWidget {
  const SwiftTaskerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftTasker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), // Theme specified by ChatGPT
        useMaterial3: true, // useMaterial3 enabled as per ChatGPT
      ),
      home: const MainScreen(), // MainScreen as home
      debugShowCheckedModeBanner: false, // As per ChatGPT
      routes: appRoutes, // Centralised route map from routing.dart
    );
  }
}
