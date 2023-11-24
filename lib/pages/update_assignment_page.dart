import 'dart:convert';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/maintenance_assignment_page.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';

class UpdateAssignmentPage extends ConsumerStatefulWidget {
  const UpdateAssignmentPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateAssignmentPage> createState() =>
      _UpdateAssignmentPageState();
}

class _UpdateAssignmentPageState extends ConsumerState<UpdateAssignmentPage> {
  final formKey = GlobalKey<FormState>();
  List<MaintenanceAssignment> searchResults = [];

  // Define the allowed task statuses
  static const List<String> ALLOWED_TASK_STATUS = ["Requested", "Complete"];
  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWRpLnR1cmd1bm92QG51LmVkdS5reiIsImV4cCI6MTcwMTE5MzIwNH0.IXyt9_g5mangj9Px00fREGPTmkO6zXmCWV9qle2RyVg';

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    try {
      final results = await fetchAllMaintenanceJobs();
      setState(() {
        searchResults = results;
      });
    } catch (error) {
      throw ('Error loading vehicles: $error');
      // Handle error as needed
    }
  }

  Future<List<MaintenanceAssignment>> fetchAllMaintenanceJobs() async {
    try {
      final response = await http.get(
        Uri.http('vms-api.madi-wka.xyz', '/maintenancejob/'),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${ref.read(jwt.jwtTokenProvider)}',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          return MaintenanceAssignment.fromJson(json);
        }).toList();
      } else {
        throw Exception(
            'Failed to load maintenance jobs. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching maintenance jobs: $error');
      throw Exception('Failed to load maintenance jobs');
    }
  }

  Future<void> _updateMaintenanceStatus(
      MaintenanceAssignment assignment, String completed) async {
    try {
      print('Maintenance ID: ${assignment.id}');
      print('Status: $completed');

      // Check if the selected status is valid
      if (ALLOWED_TASK_STATUS.contains(completed) && completed == 'Complete') {
        final Uri url = Uri.http(
          'vms-api.madi-wka.xyz',
          '/maintenancejob/${assignment.id}',
          {'status': completed}, // Include status as a query parameter
        );

        final Map<String, String> headers = {
          HttpHeaders.authorizationHeader:
          'Bearer ${ref.read(jwt.jwtTokenProvider)}',
          'Content-Type': 'application/json',
        };

        final http.Response response = await http.patch(
          url,
          headers: headers,
        );

        print('Request URL: $url');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          // Update the local state after a successful update
          setState(() {
            assignment.status = completed;
          });
        } else {
          throw Exception(
              'Failed to update completed status. Status Code: ${response.statusCode}');
        }
      } else {
        print('Invalid status: $completed');
      }
    } catch (error) {
      print('Error updating completed status: $error');
      throw Exception('Failed to update completed status');
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
              child: const Column(
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
                    title: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              searchResults[index].description,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            searchResults[index].vehicle != null
                                ? searchResults[index]
                                .vehicle!
                                .id
                                ?.toString() ??
                                'N/A'
                                : 'N/A',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            searchResults[index].date.toString(),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text('Completed: '),
                        ),
                        DropdownButton<String>(
                          value: ALLOWED_TASK_STATUS.contains(searchResults[index].status)
                              ? searchResults[index].status
                              : 'Requested', // Provide a default value or handle null
                          onChanged: (value) {
                            if (ALLOWED_TASK_STATUS.contains(value)) {
                              _updateMaintenanceStatus(searchResults[index], value ?? 'Requested');
                            } else {
                              print('Invalid status: $value');
                            }
                          },
                          items: ALLOWED_TASK_STATUS.map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          selectedItemBuilder: (context) {
                            return ALLOWED_TASK_STATUS.map<Widget>((status) {
                              return Text(status);
                            }).toList();
                          },
                        ),








                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return MaintenanceAssignmentPage(
                                maintenanceAssignment: searchResults[index],
                              );
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
