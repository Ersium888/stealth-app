import 'package:flutter/material.dart';

class SnapScreen extends StatelessWidget {
  const SnapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor to make it feel like a camera view, can be dark or a gradient
      backgroundColor: Colors.black,
      // No AppBar for a full-screen camera feel
      body: Stack(
        alignment: Alignment.center, // Center children in the Stack
        children: <Widget>[
          // Placeholder for the camera preview (could be a camera plugin widget later)
          // For now, it's just the black background of the Scaffold.
          // If you want a visual cue for where the camera feed would be:
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.grey[800], // Dark grey placeholder for camera feed
          //     child: Center(child: Icon(Icons.videocam_off_outlined, color: Colors.grey[600], size: 100)),
          //   ),
          // ),

          // Capture Button - positioned towards the bottom center
          Positioned(
            bottom: 40.0, // Adjust spacing from the bottom
            child: GestureDetector(
              onTap: () {
                // Action for capture
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Capture action! (Placeholder)'),
                    backgroundColor: theme.colorScheme.secondary, // Use accent color from theme
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4.0), // Border width for the outer white ring
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Outer ring color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  width: 70.0, // Size of the inner button
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Inner button color (can be different)
                    border: Border.all(color: Colors.black, width: 2.5) // Inner border to make it look like a camera button
                  ),
                  child: Icon(
                    Icons.camera_alt, // Standard camera icon
                    color: Colors.black, // Icon color
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ),

          // Optional: Minimal top controls (e.g., flash, flip camera)
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 10, // Respect status bar
          //   left: 0,
          //   right: 0,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         IconButton(
          //           icon: Icon(Icons.flash_on, color: Colors.white),
          //           onPressed: () { /* Flash action */ },
          //         ),
          //         IconButton(
          //           icon: Icon(Icons.flip_camera_ios_outlined, color: Colors.white),
          //           onPressed: () { /* Flip camera action */ },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
