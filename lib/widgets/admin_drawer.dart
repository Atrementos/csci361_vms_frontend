import 'package:csci361_vms_frontend/pages/fueling_persons_page.dart';
import 'package:csci361_vms_frontend/pages/profile_page.dart';
import 'package:csci361_vms_frontend/pages/drivers_page.dart';
import 'package:csci361_vms_frontend/pages/search_all_page.dart';
import 'package:csci361_vms_frontend/pages/test_page.dart';
import 'package:csci361_vms_frontend/pages/vehicles_page.dart';
import 'package:csci361_vms_frontend/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/page_provider.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

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
                title: Text(
                  'Profile',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(pageProvider.notifier).setPage(const ProfilePage());
                },
              )
              // Row(
              //   children: [
              //     Icon(
              //       Icons.account_circle,
              //       color: Theme.of(context).colorScheme.primary,
              //       size: 40,
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Text(
              //       'Profile',
              //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //           color: Theme.of(context).colorScheme.onPrimaryContainer),
              //     ),
              //   ],
              // ),
              ),
          DrawerTile(
            title: 'Vehicles',
            switchPage: () {
              ref.read(pageProvider.notifier).setPage(VehiclesPage());
            },
          ),
          DrawerTile(
            title: 'Drivers',
            switchPage: () {
              ref.read(pageProvider.notifier).setPage(const DriversPage());
            },
          ),
          DrawerTile(
            title: 'Fueling persons',
            switchPage: () {
              ref
                  .read(pageProvider.notifier)
                  .setPage(const FuelingPersonsPage());
            },
          ),
          DrawerTile(
            title: 'Search all',
            switchPage: () {
              ref.read(pageProvider.notifier).setPage(const SearchAllPage());
            },
          ),
          DrawerTile(
            title: 'Test page',
            switchPage: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) {
                  return const TestPage();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
