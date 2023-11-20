import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/main.dart';
import 'package:csci361_vms_frontend/pages/update_assignment_page.dart';
import 'package:csci361_vms_frontend/pages/driver_page.dart';
import 'package:csci361_vms_frontend/pages/fueling_person_page.dart';
import 'package:csci361_vms_frontend/pages/maintenance_person_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MaintenancePersonPage extends ConsumerStatefulWidget {
  const MaintenancePersonPage({super.key});

  @override
  ConsumerState<MaintenancePersonPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<MaintenancePersonPage> {
  var _userInfo;

  void _loadUser() async {
    final url = Uri.parse('http://vms-api.madi-wka.xyz/user/me/');
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
      'Bearer ${ref.read(jwt.jwtTokenProvider)}'
    });
    var decodedResponse = json.decode(response.body);
    print(decodedResponse);
    print(ref.read(jwt.jwtTokenProvider));
    setState(() {
      _userInfo = decodedResponse;
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
            for (final info in _userInfo!.entries)
              Text(
                '${info.key}: ${info.value}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),

            TextButton(
              onPressed: () {
                ref
                    .read(pageProvider.notifier)
                    .setPage( UpdateAssignmentPage());
              },
              child: const Text('Maintenance Person Profile Page'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: mainContent,
      drawer: const MaintenanceDrawer(),
    );
  }
}
