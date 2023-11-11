import 'dart:convert';

import 'package:csci361_vms_frontend/pages/profile_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    var _userUsername = '';
    var _userPassword = '';
    final passwordTextController = TextEditingController();
    // String _enteredUsername;
    // String _enteredPassword;

    void _authorize() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final url = Uri.parse('http://vms-api.madi-wka.xyz/token');
        print('Username: ' + _userUsername);
        print('Password: ' + _userPassword);
        final response = await http.post(
          url,
          body: {
            "username": _userUsername,
            "password": _userPassword,
          },
        );
        // final response = await http.get(url);
        if (response.statusCode != 200) {
          print(response.statusCode);
          print('Error');
          passwordTextController.clear();
          return;
        }
        var decodedResponse = json.decode(response.body);
        jwt.setJwtToken(decodedResponse["access_token"]);

        print(decodedResponse);
        ref.read(pageProvider.notifier).setPage(const ProfilePage());
      }
    }

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
                  _userUsername = value!;
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
                obscureText: true,
                controller: passwordTextController,
                onSaved: (value) {
                  _userPassword = value!;
                },
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton(
                onPressed: () {
                  _authorize();
                  // ref.read(pageProvider.notifier).setPage(const ProfilePage());
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
