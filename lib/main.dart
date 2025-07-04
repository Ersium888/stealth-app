import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // We will create this next

void main() {
  // It's good practice to ensure Flutter bindings are initialized,
  // especially before running async operations or Firebase.
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Assuming Firebase init will be handled here or just before runApp by ChatGPT/user
  runApp(const SwiftTaskerApp());
}

class SwiftTaskerApp extends StatelessWidget {
  const SwiftTaskerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftTasker', // As per ChatGPT's update
      debugShowCheckedModeBanner: false, // Cleaner for demos
      theme: ThemeData(
        // Define a professional and somewhat neutral color scheme
        primarySwatch: Colors.blueGrey, // A muted primary color
        scaffoldBackgroundColor: Colors.grey[50], // Very light grey for background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          elevation: 0, // Flat app bars
          iconTheme: IconThemeData(color: Colors.grey[800]),
          titleTextStyle: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueGrey[700],
          unselectedItemColor: Colors.grey[500],
          elevation: 8.0, // Standard elevation
          type: BottomNavigationBarType.fixed, // Ensures all labels are visible
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
        // Define text field theme for a modern look
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none, // No border by default, rely on fill and shadow
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueGrey[500]!, width: 1.5),
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        // Define button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
          ),
        ),
        // Define card theme
        cardTheme: CardTheme(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.grey[200]!, width: 1.0)
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0), // Default card margin
        ),
        // Define Text Theme
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800]), // For main titles
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey[800]), // For screen titles
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[700]),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[600]),
          labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), // For button text
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.teal[400], // A contrasting accent color
          backgroundColor: Colors.grey[50],
          cardColor: Colors.white,
          errorColor: Colors.red[600],
        ).copyWith(
            surface: Colors.white, // Surfaces like cards, dialogs
            onSurface: Colors.grey[800] // Text on surfaces
        ),
      ),
      home: const MainScreen(), // This will be our main navigation hub
    );
  }
}
