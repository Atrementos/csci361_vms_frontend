import 'package:csci361_vms_frontend/pages/profile_page.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    // String _enteredUsername;
    // String _enteredPassword;

    void _authorize() {
      if (_formKey.currentState!.validate()) {
        // TODO (Successful authorization -> switch page?)
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
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton(
                onPressed: () {
                  ref.read(pageProvider.notifier).setPage(const ProfilePage());
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
