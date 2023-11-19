import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/pages/profile_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordTextController = TextEditingController();
  bool showPassword = false;
  String _enteredUsername = '';
  String _enteredPassword = '';
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    loadJwt();
  }

  void loadJwt() async {
    final SharedPreferences newPrefs = await prefs;
    if (newPrefs.getString('jwt') != null && newPrefs.getString('jwt') != '') {
      final url = Uri.parse('http://vms-api.madi-wka.xyz/user/me');
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${newPrefs.getString('jwt')}',
      });
      if (response.statusCode == 200) {
        jwt.setJwtToken(newPrefs.getString('jwt')!);
        ref.read(pageProvider.notifier).setPage(const ProfilePage());
      }
    }
  }

  void _authorize(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.http('vms-api.madi-wka.xyz', 'token');
      final response = await http.post(
        url,
        body: {
          "username": _enteredUsername,
          "password": _enteredPassword,
        },
      );
      if (response.statusCode != 200) {
        passwordTextController.clear();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incorrect email or password.'),
            ),
          );
        }
        return;
      }
      var decodedResponse = json.decode(response.body);
      print(decodedResponse);
      jwt.setJwtToken(decodedResponse["access_token"]);
      final newPrefs = await prefs;
      newPrefs.setString('jwt', decodedResponse["access_token"]);
      ref.read(pageProvider.notifier).setPage(const ProfilePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            bottom: 120,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'error';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredUsername = value!;
                },
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'error';
                  }
                  return null;
                },
                obscureText: !showPassword,
                controller: passwordTextController,
                onSaved: (value) {
                  _enteredPassword = value!;
                },
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Checkbox(
                      value: showPassword,
                      onChanged: (value) {
                        setState(() {
                          showPassword = value!;
                        });
                      }),
                  const Text('Show password'),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton(
                onPressed: () {
                  _authorize(ref);
                },
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
