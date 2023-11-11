import 'package:csci361_vms_frontend/pages/driver_page.dart';
import 'package:csci361_vms_frontend/pages/fueling_person_page.dart';
import 'package:csci361_vms_frontend/pages/maintenance_person_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';
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
  @override
  void initState() {
    super.initState();
    final url = Uri.parse('http://vms-api.madi-wka.xyz/user/me');
    http.get(url, headers: {"access_token": ref.read(jwt.jwtTokenProvider)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          Text(
            'Edit your profile here',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
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
      drawer: const AdminDrawer(),
    );
  }
}
