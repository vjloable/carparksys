import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

Widget showReserveLot(BuildContext context, String lot){
  return Stack(
    children: [
      Positioned(
        top: 7,
        left: 7,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
          splashRadius: 1,
        ),
      ),
      SizedBox(
        height: 320,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  height: 28,
                  width: 300,
                    child: Text(
                      'Do you confirm this reservation?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Swatch.buttons.shade900
                      ),
                    ),
                ),
              ),
              Container(
                  height: 160,
                  width: 360,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(30)
                    ),
                    color: Swatch.buttons.shade400,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Material(
                          elevation: 10,
                          color: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              lot,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Swatch.buttons.shade600
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100, width: 1, child: VerticalDivider(color: Swatch.prime.shade100, thickness: 1)),
                      const SizedBox(
                        width: 140,
                        child: Text(
                          'Your Parking Space',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Swatch.prime
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              const SizedBox(width: 1, height: 5),
              SizedBox(
                  height: 55,
                  width: 360,
                  child: SlideAction(
                    sliderButtonIconSize: 20,
                    sliderButtonIconPadding: 10,
                    innerColor: Swatch.prime,
                    outerColor: Swatch.buttons.shade600,
                    elevation: 15,
                    text: '   Slide to confirm',
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Swatch.prime.shade100),
                    onSubmit: () {

                    },
                  )
              ),
              const SizedBox(width: 1, height: 20)
            ],
          ),
        ),
      ),
    ]
  );
}