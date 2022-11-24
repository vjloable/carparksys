import 'dart:async';

import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/controllers/reserve.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final StreamController<String> eventStreamController;
  const CountdownTimer({super.key, required this.eventStreamController});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 10);
  late StreamSubscription<String> eventStreamSubscription;

  @override
  void initState() {
    super.initState();
    eventlistenerCD();
  }


  void eventlistenerCD() {
    eventStreamSubscription = widget.eventStreamController.stream.listen((event){
      if(event == 'startTimer'){
        startTimer();
      }else if(event == 'stopTimer'){
        stopTimer();
      }else if(event == 'resetTimer'){
        resetTimer(8);
      }
    });
  }

  void startTimer() {
    print('start : ${DateTime.now().millisecondsSinceEpoch}');
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    Reserve().dislodge(Reserve().getSelectedLot());
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer(int mins) {
    setState(() => myDuration = Duration(seconds: mins));
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds <= 0) {
        stopTimer();
        print('end   : ${DateTime.now().millisecondsSinceEpoch}');
      } else {
        print('during: ${DateTime.now().millisecondsSinceEpoch}');
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String strDigits(int n) => n.toString().padLeft(2, '0');
    // final days = strDigits(myDuration.inDays);
    // final hours = strDigits(myDuration.inHours.remainder(24));
    // final minutes = strDigits(myDuration.inMinutes.remainder(60));
    // final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Text(
      //'$minutes : $seconds',
      '${myDuration.inSeconds} s',
      style: TextStyle(
          fontWeight: FontWeight.w300,
          fontFamily: 'Arial',
          color: Swatch.buttons.shade600,
          fontSize: 18),
    );
  }
}
