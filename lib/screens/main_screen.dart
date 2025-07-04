import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart'; // Import LucideIcons
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
    // The theme (including BottomNavigationBarTheme) is now primarily driven by Material 3 defaults
    // and ColorScheme.fromSeed in main.dart.
    // Specific overrides in main.dart's theme will also apply if any were kept for BottomNavigationBar.

    return Scaffold(
      body: IndexedStack( // Use IndexedStack to keep state of inactive screens
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: NavigationBar( // Using Material 3 NavigationBar
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        // backgroundColor: Theme.of(context).colorScheme.surface, // M3 NavigationBar usually takes this from theme
        // indicatorColor: Theme.of(context).colorScheme.secondaryContainer, // M3 indicator color
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(LucideIcons.siren), // Placeholder, using a distinct Lucide icon for Move
            selectedIcon: Icon(LucideIcons.siren, color: Theme.of(context).colorScheme.primary), // Example: primary color for selected
            label: 'Move',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.camera),
            selectedIcon: Icon(LucideIcons.camera, color: Theme.of(context).colorScheme.primary),
            label: 'Snap',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.search),
            selectedIcon: Icon(LucideIcons.search, color: Theme.of(context).colorScheme.primary),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.userCircle2), // Using userCircle2 for a slightly different 'Me' icon
            selectedIcon: Icon(LucideIcons.userCircle2, color: Theme.of(context).colorScheme.primary),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
