import 'package:flutter/material.dart';

Widget showTicket(BuildContext context){
  return SizedBox(
    height: 400,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 20,
          left: 10,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 30),
            splashRadius: 1,
          ),
        ),
        SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey,
                  height: 200,
                  width: 300,
                )
              ],
            ),
          )
        )
      ],
    ),
  );
}