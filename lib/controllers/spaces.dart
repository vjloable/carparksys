import 'dart:async';
import 'package:carparksys/services/db.dart';
import 'package:firebase_database/firebase_database.dart';

class SpacesController{
  RTDBService rtdb = RTDBService();
  late StreamSubscription _spacesStream;

  late StreamController<List> spacesStreamController = StreamController<List>();

  int _countOccupied = 0;
  int _countAvailable = 0;
  int _countReserved = 0;

  void resetCounts(){
    _countOccupied = 0;
    _countAvailable = 0;
    _countReserved = 0;
  }

  void activateListenersSpaces() {
    _spacesStream = rtdb.databaseRef.child('spaces/').onValue.listen((event) {
      Iterable<DataSnapshot> spaces = event.snapshot.children;
      List<String> lots = spaces.map((e) => e.key as String).toList();
      List<int> status = spaces.map((e) => e.child('status').value as int).toList();
      spacesStreamController.add([lots, status]);

      resetCounts();
      (status.isEmpty)
          ? resetCounts()
          : status.forEach((element) =>
      (element == 1)
          ? _countAvailable++
          : (element == 2)
          ? _countOccupied++
          : (element == 3)
          ? _countReserved++
          : null);
      updateStatistics();

    });
  }

  Future<void> updateStatistics() async {
    await rtdb.databaseRef.update(
        {
          'stats/available': _countAvailable,
          'stats/occupied': _countOccupied,
          'stats/reserved': _countReserved,
        }
    );
    resetCounts();
  }

  void deactivateListenerSpaces() {
    _spacesStream.cancel();
  }
}