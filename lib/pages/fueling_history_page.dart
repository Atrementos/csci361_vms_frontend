import 'dart:convert';
import 'dart:io';
import 'package:csci361_vms_frontend/widgets/fueling_person_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../providers/jwt_token_provider.dart';
import 'fueling_task_details_page.dart';

class FuelingHistoryPage extends ConsumerStatefulWidget {
  final int id;

  const FuelingHistoryPage(this.id, {Key? key}) : super(key: key);
  _FuelingHistoryPageState createState() => _FuelingHistoryPageState();
}


class FuelingTask {
  final String vehicleId;
  final String fuelAmount;
  final String creator;
  final String cost;
  final String date;
  final int id;
  FuelingTask({
    required this.vehicleId,
    required this.fuelAmount,
    required this.creator,
    required this.cost,
    required this.date,
    required this.id
  });

  factory FuelingTask.fromJson(Map<String, dynamic> json) {
    return FuelingTask(
      vehicleId: json['Driver']['AssignedVehicle']['Id'].toString(),
      fuelAmount: json['FuelRefilled'].toString(),
      creator: json['Creator'].toString(),
      cost: json['Cost'].toString(),
      date: json['Date'] ?? 'No data', // Add any necessary formatting for the date
      id: json['Id']
    );
  }
}

class _FuelingHistoryPageState extends ConsumerState<FuelingHistoryPage> {
  var _fuelingTasks;

  @override
  void initState() {
    super.initState();
    _fuelingTasks = fetchFuelingTasks();
  }
  Future<void> fetchFuelingTasks() async {
    final response =
        await http.get(Uri.http('vms-api.madi-wka.xyz', '/fuel/'), headers: {
          HttpHeaders.authorizationHeader : 'Bearer ${ref.read(jwt.jwtTokenProvider)}',
          'Content-Type' : 'application/json',
        });
    if (response.statusCode == 200) {
      final decodedResponse1 = json.decode(response.body);
      final decodedResponse = decodedResponse1['FuelingTasks'];
      if (decodedResponse is List) {
        setState(() {
          _fuelingTasks = (decodedResponse as List)
              .where((data) => data['Creator'] == widget.id)
              .map((data) => FuelingTask.fromJson(data))
              .toList();
        });
      } else {
        throw Exception('Failed to load fueling tasks');
      }
    } else {
      throw Exception('Failed to load fueling tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling history'),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _fuelingTasks.length,
          itemBuilder: (context, index) {
            final task = _fuelingTasks[index];
            return ListTile(
              title: Text('Vehicle ID: ${task.vehicleId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fuel Amount: ${task.fuelAmount}'),
                  Text('Creator: ${task.creator}'),
                  Text('Cost: ${task.cost}'),
                  Text('Date: ${task.date}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward), // Arrow icon
              onTap: () {
                // Navigate to a new page for the task when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelingTaskPage(task.id), // Replace TaskDetailPage with your page widget
                  ),
                );
              },
            );
          },
        )

      ),
      drawer: const FuelingPersonDrawer(),
    );
  }
}
