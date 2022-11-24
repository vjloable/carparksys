import 'dart:async';
import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

class StatisticsController{
  RTDBService rtdb = RTDBService();
  late StreamSubscription _statsStream;
  late StreamController<Iterable<DataSnapshot>> statisticsStreamController = StreamController<Iterable<DataSnapshot>>();

  void activateListenersStats() {
    _statsStream = rtdb.databaseRef.child('stats/').onValue.listen((event) {
      Iterable<DataSnapshot> stats = event.snapshot.children;
      statisticsStreamController.add(stats);
    });
  }

  void deactivateListenerStats() {
    _statsStream.cancel();
  }

}