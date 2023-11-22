import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/driver_assignment.dart';
import '../widgets/driver_drawer.dart';

class CurrentAssignmentPage extends StatefulWidget {
  final int driverId;
  const CurrentAssignmentPage({Key? key, required this.driverId}) : super(key: key);

  @override
  _CurrentAssignmentPageState createState() => _CurrentAssignmentPageState();
}

class _CurrentAssignmentPageState extends State<CurrentAssignmentPage> {
  var isLoading = false;
  List<String> statusList = [
    'In Progress',
    'Cancelled',
    'Completed',
    'Pending',
  ];
  List<DriverAssignment> currentAssignments = [];
  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWRpLnR1cmd1bm92QG51LmVkdS5reiIsImV4cCI6MTcwMTE5MzIwNH0.IXyt9_g5mangj9Px00fREGPTmkO6zXmCWV9qle2RyVg';

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  void _fetchAssignments() async {
    final url = Uri.http('vms-api.madi-wka.xyz', '/task/driver/${widget.driverId}/');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'},);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        currentAssignments = data
            .map((item) => DriverAssignment.fromJson(item))
            .where((assignment) =>
        assignment.status == 'In Progress' ||
            assignment.status == 'Pending')
            .toList();
        isLoading = true;
      });
    } else {
      print('Failed to load assignments. Status code: ${response.statusCode}');
    }
  }

  void _updateStatus(int index, String newStatus) async {
    final Map<String, dynamic> queryParams = {
      "task_id": ['$index'],
      "status": newStatus,
    };
    final DriverAssignment assignment = currentAssignments[index];
    final url = Uri.http('vms-api.madi-wka.xyz', '/task/', queryParams);
    // Make PATCH request to update status in the database
    final response = await http.patch(url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        assignment.status = newStatus;
      });
      _fetchAssignments();
      print('Status updated successfully');
    } else {
      print('Failed to update status. Status code: ${response.statusCode}, ${jsonDecode(response.body)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Assignments'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildAssignmentList(),
        ),
      ),
      drawer: const DriverDrawer(),
    );
  }

  Widget _buildAssignmentList() {
    if (currentAssignments.isEmpty) {
      return const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No assignments available',
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
      return ListView.builder(
        itemCount: currentAssignments.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Description: ${currentAssignments[index].description}',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Location: ${currentAssignments[index].startLocation}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    Text('End Location: ${currentAssignments[index].endLocation}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    Text('Distance Covered: ${currentAssignments[index].distanceCovered}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    Text('Status: ${currentAssignments[index].status}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    Text('Start DateTime: ${currentAssignments[index].startDateTime}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    Text('End DateTime: ${currentAssignments[index].endDateTime}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    _buildStatusDropdown(index),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildStatusDropdown(int index) {
    return DropdownButton<String>(
      value: currentAssignments[index].status,
      items: statusList.map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status, style: const TextStyle(fontSize: 18, color: Colors.white70)),
        );
      }).toList(),
      onChanged: (newValue) {
        _updateStatus(index, newValue!);
        setState(() {
          currentAssignments[index].status = newValue;
        });
      },
      dropdownColor: const Color.fromARGB(255, 33, 41, 34),
    );
  }
}

