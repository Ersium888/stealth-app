import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import '../services/auth_service.dart';      // Import AuthService
import 'login_screen.dart';                // Import LoginScreen for navigation

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  Widget _buildOptionTile(BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor, // Optional color for specific icons like logout
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped (Placeholder Action)')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthService authService = AuthService(); // Instance of AuthService

    // Listen to auth changes to display user info or login prompt
    return StreamBuilder<User?>(
      stream: authService.userChanges,
      builder: (context, snapshot) {
        final User? user = snapshot.data;
        final bool isLoggedIn = user != null;

        // User details or placeholders
        final String userName = user?.email ?? "Guest User"; // Display email or "Guest"
        final String userDetail = isLoggedIn ? (user?.emailVerified ?? false ? "Verified" : "Not Verified") : "Please sign in";
        final String userInitials = isLoggedIn && user!.email != null && user.email!.isNotEmpty
            ? user.email![0].toUpperCase()
            : "G";

        return Scaffold(
          appBar: AppBar(
            title: const Text('Me'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.colorScheme.secondary.withOpacity(0.8),
                      child: Text(
                        userInitials,
                        style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userName,
                            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userDetail,
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(thickness: 1, indent: 16, endIndent: 16, color: Colors.grey[200]),
              const SizedBox(height: 10),

              // Common Menu Options
              _buildOptionTile(context, icon: Icons.history_outlined, title: 'Activity History'),
              _buildOptionTile(context, icon: Icons.settings_outlined, title: 'Preferences'),
              _buildOptionTile(context, icon: Icons.palette_outlined, title: 'Appearance'),
              if (isLoggedIn) ...[ // Options available only when logged in
                _buildOptionTile(context, icon: Icons.account_circle_outlined, title: 'Account Details'),
                _buildOptionTile(context, icon: Icons.shield_outlined, title: 'Security'),
              ],
              _buildOptionTile(context, icon: Icons.help_outline, title: 'Support'),

              const SizedBox(height: 20),
              Divider(thickness: 1, indent: 16, endIndent: 16, color: Colors.grey[200]),
              const SizedBox(height: 10),

              // Auth Action Tile
              if (isLoggedIn)
                _buildOptionTile(
                  context,
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  iconColor: theme.colorScheme.error, // Use error color for logout icon
                  onTap: () async {
                    await authService.signOut();
                    // SnackBar or navigation handled by global auth listener or MainScreen potentially
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully logged out')),
                    );
                  },
                )
              else
                _buildOptionTile(
                  context,
                  icon: Icons.login_outlined,
                  title: 'Login / Register',
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
