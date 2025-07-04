import 'package:flutter/material.dart';

class MoveScreen extends StatelessWidget {
  const MoveScreen({super.key});

  // Controllers for TextFields - manage their text.
  // In a StatefulWidget, these would be initialized in initState and disposed in dispose.
  // For a StatelessWidget, they are typically passed in or created directly if not needing disposal logic here.
  // For this placeholder, creating them directly is fine.
  static final TextEditingController _pickupController = TextEditingController();
  static final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme for consistent styling

    return Scaffold(
      // Using AppBar for a consistent screen title look, can be removed if not desired
      appBar: AppBar(
        title: const Text('Set Route'), // Ambiguous title
        centerTitle: true, // Common practice for mobile titles
      ),
      body: SingleChildScrollView( // Allows content to scroll if it overflows
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Pickup Location TextField
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(
                hintText: 'Pickup Location', // Ambiguous placeholder
                prefixIcon: Icon(Icons.location_searching, color: theme.colorScheme.primary),
                // Using inputDecorationTheme from main.dart
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),

            // Destination TextField
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: 'Destination', // Ambiguous placeholder
                prefixIcon: Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
                // Using inputDecorationTheme from main.dart
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24.0),

            // Map Placeholder
            Container(
              height: 250, // Adjust height as needed
              decoration: BoxDecoration(
                color: Colors.grey[300], // Placeholder color
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[400]!)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 60, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      'Map Area',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Action Button
            ElevatedButton(
              onPressed: () {
                // Action for the button - e.g., process locations
                // For now, just a placeholder action or could show a SnackBar
                final pickup = _pickupController.text;
                final destination = _destinationController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pickup: $pickup, Destination: $destination (Placeholder Action)'),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                );
              },
              // ElevatedButtonTheme is applied from main.dart
              child: const Text('Confirm Route'), // Ambiguous button text
            ),
          ],
        ),
      ),
    );
  }
}
