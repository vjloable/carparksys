import 'package:flutter/material.dart';

import '../../assets/swatches/custom_colors.dart';

Widget drawerHeader = UserAccountsDrawerHeader(
  accountName: Text('Test Test', style: TextStyle(fontFamily: 'Arial', color: Swatch.buttons.shade800)),
  accountEmail: Text('testing@email.com', style: TextStyle(fontFamily: 'Arial', color: Swatch.buttons.shade800)),
  currentAccountPicture: CircleAvatar(
    child: Icon(Icons.account_circle, size: 70, color: Swatch.buttons.shade400),
  ),
);

Widget drawerItems(BuildContext context, int numPops) {
  return ListView(
    padding: EdgeInsets.zero,
    children: [
      drawerHeader,
      ListTile(
        title: const Text('My Ticket'),
        leading: const Icon(Icons.confirmation_num_rounded),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Slots'),
        leading: const Icon(Icons.dashboard_rounded),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Settings'),
        leading: const Icon(Icons.settings_rounded),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Help'),
        leading: const Icon(Icons.help),
        onTap: () {},
      ),
      const Divider(thickness: 1),
      ListTile(
        title: const Text('Sign out'),
        leading: const Icon(Icons.logout_rounded),
        onTap: () {
          switch(numPops){
            case 2: {
              Navigator.of(context)..pop()..pop();
            }
            break;

            case 3: {
              Navigator.of(context)..pop()..pop()..pop();
            }
          }
        },
      ),
    ],
  );
}