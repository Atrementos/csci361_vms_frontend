import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/pages/create_drive_task_page.dart';
import 'package:csci361_vms_frontend/pages/report_driver_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
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
  String? middleName;
  String contactNumber = '';
  String address = '';
  String email = '';
  String password = '';
  String role = '';
  String governmentId = '';
  String? licenseNumber = '';

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

  void updateUserInfo() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final postBody = {
        "Email": email,
        "Password": password,
        "Name": firstName,
        "MiddleName": middleName ?? '',
        "LastName": lastName,
        "ContactNumber": contactNumber,
        "GovernmentId": governmentId,
        "Address": address,
        "Role": userInfo!['Role'],
      };
      final url = Uri.http(
        'vms-api.madi-wka.xyz',
        '/user/${widget.userId}',
      );
      final response = await http.put(
        url,
        body: json.encode(postBody),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${ref.read(jwt.jwtTokenProvider)}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 202) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The user was successfully updated.'),
            ),
          );
        }
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
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Unexpected error occurred when updating user information.'),
            ),
          );
        }
      }
    }
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return 'Incorrect last name format';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              firstName = newValue!;
                            },
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return 'Incorrect last name format';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              lastName = newValue!;
                            },
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[\+]?[\d]{6,16}$')
                                      .hasMatch(value)) {
                                return 'Incorrect phone number format';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              contactNumber = newValue!;
                            },
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return null;
                              }
                              return 'Incorrect middle name format';
                            },
                            onSaved: (newValue) {
                              middleName = newValue;
                            },
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
                            initialValue: password,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$')
                                      .hasMatch(value)) {
                                return 'Incorrect password format';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              password = newValue!;
                            },
                            decoration: const InputDecoration(
                              label: Text('Password'),
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                return 'Incorrect email format';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              email = newValue!;
                            },
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
                            initialValue: address,
                            maxLength: 60,
                            onSaved: (newValue) {
                              address = newValue!;
                            },
                            decoration: const InputDecoration(
                              label: Text('Address'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: governmentId,
                            maxLength: 20,
                            onSaved: (newValue) {
                              governmentId = newValue!;
                            },
                            decoration: const InputDecoration(
                              label: Text('Government ID'),
                            ),
                          ),
                        ),
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
                            onPressed: () {
                              updateUserInfo();
                            },
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
