import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDriveTaskPage extends ConsumerStatefulWidget {
  final int driverId;

  const CreateDriveTaskPage({super.key, required this.driverId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateDriveTaskPageState();
  }
}

class _CreateDriveTaskPageState extends ConsumerState<CreateDriveTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            TextFormField(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        ),
      ),
    );
  }
}
