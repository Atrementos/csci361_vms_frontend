import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DummyName'),
      ),
      body: const Column(
        children: [
          Text('DummyRows'),
          Text('DummyRows'),
          Text('DummyRows'),
        ],
      ),
    );
  }
}
