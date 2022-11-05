import 'package:flutter/material.dart';

Widget showReserveLot(BuildContext context, String lot){
  return SizedBox(
    height: 300,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(lot),
          ElevatedButton(
            child: const Text('Return'),
            onPressed: (){
              Navigator.pop(context);
            }
          ),
        ],
      ),
    ),
  );
}