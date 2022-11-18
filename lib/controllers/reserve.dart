import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

RTDBService rtdbRef = RTDBService();

class Reserve{
  late DataSnapshot _snapshotCheck;
  late int stateCheck = 1;

  Future<void> reserve(lot) async {
    _snapshotCheck = await rtdbRef.databaseRef.child('spaces/$lot').get();
    if(_snapshotCheck.value != 1){
      stateCheck = 0;
    }else{
      await rtdbRef.databaseRef.update(
          {
            'spaces/$lot': 3,
          }
      );
      stateCheck = 1;
    }
  }



}