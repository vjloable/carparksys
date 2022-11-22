import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

RTDBService rtdb = RTDBService();

class Reserve{
  late DataSnapshot _snapshotCheck;
  late DataSnapshot _snapshotUser;
  static int stateCheck = 0;

  int getStateCheck(){
    return stateCheck;
  }

  void updateStateCheck(int state){
    stateCheck = state;
  }

  Future<void> reserve(lot) async {
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
                  'lot' : {
                    '$lot' : 3,
                  }
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
                'lot' : 3,
              }
            });
        await rtdb.databaseRef.update(
            {
              'spaces/$lot': 3,
            });
        updateStateCheck(1);
      }
    }
    print(stateCheck);
  }
}