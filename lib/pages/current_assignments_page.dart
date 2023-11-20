import 'package:flutter/material.dart';

import '../models/driver_assignment.dart';
import '../widgets/driver_drawer.dart';

class CurrentAssignmentPage extends StatefulWidget {
  const CurrentAssignmentPage({Key? key}) : super(key: key);

  @override
  _CurrentAssignmentPageState createState() => _CurrentAssignmentPageState();
}

class _CurrentAssignmentPageState extends State<CurrentAssignmentPage> {
  List<String> statusList = [
    'Active',
    'Canceled',
    'Completed',
    'Delayed',
  ];
  List<DriverAssignment> currentAssignments = [
    DriverAssignment(
      description: "Go buy chocolate",
      status: 'Active',
      startLocation: [51.0, 71.0],
      endLocation: [52.0, 72.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
    DriverAssignment(
      description: "Drive from A to B",
      status: 'Active',
      startLocation: [53.0, 74.0],
      endLocation: [51.0, 71.0],
      startDateTime: null,
      distanceCovered: null,
      endDateTime: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Assignments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildAssignmentList(),
      ),
      drawer: const DriverDrawer(),
    );
  }

  Widget _buildAssignmentList() {
    return ListView.builder(
      itemCount: currentAssignments.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
                'Description: ${currentAssignments[index].description}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
          ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Location: ${currentAssignments[index].startLocation}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  Text('End Location: ${currentAssignments[index].endLocation}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  Text('Distance Covered: ${currentAssignments[index].distanceCovered}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  Text('Status: ${currentAssignments[index].status}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  Text('Start DateTime: ${currentAssignments[index].startDateTime}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  Text('End DateTime: ${currentAssignments[index].endDateTime}', style: const TextStyle(fontSize: 17, color: Colors.white70)),
                  _buildStatusDropdown(index),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusDropdown(int index) {
    return DropdownButton<String>(
      value: currentAssignments[index].status,
      items: statusList.map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status, style: const TextStyle(fontSize: 18, color: Colors.white)),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          currentAssignments[index].status = newValue!;
        });
      },
    );
  }
}

