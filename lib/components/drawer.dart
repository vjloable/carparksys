import 'package:carparksys/components/ticket.dart';
import 'package:carparksys/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../assets/swatches/custom_colors.dart';
import '../pages/lots.dart';

Widget drawerHeader = UserAccountsDrawerHeader(
  accountName: Text(FirebaseAuth.instance.currentUser!.displayName!, style: TextStyle(fontFamily: 'Arial', color: Swatch.buttons.shade800)),
  accountEmail: Text(FirebaseAuth.instance.currentUser!.email!, style: TextStyle(fontFamily: 'Arial', color: Swatch.buttons.shade800)),
  currentAccountPicture: CircleAvatar(
    backgroundImage: NetworkImage(
        FirebaseAuth.instance.currentUser!.photoURL!,
    )
  )
);

Widget drawerItems(BuildContext context, int numPops) {
  return ListView(
    padding: EdgeInsets.zero,
    children: [
      drawerHeader,
      const ListTile(
        title: Text('Account'),
        leading: Icon(Icons.account_circle),
        onTap: null,
      ),
      ListTile(
        title: const Text('My Ticket'),
        leading: const Icon(Icons.confirmation_num_rounded),
        onTap: () {
          if (numPops == 2) {
            Navigator.of(context).pop();
          } else if (numPops == 3) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
          showModalBottomSheet(
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return showTicket(context);
              }
          );
        },
      ),
      ListTile(
        title: const Text('Lots'),
        leading: const Icon(Icons.dashboard_rounded),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LotsPage()),
          );
        },
      ),
      const ListTile(
        title: Text('Settings'),
        leading: Icon(Icons.settings_rounded),
        onTap: null,
      ),
      const ListTile(
        title: Text('Help'),
        leading: Icon(Icons.help),
        onTap: null,
      ),
      const Divider(thickness: 1),
      ListTile(
        title: const Text('Sign out'),
        leading: const Icon(Icons.logout_rounded),
        onTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          AuthService().signOut();
        },
      ),
    ],
  );
}