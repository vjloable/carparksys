import 'dart:async';

import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Reserve{
  RTDBService rtdb = RTDBService();
  late DataSnapshot _snapshotCheck;
  late DataSnapshot _snapshotUser;
  late StreamSubscription _reserveStream;
  late StreamController<List<dynamic>> reserveStreamController = StreamController<List<dynamic>>();
  static int _stateCheck = 0;
  static String _selectedLot = '...';

  int getStateCheck(){
    return _stateCheck;
  }

  Future<void> updateStateCheck(int state) async{
    _stateCheck = state;
  }

  String getSelectedLot(){
    return _selectedLot;
  }

  void updateSelectedLot(String lot){
    _selectedLot = lot;
  }

  void activateListenersReserve() {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    String lot = '...';
    bool hasTicket = false;
    _reserveStream = rtdb.databaseRef.child('users/$userId').onValue.listen((event) async {
      if(event.snapshot.exists){
        if(event.snapshot.child('has_ticket').value == true) {
          hasTicket = true;
          lot = (await rtdb.databaseRef.child('users/$userId/lot').get()).value.toString();
        }else{
          hasTicket = false;
          lot = '...';
        }
      }
      reserveStreamController.add([lot, hasTicket]);
    });
  }

  Future<List<dynamic>> getRetention() async {
    int returnable = 480000;
    bool isNotDone = false;
    var userId = FirebaseAuth.instance.currentUser?.uid;
    _snapshotUser = await rtdb.databaseRef.child('users/$userId').get();
    if(_snapshotUser.exists){
      if(_snapshotUser.child('has_ticket').value == true) {
        int timestop = (await rtdb.databaseDB.ref('users/$userId/timestop').get()).value as int;
        int timepause = DateTime.now().millisecondsSinceEpoch;
        if(timepause < timestop){
          returnable = (timestop - timepause);
          isNotDone = true;
        }
      }
    }
    return [isNotDone, returnable];
    //return returnable;
  }

  Future<void> dislodge(String lot) async {
    print('dislodged!!!!');
    String localLot = lot;
    var userId = FirebaseAuth.instance.currentUser?.uid;
    _snapshotUser = await rtdb.databaseDB.ref('users/$userId').get();
    if (_snapshotUser.exists) {
      print(lot);
      if(localLot == '...' || localLot == 'null'){
        localLot = (await rtdb.databaseDB.ref('users/$userId/lot').get()).value.toString();
      }
      await rtdb.databaseRef.update(
          {
            'spaces/$localLot': 1,
          });
      await rtdb.databaseDB.ref('users/$userId').update(
          {
            'has_ticket' : false,
          });
    }
  }

  Future<void> reserve(String lot) async {
    _snapshotCheck = await rtdb.databaseRef.child('spaces/$lot').get();
    if(_snapshotCheck.value != 1){
      await updateStateCheck(3);
    }else {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      _snapshotUser = await rtdb.databaseRef.child('users/$userId').get();
      if(_snapshotUser.exists){
        if(_snapshotUser.child('has_ticket').value == false) {
          updateSelectedLot(lot);
          int timestart = DateTime.now().millisecondsSinceEpoch;
          int timestop = timestart + (1000 * 480);
          await updateStateCheck(2);
          await rtdb.databaseRef.update(
              {
                'users/$userId' : {
                  'has_ticket' : true,
                  'timestart' : timestart,
                  'timestop' : timestop,
                  'lot' : lot,
                }
              });
          await rtdb.databaseRef.update(
              {
                'spaces/$lot': 3,
              });
        }else{
          //Already reserved
          await updateStateCheck(3);
        }
      }else{
        updateSelectedLot(lot);
        await updateStateCheck(1);
        int timestart = DateTime.now().millisecondsSinceEpoch;
        int timestop = timestart + (1000 * 480);
        await rtdb.databaseRef.update(
            {
              'users/$userId' : {
                'has_ticket' : true,
                'timestart' : timestart,
                'timestop' : timestop,
                'lot' : lot,
              }
            });
        await rtdb.databaseRef.update(
            {
              'spaces/$lot': 3,
            });
      }
    }
  }

  void deactivateListenerReserve() {
    _reserveStream.cancel();
  }
}