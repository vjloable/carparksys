import 'dart:async';
import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

class StatisticsController{
  final _database = RTDBController().database;
  late StreamSubscription _statsStream;
  late StreamController<Iterable<DataSnapshot>> statisticsStreamController = StreamController<Iterable<DataSnapshot>>();

  void activateListenersStats() {
    _statsStream = _database.child('stats/').onValue.listen((event) {
      Iterable<DataSnapshot> stats = event.snapshot.children;
      statisticsStreamController.add(stats);
    });
  }

  void deactivateListenerStats() {
    _statsStream.cancel();
  }

}