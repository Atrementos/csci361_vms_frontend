import 'dart:convert';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/user_details_page.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
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
  final searchResults = <MaintenanceAssignment>[];
  String description = '';
  String vehicle = '';
  DateTime selectedDate = DateTime.now();
  int currentPage = 1;
  int perPage = 20;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<List<MaintenanceAssignment>> fetchMaintenanceJobs() async {
    final queryParams = {
      'description': description,
      'vehicle': vehicle,
      'date': selectedDate.toIso8601String(),
      'page': currentPage.toString(),
      'per_page': perPage.toString(),
    };
    final url =
    Uri.http('vms-api.madi-wka.xyz', '/maintenancejob/', queryParams);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return MaintenanceAssignment.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load maintenance jobs');
    }
  }

  void _loadResults() async {
    FocusManager.instance.primaryFocus?.unfocus();
    currentPage = 1;
    try {
      final maintenanceJobs = await fetchMaintenanceJobs();
      setState(() {
        searchResults.clear();
        searchResults.addAll(maintenanceJobs);
      });
    } catch (e) {
      print('Error loading maintenance jobs: $e');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Jobs'),
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 100,
                    onSaved: (value) {
                      description = value ?? '';
                    },
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                    onChanged: (value) {
                      _loadResults();
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLength: 100,
                    onSaved: (value) {
                      vehicle = value ?? '';
                    },
                    decoration: const InputDecoration(
                      label: Text('Vehicle'),
                    ),
                    onChanged: (value) {
                      _loadResults();
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                        _loadResults();
                      }
                    },
                    child: Text('Select Date'),
                  ),
                  const SizedBox(height: 8),
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
                              return UserDetailsPage(
                                  userId: searchResults[index].id);
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
