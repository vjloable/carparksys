import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class DBController{
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _statsStream;
  late StreamController<Iterable<DataSnapshot>> dbStreamController = StreamController<Iterable<DataSnapshot>>();

  void activateListenersStats(){
    _statsStream = _database.child('stats/').onValue.listen((event) {
      Iterable<DataSnapshot> liveCounter = event.snapshot.children;
      dbStreamController.add(liveCounter);
    });
  }

}