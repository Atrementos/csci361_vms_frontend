import 'dart:convert';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FuelingHistoryPage extends StatefulWidget {
  const FuelingHistoryPage({Key? key}) : super(key: key);

  @override
  _FuelingHistoryPageState createState() => _FuelingHistoryPageState();
}

class FuelingTask {
  final String vehicleModel;
  final String fuelAmount;
  final String fuelingTask;

  FuelingTask({
    required this.vehicleModel,
    required this.fuelAmount,
    required this.fuelingTask,
  });
}

class _FuelingHistoryPageState extends State<FuelingHistoryPage> {
  late Future<List<FuelingTask>> _fuelingTasks;

  @override
  void initState() {
    super.initState();
    _fuelingTasks = fetchFuelingTasks();
  }

  Future<List<FuelingTask>> fetchFuelingTasks() async {
    final response =
        await http.get(Uri.http('vms-api.madi-wka.xyz', '/fueling-history/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return FuelingTask(
          vehicleModel: json['vehicleModel'],
          fuelAmount: json['fuelAmount'],
          fuelingTask: json['fuelingTask'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load fueling tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Task History'),
      ),
      body: FutureBuilder<List<FuelingTask>>(
        future: _fuelingTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<FuelingTask> fuelingTasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: fuelingTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Vehicle Model: ${fuelingTasks[index].vehicleModel}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fuel Amount: ${fuelingTasks[index].fuelAmount}'),
                      Text('Fueling Task: ${fuelingTasks[index].fuelingTask}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      drawer: const AdminDrawer(),
    );
  }
}
