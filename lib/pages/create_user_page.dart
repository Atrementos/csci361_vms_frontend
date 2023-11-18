import 'package:csci361_vms_frontend/models/user.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateUserPageState();
  }
}

class _CreateUserPageState extends State<CreateUserPage> {
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  String enteredFirstName = '';
  String enteredLastName = '';
  String enteredEmail = '';
  String enteredPassword = '';
  String selectedRole = 'Admin';

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
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return 'Incorrect last name format';
                        }
                        return null;
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
                          return 'Incorrect last name format';
                        }
                        return null;
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
                      obscureText: showPassword,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[\+]?[\d]{6,16}$').hasMatch(value)) {
                          return 'Incorrect phone number format';
                        }
                        return null;
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
              TextFormField(
                maxLength: 60,
                decoration: const InputDecoration(
                  label: Text('Address'),
                ),
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
                    onPressed: () {},
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
