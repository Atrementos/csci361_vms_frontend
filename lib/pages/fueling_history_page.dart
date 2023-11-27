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
      id: json['Id'],
    );
  }
}

class _FuelingHistoryPageState extends ConsumerState<FuelingHistoryPage> {
  late Future<List<FuelingTask>> _fuelingTasksFuture;

  @override
  void initState() {
    super.initState();
    _fuelingTasksFuture = fetchFuelingTasks();
  }
  Future<List<FuelingTask>> fetchFuelingTasks() async {
    final response = await http.get(
      Uri.http('vms-api.madi-wka.xyz', '/fuel/creator/${widget.id.toString()}/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${ref.read(jwt.jwtTokenProvider)}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body)['FuelingTasks'];
      if (decodedResponse is List) {
        final List<FuelingTask> tasks = decodedResponse
            .map((data) => FuelingTask.fromJson(data as Map<String, dynamic>))
            .toList();
        return tasks;
      } else {
        throw Exception('Failed to load fueling tasks1');
      }
    } else {
      throw Exception('Failed to load fueling tasks2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling history'),
      ),
        drawer: const FuelingPersonDrawer(),
      body: FutureBuilder<List<FuelingTask>>(
        future: _fuelingTasksFuture,
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No fueling tasks available'));
        } else {
        return SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final task = snapshot.data![index];
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
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FuelingTaskPage(task.id), // Replace TaskDetailPage with your page widget
                ),
                );
              },
            );
        },
        ),

        );
        }
        }
      ),);
  }
}
