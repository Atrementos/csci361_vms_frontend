import 'dart:convert';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/maintenance_assignment_page.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UpdateAssignmentPage extends ConsumerStatefulWidget {
  const UpdateAssignmentPage({Key? key}) : super(key: key);

  @override
  _UpdateAssignmentPageState createState() => _UpdateAssignmentPageState();
}

class _UpdateAssignmentPageState extends ConsumerState<UpdateAssignmentPage> {
  final formKey = GlobalKey<FormState>();
  List<MaintenanceAssignment> searchResults = [];

  @override
  void initState() async {
    super.initState();
    _loadResults();
  }


  Future<void> _loadResults() async {
    try {
      setState(() {
        fetchAllMaintenanceJobs();
      });
    } catch (error) {
      throw ('Error loading vehicles: $error');
      // Handle error as needed
    }
  }
  Future<List<MaintenanceAssignment>> fetchAllMaintenanceJobs() async {
    final response =
    await http.get(Uri.http('vms-api.madi-wka.xyz', '/maintenancejob/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return MaintenanceAssignment.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load maintenance jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Jobs'),
      ),
      drawer: const MaintenanceDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Your form fields go here if needed
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                return false;
              },
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(searchResults[index].description),
                    title: Text(searchResults[index].vehicle.licensePlate),
                    subtitle: Text(searchResults[index].date.toString()),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return MaintenanceAssignmentPage(
                                  maintenanceAssignment: searchResults[index]);
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_outward),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
