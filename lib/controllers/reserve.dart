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

  int getStateCheck(){
    return _stateCheck;
  }

  void updateStateCheck(int state){
    _stateCheck = state;
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

  Future<void> dislodge(String lot) async {
    print(lot);
    var userId = FirebaseAuth.instance.currentUser?.uid;
    //var lot = (await rtdb.databaseRef.child('users/$userId/lot').get()).value.toString();
    // await rtdb.databaseDB.ref('spaces').update(
    //     {
    //       lot : 1,
    //     });
    await rtdb.databaseDB.ref('users/$userId').update(
        {
          'has_ticket' : false,
          'lot' : lot,
        });
  }

  Future<void> reserve(String lot) async {
    _snapshotCheck = await rtdb.databaseRef.child('spaces/$lot').get();
    if(_snapshotCheck.value != 1){
      updateStateCheck(3);
    }else {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      _snapshotUser = await rtdb.databaseRef.child('users/$userId').get();
      if(_snapshotUser.exists){
        if(_snapshotUser.child('has_ticket').value == false) {
          await rtdb.databaseRef.update(
              {
                'users/$userId' : {
                  'has_ticket' : true,
                  'lot' : lot,
                }
              });
          await rtdb.databaseRef.update(
              {
                'spaces/$lot': 3,
              });
          updateStateCheck(2);
        }else{
          //Already reserved
          updateStateCheck(3);
        }
      }else{
        await rtdb.databaseRef.update(
            {
              'users/$userId' : {
                'has_ticket' : true,
                'lot' : lot,
              }
            });
        await rtdb.databaseRef.update(
            {
              'spaces/$lot': 3,
            });
        updateStateCheck(1);
      }
    }
  }

  void deactivateListenerReserve() {
    _reserveStream.cancel();
  }
}