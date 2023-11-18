import 'dart:convert';
import 'dart:io';
import 'package:csci361_vms_frontend/pages/driver_page.dart';
import 'package:csci361_vms_frontend/pages/fueling_person_page.dart';
import 'package:csci361_vms_frontend/pages/maintenance_person_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
import 'package:csci361_vms_frontend/providers/role_provider.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
  String middleName = '';
  String contactNumber = '';
  String address = '';
  String email = '';

  void _loadUser() async {
    final url = Uri.parse('http://vms-api.madi-wka.xyz/user/me');
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${ref.read(jwt.jwtTokenProvider)}',
      HttpHeaders.accessControlAllowOriginHeader: 'access-control-allow-origin',
    });
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    userRole.setRole(decodedResponse['Role']);
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
    });
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
                child: Expanded(
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
                              onPressed: () {},
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(pageProvider.notifier)
                    .setPage(const FuelingPersonPage());
              },
              child: const Text('Fueling Person Profile Page'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(pageProvider.notifier)
                    .setPage(const MaintenancePersonPage());
              },
              child: const Text('Maintenance Person Profile Page'),
            ),
            TextButton(
              onPressed: () {
                ref.read(pageProvider.notifier).setPage(const DriverPage());
              },
              child: const Text('Driver Profile Page'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_userInfo == null || !editMode)
            TextButton.icon(
              onPressed: () {
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
      drawer: const AdminDrawer(),
    );
  }
}
