import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class SearchAllPage extends StatefulWidget {
  const SearchAllPage({super.key});

  @override
  State<SearchAllPage> createState() {
    return _SearchAllPageState();
  }
}

class _SearchAllPageState extends State<SearchAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SearchAnchor(
          builder: (ctx, searchController) {
            return SearchBar(
              controller: searchController,
              hintText: 'Search...',
            );
          },
          suggestionsBuilder: (ctx, searchController) {
            return [];
          },
        ),
      ),
    );
  }
}
