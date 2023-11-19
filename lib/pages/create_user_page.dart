import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/models/user.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CreateUserPage extends ConsumerStatefulWidget {
  const CreateUserPage({super.key});

  @override
  ConsumerState<CreateUserPage> createState() {
    return _CreateUserPageState();
  }
}

class _CreateUserPageState extends ConsumerState<CreateUserPage> {
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  String enteredFirstName = '';
  String enteredLastName = '';
  String? enteredMiddleName;
  String enteredEmail = '';
  String enteredPassword = '';
  String enteredPhoneNumber = '';
  String enteredGovenmentId = '';
  String enteredAddress = '';
  String selectedRole = 'Admin';
  String enteredLicenseNumber = '';

  void addUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final postBody = {
        "Email": enteredEmail,
        "Password": enteredPassword,
        "Name": enteredFirstName,
        "MiddleName": enteredMiddleName ?? '',
        "LastName": enteredLastName,
        "ContactNumber": enteredPhoneNumber,
        "GovernmentId": enteredGovenmentId,
        "Address": enteredAddress,
        "Role": selectedRole,
      };
      if (selectedRole == 'Driver') {
        postBody['DrivingLicenseNumber'] = enteredLicenseNumber;
      }
      final url = Uri.http('vms-api.madi-wka.xyz',
          (selectedRole == 'Driver') ? 'user/driver' : 'user/');
      final response = await http.post(
        url,
        body: json.encode(postBody),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${ref.read(jwt.jwtTokenProvider)}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The user was successfully added.'),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Some unexpected error occurred when adding a new user.'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new user'),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return 'Incorrect first name format';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredFirstName = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('First name'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return 'Incorrect last name format';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredLastName = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Last name'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                          return 'Incorrect email format';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredEmail = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Email'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return null;
                        }
                        return 'Incorrect middle name format';
                      },
                      onSaved: (value) {
                        enteredMiddleName = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Middle name'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      obscureText: !showPassword,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$')
                                .hasMatch(value)) {
                          return 'Incorrect password format';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredPassword = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Checkbox(
                    value: showPassword,
                    onChanged: (isChecked) {
                      setState(
                        () {
                          showPassword = isChecked!;
                        },
                      );
                    },
                  ),
                  const Text('Show password'),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[\+]?[\d]{6,16}$').hasMatch(value)) {
                          return 'Incorrect phone number format';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredPhoneNumber = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Phone number'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text('Role'),
                      ),
                      items: [
                        for (final role in allRoles)
                          DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                      value: selectedRole,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 60,
                      onSaved: (value) {
                        enteredAddress = value!;
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
                      maxLength: 20,
                      onSaved: (value) {
                        enteredGovenmentId = value!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Government ID'),
                      ),
                    ),
                  ),
                ],
              ),
              if (selectedRole == 'Driver')
                const SizedBox(
                  height: 8,
                ),
              if (selectedRole == 'Driver')
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[A-Z0-9]{8,20}$').hasMatch(value)) {
                      return 'Incorrect license number format';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredLicenseNumber = value!;
                  },
                  decoration: const InputDecoration(
                    label: Text('Driving license number'),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addUser();
                    },
                    child: const Text('Add user'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
