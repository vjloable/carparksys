import 'dart:async';
import 'package:carparksys/controllers/reserve.dart';
import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

class SpacesController{
  final _database = RTDBService().databaseRef;
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
    _spacesStream = _database.child('spaces/').onValue.listen((event) {
      Iterable<DataSnapshot> spaces = event.snapshot.children;
      List<String> lots = spaces.map((e) => e.key as String).toList();
      List<int> status = spaces.map((e) => e.value as int).toList();
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
    await rtdbRef.databaseRef.update(
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