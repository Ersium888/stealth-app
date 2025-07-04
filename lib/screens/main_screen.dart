import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';        // Import FirebaseAuth for User type
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/auth_service.dart';                 // Import AuthService
import 'move_screen.dart';
import 'snap_screen.dart';
import 'discover_screen.dart';
import 'me_screen.dart';
import 'login_screen.dart';                            // Import LoginScreen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService(); // Instance of AuthService

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
    return StreamBuilder<User?>(
      stream: _authService.userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Show loading indicator while checking auth state
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, show the main app interface
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: const Icon(LucideIcons.siren),
                  selectedIcon: Icon(LucideIcons.siren, color: Theme.of(context).colorScheme.primary),
                  label: 'Move',
                ),
                NavigationDestination(
                  icon: const Icon(LucideIcons.camera),
                  selectedIcon: Icon(LucideIcons.camera, color: Theme.of(context).colorScheme.primary),
                  label: 'Snap',
                ),
                NavigationDestination(
                  icon: const Icon(LucideIcons.search),
                  selectedIcon: Icon(LucideIcons.search, color: Theme.of(context).colorScheme.primary),
                  label: 'Discover',
                ),
                NavigationDestination(
                  icon: const Icon(LucideIcons.userCircle2),
                  selectedIcon: Icon(LucideIcons.userCircle2, color: Theme.of(context).colorScheme.primary),
                  label: 'Me',
                ),
              ],
            ),
          );
        } else {
          // User is not logged in, show LoginScreen
          // Using a Navigator here allows LoginScreen to push RegisterScreen on top of itself
          // without affecting the MainScreen's position in the widget tree if it were already there.
          // However, since MainScreen is 'home', LoginScreen effectively becomes the initial view if not logged in.
          return const LoginScreen();
        }
      },
    );
  }
}
