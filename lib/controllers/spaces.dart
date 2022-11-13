import 'dart:async';
import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

class SpacesController{
  final _database = RTDBController().database;
  late StreamSubscription _spacesStream;
  late StreamController<List> spacesStreamController = StreamController<List>();

  void activateListenersSpaces() {
    _spacesStream = _database.child('spaces/').onValue.listen((event) {
      Iterable<DataSnapshot> spaces = event.snapshot.children;
      //print(spaces.map((e) => e.key as String).toList());
      //print(spaces.map((e) => e.value as int).toList());
      List<String> lots = spaces.map((e) => e.key as String).toList();
      List<int> status = spaces.map((e) => e.value as int).toList();
      spacesStreamController.add([lots, status]);
    });
  }

  void deactivateListenerSpaces() {
    _spacesStream.cancel();
  }

}