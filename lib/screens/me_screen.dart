import 'package:flutter/material.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  // Helper method to build list tiles for options
  Widget _buildOptionTile(BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Card( // Wrap ListTile in a Card for consistent styling with theme
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0), // Add some horizontal margin
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
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

    // Placeholder user data
    const String userName = "User Name";
    const String userDetail = "Active Member"; // Generic detail/status
    const String userInitials = "UN"; // Or generate from userName

    return Scaffold(
      appBar: AppBar(
        title: const Text('Me'),
        centerTitle: true,
      ),
      body: ListView( // Use ListView for scrollability if content grows
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          // User Profile Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.8),
                  // backgroundImage: NetworkImage('https://example.com/avatar.jpg'), // Placeholder for actual image
                  child: Text(
                    userInitials,
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
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

          // Menu Options
          _buildOptionTile(
            context,
            icon: Icons.history_outlined,
            title: 'Activity History',
          ),
          _buildOptionTile(
            context,
            icon: Icons.settings_outlined,
            title: 'Preferences',
          ),
          _buildOptionTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Appearance',
          ),
          _buildOptionTile(
            context,
            icon: Icons.account_circle_outlined, // Changed from credit_card for more generality
            title: 'Account Details',
          ),
          _buildOptionTile(
            context,
            icon: Icons.shield_outlined, // Changed from shield_check for more generality
            title: 'Security',
          ),
          _buildOptionTile(
            context,
            icon: Icons.help_outline,
            title: 'Support',
          ),
          const SizedBox(height: 20),
           Divider(thickness: 1, indent: 16, endIndent: 16, color: Colors.grey[200]),
          const SizedBox(height: 10),
          _buildOptionTile(
            context,
            icon: Icons.logout_outlined,
            title: 'Logout',
            onTap: () {
              // Placeholder logout action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout action (Placeholder)')),
              );
              // In a real app, this would trigger auth logout and navigation
            },
          ),
        ],
      ),
    );
  }
}
