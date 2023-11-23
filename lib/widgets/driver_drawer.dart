import 'package:csci361_vms_frontend/pages/driving_history_page.dart';
import 'package:csci361_vms_frontend/pages/vehicle_details_page.dart';
import 'package:csci361_vms_frontend/providers/driver_vehicle_provider.dart';
import 'package:csci361_vms_frontend/providers/role_provider.dart';
import 'package:csci361_vms_frontend/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';

import '../pages/current_assignments_page.dart';
import '../pages/profile_page.dart';
import '../providers/user_id_provider.dart';

class DriverDrawer extends ConsumerWidget {
  const DriverDrawer({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ref
                    .read(pageProvider.notifier)
                    .setPage(const ProfilePage());
              },
            ),
          ),
          DrawerTile(
            title: 'Vehicle Detail',
            switchPage: () {
              // Change this to the appropriate page
              ref
                  .read(pageProvider.notifier)
                  .setPage(VehicleDetailsPage(vehicleId: ref.read(vehicleId.vehicleIdProvider)));
            },
          ),
          DrawerTile(
            title: 'Driving History',
            switchPage: () {
              // Change this to the appropriate page
              ref
                  .read(pageProvider.notifier)
                  .setPage(DriverHistoryPage(driverId: ref.read(userId.idProvider)));
            },
          ),
          DrawerTile(
            title: 'Current Assignments',
            switchPage: () {
              // Change this to the appropriate page
              ref
                  .read(pageProvider.notifier)
                  .setPage(CurrentAssignmentPage(driverId: ref.read(userId.idProvider)));
            },
          ),
        ],
      ),
    );
  }
}
