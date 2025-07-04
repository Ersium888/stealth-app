import 'package:flutter/material.dart';
import '../widgets/placeholder_tile.dart'; // Import the new widget

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  // Simulate a list of generic items
  // In a real app, this would come from a service or state management
  static final List<Map<String, dynamic>> _discoverItems = List.generate(
    20, // Number of items to display
    (index) => {
      'id': 'item_$index',
      'title': 'Collection Item ${index + 1}',
      // Simulate varying aspect ratios for a more dynamic grid
      // This is a simple way to achieve some visual difference.
      // For true staggered grids, a package like flutter_staggered_grid_view might be better.
      'aspectRatio': (index % 3 == 0) ? 3/4 : (index % 3 == 1) ? 4/5 : 1.0,
    },
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
            onPressed: () {
              // Placeholder search action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search action (Placeholder)')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        // Add padding around the GridView
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _discoverItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Horizontal spacing between items
            mainAxisSpacing: 8.0, // Vertical spacing between items
            // childAspectRatio is tricky if items have varying aspect ratios internally.
            // The PlaceholderTile itself handles its aspect ratio.
            // For a simple grid, we might set a common childAspectRatio,
            // or let the items size themselves based on their content if using SliverGridDelegateWithMaxCrossAxisExtent.
            // Since PlaceholderTile manages its own aspect ratio, we might need a more dynamic grid delegate
            // for perfect staggering, like flutter_staggered_grid_view.
            // For now, with fixed cross axis count, the height will adjust to the aspect ratio.
          ),
          itemBuilder: (BuildContext context, int index) {
            final item = _discoverItems[index];
            return PlaceholderTile(
              title: item['title'],
              aspectRatio: item['aspectRatio'],
            );
          },
        ),
      ),
    );
  }
}
