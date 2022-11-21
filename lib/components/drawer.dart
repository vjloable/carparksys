import 'dart:async';
import 'dart:io';

import 'package:carparksys/components/ticket.dart';
import 'package:carparksys/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../assets/swatches/custom_colors.dart';
import '../controllers/reserve.dart';
import '../controllers/spaces.dart';
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

class MyDrawer extends StatefulWidget {
  final int numPops;
  const MyDrawer(this.numPops, {super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late List<String> _parkingLotsName = [];
  SpacesController controllerSpaces = SpacesController();
  late Stream<List> spacesStream = controllerSpaces.spacesStreamController.stream;
  late StreamSubscription<List> spacesStreamSubscription;
  late bool _connectionResult = true;

  @override
  void initState() {
    super.initState();
    controllerSpaces.activateListenersSpaces();
    spacesStreamListener();
  }

  void spacesStreamListener() {
    spacesStreamSubscription = spacesStream.listen((event){
      setState(() {
        _parkingLotsName = event[0];
      });
    });
  }

  Future<void> _updateConnectionStatus() async {
    var reliabilityCheck = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');
      if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
        reliabilityCheck = true;
      } else {
        reliabilityCheck = false;
      }
    } on SocketException catch (_) {
      reliabilityCheck = false;
    }

    setState((){
      _connectionResult = reliabilityCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            if (widget.numPops == 2) {
              Navigator.of(context).pop();
            } else if (widget.numPops == 3) {
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
              MaterialPageRoute(builder: (context) => LotsPage(_connectionResult)),
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
        ListTile(
          title: const Text('RESET',style: TextStyle(color: Colors.red)),
          leading: const Icon(Icons.keyboard_return),
          onTap: () async {
            await _updateConnectionStatus();
            if(_connectionResult){
              Map<String, int> resetter = { for (var e in _parkingLotsName) e : 1 };
              await rtdbRef.databaseRef.child('spaces').update(
                  resetter
              );
            }
          },
        ),
      ],
    );
  }

  @override
  void deactivate() {
    spacesStreamSubscription.cancel();
    controllerSpaces.deactivateListenerSpaces();
    super.deactivate();
  }
} 