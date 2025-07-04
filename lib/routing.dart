import 'package:flutter/material.dart';
import 'screens/move_screen.dart';
import 'screens/snap_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/me_screen.dart';
// We also need to import MainScreen if it were to be part of named routes,
// but it's set as `home` in main.dart, so direct navigation to it via named route isn't typical.
// If any of these screens are not yet created, these imports will be temporarily invalid
// but will resolve once all screen files are in place.

const appRoutes = <String, WidgetBuilder>{
  '/move': (_) => const MoveScreen(),
  '/snap': (_) => const SnapScreen(),
  '/discover': (_) => const DiscoverScreen(),
  '/me': (_) => const MeScreen(),
  // Example: If you had a settings page navigable from MeScreen:
  // '/settings': (_) => const SettingsScreen(),
};
