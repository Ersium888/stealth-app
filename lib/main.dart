import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import the options file
import 'routing.dart';
import 'screens/main_screen.dart';

void main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp( // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
