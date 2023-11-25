import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:http/http.dart' as http;

class AssignDriverPage extends ConsumerStatefulWidget {
  final int vehicleId;

  const AssignDriverPage({super.key, required this.vehicleId});

  @override
  ConsumerState<AssignDriverPage> createState() {
    return _AssignDriverPageState();
  }
}

class _AssignDriverPageState extends ConsumerState<AssignDriverPage> {
  final TextEditingController driverIdController = TextEditingController();

  void assignDriver() async {
    if (driverIdController.text.trim().isEmpty ||
        int.tryParse(driverIdController.text) == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter a proper driver id'),
          ),
        );
      }
    }
    final url = Uri.parse(
        'http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}/driver/${driverIdController.text}');
    final response = await http.patch(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${ref.read(jwt.jwtTokenProvider)}',
      },
    );
    if (response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The driver was successfully assigned.'),
          ),
        );
      }
    } else if (response.statusCode == 404) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Such driver does not exist'),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Some unexpected error occurred when assigning a driver'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign a driver'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: driverIdController,
              decoration: const InputDecoration(
                label: Text('Driver ID'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                assignDriver();
              },
              child: const Text('Assign a driver'),
            ),
          ],
        ),
      ),
    );
  }
}
