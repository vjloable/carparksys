import 'dart:async';

import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/components/time_runner.dart';
import 'package:carparksys/controllers/reserve.dart';
import 'package:carparksys/main.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with SingleTickerProviderStateMixin{
  late StreamSubscription<List<dynamic>> eventStreamSubscription;
  late int endTime = TimeRunner().toEpoch();
  late int displayTime = 480000;
  late Timer countdownTimer = Timer.periodic(const Duration(milliseconds: 500), (_) => setCountDown());

  @override
  void initState() {
    super.initState();
    eventlistenerCD();
  }

  void eventlistenerCD() {
    eventStreamSubscription = MyApp.eventstreamController.stream.listen((event) {
      print(event.first);
      if(event.first == 'startTimer'){
        startTimer();
      }else if(event.first == 'stopTimer'){
        stopTimer();
      }else if(event.first == 'resetTimer'){
        resetTimer(event.last);
      }else if(event.first == 'countdownTimer'){
        endTime = event.last;
        print('endTime in event: $endTime');
      }else if(event.first == 'resetArrived'){
        endTime = event.last;
        print('reset arrived');
      }
    });
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(milliseconds: 500), (_) => setCountDown());
  }

  void stopTimer() {
    Reserve().dislodge(Reserve().getSelectedLot());
    setState(() => countdownTimer.cancel());
  }

  // Step 5
  void resetTimer(int ms) {
    setState(() => endTime = ms);
  }

  // Step 6
  void setCountDown() {
    int end = endTime;
    setState(() {
      final milliseconds = (end - TimeRunner().toEpoch());
      if (milliseconds <= 0) {
        stopTimer();
      } else {
        displayTime = milliseconds;
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
    final minutes = strDigits(Duration(milliseconds: displayTime).inMinutes.remainder(60));
    final seconds = strDigits(Duration(milliseconds: displayTime).inSeconds.remainder(60));
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
