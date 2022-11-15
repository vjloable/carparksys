import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

RTDBService rtdbRef = RTDBService();

class Reserve{
  late DataSnapshot _snapshotCheck;

  Future<bool> reserve(lot) async {
    _snapshotCheck = await rtdbRef.database.child('spaces/$lot').get();
    if(_snapshotCheck.value != 1){
      return Future<bool>.value(false);
    }else{
      await rtdbRef.database.update(
          {
            'spaces/$lot': 3,
          }
      );
      return Future<bool>.value(true);
    }
  }



}