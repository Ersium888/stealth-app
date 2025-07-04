import 'package:flutter/material.dart';

class PlaceholderTile extends StatelessWidget {
  final String title;
  final double aspectRatio; // To allow for varying aspect ratios for staggered effect

  const PlaceholderTile({
    super.key,
    required this.title,
    this.aspectRatio = 1.0, // Default to a square tile
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      // CardTheme from main.dart will be applied (elevation, shape, margin)
      // We can add specific margin here if needed for grid spacing,
      // but GridView's spacing parameters are often better.
      // margin: const EdgeInsets.all(4.0),
      clipBehavior: Clip.antiAlias, // Ensures content respects card's rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image Placeholder
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              color: Colors.grey[200], // Placeholder color for the image area
              child: Icon(
                Icons.image_outlined, // Generic image icon
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),
          // Title Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
