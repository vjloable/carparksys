import 'package:carparksys/assets/swatches/custom_colors.dart';
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
              Container(
                color: Colors.white,
                height: 300,
                width: 300,
              )
            ],
          ),
        )
      )
    ],
  );
}