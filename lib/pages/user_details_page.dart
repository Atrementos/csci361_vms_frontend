import 'dart:convert';

import 'package:csci361_vms_frontend/pages/create_drive_task_page.dart';
import 'package:csci361_vms_frontend/pages/report_driver_page.dart';
import 'package:csci361_vms_frontend/providers/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UserDetailsPage extends ConsumerStatefulWidget {
  final int userId;

  const UserDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserDetailsPageState();
  }
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  Map<String, dynamic>? userInfo;
  final formKey = GlobalKey<FormState>();
  bool isAdmin = false;
  bool editMode = false;
  String firstName = '';
  String lastName = '';
  String middleName = '';
  String contactNumber = '';
  String address = '';
  String email = '';
  String role = '';
  String governmentId = '';

  @override
  void initState() {
    isAdmin = (ref.read(userRole.roleProvider) == 'Admin');
    loadUserInfo();
    super.initState();
  }

  void loadUserInfo() async {
    final url = Uri.http('vms-api.madi-wka.xyz', '/user/${widget.userId}');
    final response = await http.get(url);
    setState(() {
      userInfo = json.decode(response.body);
      firstName = userInfo!['Name'];
      lastName = userInfo!['LastName'];
      if (userInfo!['MiddleName'] != null) {
        middleName = userInfo!['MiddleName'];
      }
      contactNumber = userInfo!['ContactNumber'];
      address = userInfo!['Address'];
      email = userInfo!['Email'];
      role = userInfo!['Role'];
      governmentId = userInfo!['GovernmentId'];
    });
  }

  void openReportPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return ReportDriverPage(driverId: widget.userId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    if (userInfo == null) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      mainContent = Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: firstName,
                            decoration: const InputDecoration(
                              label: Text('First Name'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: lastName,
                            decoration: const InputDecoration(
                              label: Text('Last Name'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: contactNumber,
                            decoration: const InputDecoration(
                              label: Text('Contact Number'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: middleName,
                            decoration: const InputDecoration(
                              label: Text('Middle Name'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: address,
                            decoration: const InputDecoration(
                              label: Text('Address'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: email,
                            decoration: const InputDecoration(
                              label: Text('Email'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: governmentId,
                            decoration: const InputDecoration(
                              label: Text('Government ID'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        // Expanded(
                        //   child: DropdownButtonFormField(
                        //     items: items,
                        //     onChanged: onChanged,
                        //     ),
                        // ),
                      ],
                    ),
                    if (editMode)
                      const SizedBox(
                        height: 12,
                      ),
                    if (editMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                editMode = false;
                                formKey.currentState!.reset();
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (isAdmin && role == 'Driver')
            TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) =>
                      CreateDriveTaskPage(driverId: widget.userId),
                );
              },
              icon: const Icon(Icons.task_alt),
              label: const Text('Give a task'),
            ),
          if (isAdmin && role == 'Driver')
            // TextButton.icon(
            //   onPressed: () {
            //     openReportPage();
            //   },
            //   icon: const Icon(Icons.receipt_long),
            //   label: const Text('Get a report'),
            // ),
            ReportDriverPage(driverId: widget.userId),
          if (isAdmin && !editMode)
            TextButton.icon(
              onPressed: () {
                formKey.currentState!.reset();
                setState(() {
                  editMode = !editMode;
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
        ],
      ),
      body: mainContent,
    );
  }
}
