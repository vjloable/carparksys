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
                          color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                ),
              ),
              Material(
                elevation: 10,
                borderRadius: const BorderRadius.all(
                    Radius.circular(10)
                ),
                color: Swatch.prime,
                child: SizedBox(
                    height: 160,
                    width: 340,
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
                            elevation: 3,
                            color: Theme.of(context).colorScheme.background,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                lot,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimary
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100, width: 1, child: VerticalDivider(color: Swatch.buttons.shade600, thickness: 1)),
                        SizedBox(
                          width: 140,
                          child: Text(
                            'Your Parking Space',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                                color: Swatch.buttons.shade800
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              ),
              const SizedBox(width: 1, height: 10),
              SizedBox(
                  height: 55,
                  width: 340,
                  child: SlideAction(
                    sliderButtonIconSize: 20,
                    sliderButtonIconPadding: 10,
                    innerColor: Swatch.prime,
                    outerColor: Swatch.buttons.shade900,
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