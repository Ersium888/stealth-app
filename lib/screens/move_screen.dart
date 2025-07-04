import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Required for QueryDocumentSnapshot
import '../services/firestore_service.dart'; // Import FirestoreService

class MoveScreen extends StatelessWidget {
  const MoveScreen({super.key});

  static final TextEditingController _pickupController = TextEditingController();
  static final TextEditingController _destinationController = TextEditingController();

  // Instance of FirestoreService
  static final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Route'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(
                hintText: 'Pickup Location',
                prefixIcon: Icon(Icons.location_searching, color: theme.colorScheme.primary),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: 'Destination',
                prefixIcon: Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24.0),
            Container(
              height: 200, // Reduced height slightly to accommodate list below
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[400]!)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 50, color: Colors.grey[600]), // Reduced size
                    const SizedBox(height: 8),
                    Text(
                      'Map Area',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0), // Reduced spacing
            ElevatedButton(
              onPressed: () async {
                final pickup = _pickupController.text;
                final destination = _destinationController.text;
                if (pickup.isNotEmpty && destination.isNotEmpty) {
                  // Example: Add data to Firestore
                  try {
                    await _firestoreService.addMove({
                      'title': '$pickup to $destination', // Example title from inputs
                      'pickup': pickup,
                      'destination': destination,
                      'description': 'A requested move from $pickup to $destination.',
                      // 'createdAt' will be added by the service
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Move data submitted to Firestore!'),
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                    );
                    _pickupController.clear();
                    _destinationController.clear();
                  } catch (e) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to submit move: $e'),
                        backgroundColor: theme.colorScheme.error,
                      ),
                    );
                  }
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter pickup and destination.'),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
              child: const Text('Submit Move Request'), // Updated button text
            ),
            const SizedBox(height: 24.0),
            Text("Recent Moves (from Firestore):", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8.0),
            // StreamBuilder to display moves from Firestore
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestoreService.getMovesStream(), // Using the renamed method
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: TextStyle(color: theme.colorScheme.error));
                }
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No moves recorded yet.'));
                }
                return ListView.builder(
                  shrinkWrap: true, // Important for ListView inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i].data();
                    // Safely access fields with null checks or default values
                    final title = d['title'] as String? ?? 'No title';
                    final description = d['description'] as String? ?? 'No description';
                    final timestamp = d['createdAt'] as Timestamp?;
                    final dateString = timestamp != null
                        ? TimeOfDay.fromDateTime(timestamp.toDate()).format(context) // Just an example format
                        : 'No date';

                    return Card( // Wrap in Card for better UI
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: Icon(Icons.route_outlined, color: theme.colorScheme.primary),
                        title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                        subtitle: Text('$description\nAdded: $dateString'),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
