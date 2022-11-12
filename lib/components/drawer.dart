import 'package:carparksys/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../assets/swatches/custom_colors.dart';
import '../pages/lots.dart';

Widget drawerHeader = UserAccountsDrawerHeader(
  accountName: Text(FirebaseAuth.instance.currentUser!.displayName!, style: TextStyle(fontFamily: 'Arial', color: Swatch.buttons.shade800)),
  accountEmail: Text(FirebaseAuth.instance.currentUser!.email!, style: TextStyle(fontFamily: 'Arial', color: Swatch.buttons.shade800)),
  currentAccountPicture: CircleAvatar(
    backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
    //Icon(Icons.account_circle, size: 70, color: Swatch.buttons.shade400),
  ),
);

Widget drawerItems(BuildContext context, int numPops) {
  return ListView(
    padding: EdgeInsets.zero,
    children: [
      drawerHeader,
      ListTile(
        title: const Text('Account'),
        leading: const Icon(Icons.account_circle),
        onTap: () {},
      ),
      ListTile(
        title: const Text('My Ticket'),
        leading: const Icon(Icons.confirmation_num_rounded),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Lots'),
        leading: const Icon(Icons.dashboard_rounded),
        onTap: () {
          Navigator.of(context)..pop()..push(MaterialPageRoute(builder: (context) => const LotsPage()),);
        },
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
          AuthService().signOut();
          // switch(numPops){
          //   case 2: {
          //     Navigator.of(context)..pop()..pop();
          //   }
          //   break;
          //
          //   case 3: {
          //     Navigator.of(context)..pop()..pop()..pop();
          //   }
          // }
        },
      ),
    ],
  );
}