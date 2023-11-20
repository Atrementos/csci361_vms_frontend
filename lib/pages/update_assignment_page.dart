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
        // Assuming your API response directly returns a list of maintenance jobs
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
                        DropdownButton<bool>(
                          value: searchResults[index].completed,
                          onChanged: (value) {
                            // Update the completed status when the dropdown value changes
                            setState(() {
                              searchResults[index].completed = value ?? false;
                            });
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('Yes'),
                            ),
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('No'),
                            ),
                          ],
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
