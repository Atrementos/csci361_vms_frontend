import 'package:csci361_vms_frontend/pages/create_user_page.dart';
import 'package:csci361_vms_frontend/pages/profile_page.dart';
import 'package:csci361_vms_frontend/pages/search_all_page.dart';
import 'package:csci361_vms_frontend/pages/vehicles_page.dart';
import 'package:csci361_vms_frontend/providers/role_provider.dart';
import 'package:csci361_vms_frontend/widgets/drawer_tile.dart';
import 'package:csci361_vms_frontend/widgets/driver_drawer.dart';
import 'package:csci361_vms_frontend/widgets/fueling_person_drawer.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.read(userRole.roleProvider) != 'Admin') {
      if (ref.read(userRole.roleProvider) == 'Maintenance') {
        return const MaintenanceDrawer();
      } else if (ref.read(userRole.roleProvider) == 'Driver') {
        return const DriverDrawer();
      } else if (ref.read(userRole.roleProvider) == 'Fueling') {
        return const FuelingPersonDrawer();
      }
    }
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.95),
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.65),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(top: 35),
              leading: Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    ref.read(userRole.roleProvider),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(pageProvider.notifier).setPage(const ProfilePage());
              },
            ),
          ),
          DrawerTile(
            title: 'Vehicles',
            switchPage: () {
              ref.read(pageProvider.notifier).setPage(const VehiclesPage());
            },
          ),
          DrawerTile(
            title: 'Search all',
            switchPage: () {
              ref.read(pageProvider.notifier).setPage(const SearchAllPage());
            },
          ),
          DrawerTile(
            title: 'Create a user',
            switchPage: () {
              ref.read(pageProvider.notifier).setPage(const CreateUserPage());
            },
          ),
        ],
      ),
    );
  }
}
