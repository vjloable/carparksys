import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../assets/swatches/custom_colors.dart';

class CancelAlert extends StatefulWidget {
  const CancelAlert({Key? key}) : super(key: key);

  @override
  State<CancelAlert> createState() => _CancelAlertState();
}

class _CancelAlertState extends State<CancelAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Swatch.prime,
      elevation: 10,
      title: CircleAvatar(radius: 35, backgroundColor: Swatch.buttons.shade800, child: const Icon(Icons.wifi_off, color: SigCol.red, size: 30)),
      content: Container(
        height: 30,
        width: 250,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text('CONNECTION ERROR!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontWeight: FontWeight.bold, fontSize: 45)),
              const SizedBox(height: 20),
              Text('Signing out...', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 30)),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close_outlined, color: Swatch.buttons.shade800, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void deactivate() {
    FirebaseAuth.instance.signOut();
    super.deactivate();
  }
}
