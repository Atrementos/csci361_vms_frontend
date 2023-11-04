import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final void Function() switchPage;

  const DrawerTile({
    super.key,
    required this.title,
    required this.switchPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      onTap: () {
        Navigator.of(context).pop();
        switchPage();
      },
    );
  }
}
