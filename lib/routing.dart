import 'package:flutter/material.dart';
import 'screens/move_screen.dart';
import 'screens/snap_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/me_screen.dart';
import 'screens/login_screen.dart'; // Import LoginScreen
import 'screens/register_screen.dart'; // Import RegisterScreen

// MainScreen is typically the home route and not part of these named routes
// if it's the root of the tab navigation. These routes are for standalone pages.

const appRoutes = <String, WidgetBuilder>{
  // Tab screen routes (can be useful if ever needing to deep link or navigate directly)
  // However, MainScreen typically manages these internally.
  // For clarity, these might be removed if MainScreen is always the entry to them.
  '/move': (_) => const MoveScreen(),
  '/snap': (_) => const SnapScreen(),
  '/discover': (_) => const DiscoverScreen(),
  '/me': (_) => const MeScreen(),

  // Authentication routes
  LoginScreen.routeName: (_) => const LoginScreen(), // Using static routeName from LoginScreen
  RegisterScreen.routeName: (_) => const RegisterScreen(), // Using static routeName from RegisterScreen

  // Example: If you had a settings page navigable from MeScreen:
  // '/settings': (_) => const SettingsScreen(),
};
