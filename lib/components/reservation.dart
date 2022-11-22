import 'dart:async';
import 'dart:io';

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
  SpacesController controllerSpaces = SpacesController();
  Reserve controllerReserve = Reserve();
  int isPassed = 2;
  final Widget _errorIcon = const Icon(Icons.error, color: SigCol.red);
  final Widget _passedIcon = const Icon(Icons.check_circle, color: SigCol.green);
  final Widget _waitingIcon = const Icon(Icons.access_time_filled_outlined, color: SigCol.orange);
  late StreamSubscription<List> spacesStreamSubscription;
  late List<String> _parkingLotsName = [];
  late Timer timer;
  late String _time = '';
  late bool _connectionResult = true;

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
    spacesStreamSubscription = controllerSpaces.spacesStreamController.stream.listen((event){
      setState(() {
        _parkingLotsName = event[0];
      });
    });
  }

  void updateSubmitIcon() {
    if(mounted){
      setState(() {
        isPassed = controllerReserve.getStateCheck();
      });
    }
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
            height: 400,
            child: Center(
              child: Visibility(
                visible: _connectionResult,
                replacement: Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(50)
                  ),
                  color: Swatch.prime,
                  child: Container(
                    height: 260,
                    width: 330,
                    padding: const EdgeInsets.all(40),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(radius: 70, backgroundColor: Swatch.buttons.shade800, child: const Icon(Icons.wifi_off, color: SigCol.red, size: 60)),
                          const SizedBox(height: 20),
                          Text('CONNECTION ERROR!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontWeight: FontWeight.bold, fontSize: 45)),
                          const SizedBox(height: 30),
                          Text('Slow or no Internet connection.', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 30)),
                          const SizedBox(height: 10),
                          Text('Check your connection, then try again', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 26)),
                        ],
                      ),
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 300,
                  width: 330,
                  child: FittedBox(
                    fit: BoxFit.contain,
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
                              submittedIcon: isPassed == 2 ? _waitingIcon : isPassed == 1 ? _passedIcon : _errorIcon,
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Swatch.prime.shade100),
                              onSubmit: () async {
                                await _updateConnectionStatus();
                                if (_connectionResult){
                                  await controllerReserve.reserve(widget._lot);
                                  updateSubmitIcon();
                                  Future.delayed(const Duration(seconds: 1));
                                }else{
                                  updateSubmitIcon();
                                }
                                Future.delayed(
                                    const Duration(milliseconds: 600),
                                        () => mounted ? Navigator.pop(context) : null
                                );
                              },
                            )
                        ),
                        const SizedBox(width: 1, height: 20)
                      ],
                    ),
                  ),
                ),
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
