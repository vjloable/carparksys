import 'dart:async';

import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/controllers/reserve.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final StreamController<List<dynamic>> eventStreamController;
  const CountdownTimer({super.key, required this.eventStreamController});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  Duration myDuration = const Duration(milliseconds: 480000);
  late StreamSubscription<List<dynamic>> eventStreamSubscription;

  @override
  void initState() {
    super.initState();
    eventlistenerCD();
  }


  void eventlistenerCD() {
    eventStreamSubscription = widget.eventStreamController.stream.listen((event){
      if(event.first == 'startTimer'){
        startTimer();
      }else if(event.first == 'stopTimer'){
        stopTimer();
      }else if(event.first == 'resetTimer'){
        resetTimer(event.last);
      }
    });
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    Reserve().dislodge(Reserve().getSelectedLot());
    setState(() => countdownTimer.cancel());
  }

  // Step 5
  void resetTimer(int ms) {
    setState(() => myDuration = Duration(milliseconds: ms));
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds <= 0) {
        stopTimer();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    eventStreamSubscription.cancel();
    countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // final days = strDigits(myDuration.inDays);
    // final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Text(
      '$minutes : $seconds',
      //'${myDuration.inSeconds} s',
      style: TextStyle(
          fontWeight: FontWeight.w300,
          fontFamily: 'Arial',
          color: Swatch.buttons.shade600,
          fontSize: 18),
    );
  }
}
