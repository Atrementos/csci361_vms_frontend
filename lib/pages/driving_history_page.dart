import 'package:csci361_vms_frontend/widgets/driver_drawer.dart';
import 'package:flutter/material.dart';

import '../models/driver_assignment.dart';

class DriverHistoryPage extends StatefulWidget {
  const DriverHistoryPage({Key? key}) : super(key: key);

  @override
  _DriverHistoryPageState createState() => _DriverHistoryPageState();
}

class _DriverHistoryPageState extends State<DriverHistoryPage> {
  List<DriverAssignment> driverHistoryList = [
    DriverAssignment(
      description: "Go drift around mega",
      status: "Pending",
      startLocation: [29.0, 12.0],
      endLocation: [99.0, 100.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
    DriverAssignment(
      description: "Go buy chocolate",
      status: "Active",
      startLocation: [51.0, 71.0],
      endLocation: [52.0, 72.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
    DriverAssignment(
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
    List<DriverAssignment> filteredHistory = driverHistoryList
        .where((history) =>
    history.description.contains(searchQuery) ||
        history.status.contains(searchQuery))
        .toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredHistory.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Description: ${filteredHistory[index].description}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Location: ${filteredHistory[index].startLocation}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                    Text('End Location: ${filteredHistory[index].endLocation}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                    Text('Distance Covered: ${filteredHistory[index].distanceCovered}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                    Text('Status: ${filteredHistory[index].status}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                    Text('Start DateTime: ${filteredHistory[index].startDateTime}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                    Text('End DateTime: ${filteredHistory[index].endDateTime}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



