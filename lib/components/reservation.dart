import 'dart:async';

import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/components/time_runner.dart';
import 'package:carparksys/controllers/reserve.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../controllers/spaces.dart';

class ReserveLot extends StatefulWidget {
  final String _lot;
  const ReserveLot(this._lot, {super.key});

  @override
  State<ReserveLot> createState() => _ReserveLotState();
}

class _ReserveLotState extends State<ReserveLot> {
  late List<String> _parkingLotsName = [];
  late List<int> _parkingLotsStatus = [];
  late String _time = '';
  SpacesController controllerSpaces = SpacesController();
  late Stream<List> spacesStream = controllerSpaces.spacesStreamController.stream;
  late StreamSubscription<List> spacesStreamSubscription;
  late Timer timer;

  final Widget _errorIcon = const Icon(Icons.error, color: SigCol.red);
  final Widget _passedIcon = const Icon(Icons.check_circle, color: SigCol.green);
  final Widget _progBar = const Icon(Icons.access_time_filled_outlined, color: SigCol.orange);
  
  int isPassed = 2;

  @override
  void initState() {
    super.initState();
    _time = TimeRunner().now();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => updateTime());
    controllerSpaces.activateListenersSpaces();
    spacesStreamListener();
  }

  void updateTime() {
    setState(() {
      _time = TimeRunner().now();
    });
  }

  void spacesStreamListener() {
    spacesStreamSubscription = spacesStream.listen((event){
      setState(() {
        _parkingLotsName = event[0];
        _parkingLotsStatus = event[1];
      });
    });
  }

  void updateSubmitIcon() {
    setState(() {
      isPassed = Reserve().stateCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  widget._lot,
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
                        submittedIcon: isPassed == 2 ? _progBar : isPassed == 1 ? _passedIcon : _errorIcon,
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Swatch.prime.shade100),
                        onSubmit: () async {
                          await Reserve().reserve(widget._lot);
                          Future.delayed(const Duration(seconds: 1));
                          updateSubmitIcon();
                          Future.delayed(
                              const Duration(milliseconds: 200),
                                  () => Navigator.pop(context)
                          );
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

  @override
  void deactivate() {
    timer.cancel();
    spacesStreamSubscription.cancel();
    controllerSpaces.deactivateListenerSpaces();
    super.deactivate();
  }

}