import 'package:csci361_vms_frontend/widgets/driver_drawer.dart';
import 'package:flutter/material.dart';

class DriverHistoryPage extends StatefulWidget {
  const DriverHistoryPage({Key? key}) : super(key: key);

  @override
  _DriverHistoryPageState createState() => _DriverHistoryPageState();
}

class _DriverHistoryPageState extends State<DriverHistoryPage> {
  List<DriverHistory> driverHistoryList = [
    DriverHistory(
      description: "Go drift around mega",
      status: "Pending",
      startLocation: [29.0, 12.0],
      endLocation: [99.0, 100.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
    DriverHistory(
      description: "Go buy chocolate",
      status: "Pending",
      startLocation: [51.0, 71.0],
      endLocation: [52.0, 72.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
    DriverHistory(
      description: "Drive listening to 2Pac",
      status: "Pending",
      startLocation: [53.0, 74.0],
      endLocation: [51.0, 71.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
  ];

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildDriverHistoryList(),
          ],
        ),
      ),
      drawer: const DriverDrawer(),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search',
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              searchQuery = searchController.text;
            });
          },
          child: const Text('Search'),
        ),
      ],
    );
  }

  Widget _buildDriverHistoryList() {
    // Filter the driver history based on the search query
    List<DriverHistory> filteredHistory = driverHistoryList
        .where((history) =>
    history.description.contains(searchQuery) ||
        history.status.contains(searchQuery))
        .toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Description: ${filteredHistory[index].description}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Location: ${filteredHistory[index].startLocation}'),
                Text('End Location: ${filteredHistory[index].endLocation}'),
                Text('Distance Covered: ${filteredHistory[index].distanceCovered}'),
                Text('Status: ${filteredHistory[index].status}'),
                Text('Start DateTime: ${filteredHistory[index].startDateTime}'),
                Text('End DateTime: ${filteredHistory[index].endDateTime}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DriverHistory {
  final String description;
  final List<double> startLocation;
  final List<double> endLocation;
  final int? distanceCovered;
  final String status;
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  DriverHistory({
    required this.description,
    required this.startLocation,
    required this.endLocation,
    required this.distanceCovered,
    required this.status,
    required this.startDateTime,
    required this.endDateTime,
  });
}


