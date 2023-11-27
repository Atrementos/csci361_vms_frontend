import 'dart:convert';
import 'dart:io';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/login_page.dart';
import 'package:csci361_vms_frontend/providers/driver_vehicle_provider.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
import 'package:csci361_vms_frontend/providers/role_provider.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:csci361_vms_frontend/widgets/fueling_person_drawer.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_id_provider.dart';
import '../widgets/driver_drawer.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Map<String, dynamic>? _userInfo;
  final _formKey = GlobalKey<FormState>();
  bool editMode = false;
  String firstName = '';
  String lastName = '';
  String? middleName = '';
  String contactNumber = '';
  String address = '';
  String email = '';
  String password = '';
  String governmentId = '';

  void _loadUser() async {
    final url = Uri.parse('http://vms-api.madi-wka.xyz/user/me/');
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${ref.read(jwt.jwtTokenProvider)}',
      HttpHeaders.accessControlAllowOriginHeader: 'access-control-allow-origin',
    });
    final decodedResponse = json.decode(response.body);
    userRole.setRole(decodedResponse['Role']);
    userId.setId(decodedResponse['Id']);
    if (ref.read(userRole.roleProvider) == 'Driver') {
      final response = await http.get(Uri.http('vms-api.madi-wka.xyz',
          '/user/driver/${ref.read(userId.idProvider)}'));
      if (json.decode(response.body)['AssignedVehicle'] != null) {
        Vehicle assignedVehicle =
            Vehicle.fromJson(json.decode(response.body)['AssignedVehicle']);
        vehicleId.setId(assignedVehicle.id);
        locationId.setLocation(assignedVehicle.currentLocation);
      }
    }
    setState(() {
      _userInfo = decodedResponse;
      firstName = _userInfo!['Name'];
      lastName = _userInfo!['LastName'];
      if (_userInfo!['MiddleName'] != null) {
        middleName = _userInfo!['MiddleName'];
      }
      contactNumber = _userInfo!['ContactNumber'];
      address = _userInfo!['Address'];
      email = _userInfo!['Email'];
      governmentId = _userInfo!['GovernmentId'];
    });
  }

  void updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final postBody = {
        "Email": email,
        "Password": password,
        "Name": firstName,
        "MiddleName": middleName ?? '',
        "LastName": lastName,
        "ContactNumber": contactNumber,
        "GovernmentId": governmentId,
        "Address": address,
        "Role": _userInfo!['Role'],
      };
      final url = Uri.http(
        'vms-api.madi-wka.xyz',
        '/user/${_userInfo!['Id']}',
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
          _userInfo = json.decode(response.body);
          firstName = _userInfo!['Name'];
          lastName = _userInfo!['LastName'];
          if (_userInfo!['MiddleName'] != null) {
            middleName = _userInfo!['MiddleName'];
          }
          contactNumber = _userInfo!['ContactNumber'];
          address = _userInfo!['Address'];
          email = _userInfo!['Email'];
          governmentId = _userInfo!['GovernmentId'];
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
      editMode = false;
    }
  }

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    if (_userInfo == null) {
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
                key: _formKey,
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
                            initialValue: address,
                            onSaved: (newValue) {
                              address = newValue!;
                            },
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
                            initialValue: governmentId,
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
                    Row(
                      children: [
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
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: editMode ? false : true,
                            initialValue: password,
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  !RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$')
                                      .hasMatch(value)) {
                                return 'Incorrect password format';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != null) {
                                password = newValue;
                              } else {
                                password = '';
                              }
                            },
                            decoration: const InputDecoration(
                              label: Text('Password'),
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
                                _formKey.currentState!.reset();
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
          if (_userInfo != null && !editMode)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
          if (_userInfo != null)
            TextButton.icon(
              onPressed: () async {
                jwt.setJwtToken('');
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('jwt', '');
                ref.read(pageProvider.notifier).setPage(const LoginPage());
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
        ],
      ),
      body: mainContent,
      drawer: _userInfo == null
          ? const CircularProgressIndicator()
          : ref.read(userRole.roleProvider) == 'Admin'
              ? const AdminDrawer()
              : ref.read(userRole.roleProvider) == 'Driver'
                  ? const DriverDrawer()
                  : ref.read(userRole.roleProvider) == 'Fueling'
                      ? const FuelingPersonDrawer()
                      : const MaintenanceDrawer(),
    );
  }
}
