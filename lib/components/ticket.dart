import 'package:flutter/material.dart';

Widget showTicket(BuildContext context){
  return Stack(
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
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  color: Colors.grey,
                  height: 300,
                  width: 300,
                ),
              )
            ],
          ),
        )
      )
    ],
  );
}