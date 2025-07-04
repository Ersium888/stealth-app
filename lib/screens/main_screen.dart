import 'package:flutter/material.dart';
import 'move_screen.dart';
import 'snap_screen.dart';
import 'discover_screen.dart';
import 'me_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to the first tab (Move)

  // List of widgets to call on navigation item press.
  static const List<Widget> _widgetOptions = <Widget>[
    MoveScreen(),
    SnapScreen(),
    DiscoverScreen(),
    MeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Using theme defined in main.dart for BottomNavigationBar
    // final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_filled_outlined), // Example icon for Move
            activeIcon: Icon(Icons.directions_car_filled),
            label: 'Move',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined), // Example icon for Snap
            activeIcon: Icon(Icons.camera_alt),
            label: 'Snap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), // Example icon for Discover
            activeIcon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Example icon for Me
            activeIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor is handled by BottomNavigationBarTheme in main.dart
        // unselectedItemColor is handled by BottomNavigationBarTheme in main.dart
        // type: BottomNavigationBarType.fixed, // Also handled by theme
        onTap: _onItemTapped,
        // backgroundColor: theme.bottomNavigationBarTheme.backgroundColor, // Handled by theme
        // elevation: theme.bottomNavigationBarTheme.elevation, // Handled by theme
      ),
    );
  }
}
