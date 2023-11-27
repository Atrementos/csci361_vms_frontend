import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:csci361_vms_frontend/widgets/driver_drawer.dart';

import '../models/driver_assignment.dart';
import '../providers/jwt_token_provider.dart';

class DriverHistoryPage extends ConsumerStatefulWidget {
  final int driverId;
  const DriverHistoryPage({Key? key, required this.driverId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DriverHistoryPageState();
  }
}

class _DriverHistoryPageState extends ConsumerState<DriverHistoryPage> {
  List<DriverAssignment> driverHistoryList = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadDriverHistoryList();
  }

  void loadDriverHistoryList() async {
    final url = Uri.http('vms-api.madi-wka.xyz', '/task/driver/${widget.driverId}/');
    final response = await http.get(url, headers: {'Authorization': 'Bearer ${ref.read(jwt.jwtTokenProvider)}'},);
    if (response.statusCode == 200) {
      final List<dynamic> decodedResponse = json.decode(response.body);
      setState(() {
        driverHistoryList = decodedResponse
            .where((data) => ['Completed', 'Cancelled'].contains(data['Status']))
            .map((data) => DriverAssignment.fromJson(data))
            .toList();
        isLoaded = true;
      });
    } else {
      // Handle error
      if (kDebugMode) {
        print('Failed to load driver history. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver History'),
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildDriverHistoryList(),
            ],
          ),
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
    List<DriverAssignment> filteredHistory = driverHistoryList
        .where((history) =>
    history.description.contains(searchQuery) ||
        history.status.contains(searchQuery))
        .toList();
    if (filteredHistory.isEmpty) {
      return const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No driving history available',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      );
    }
    else {
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
}


