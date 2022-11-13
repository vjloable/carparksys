import 'package:carparksys/services/rtdb.dart';
import 'package:firebase_database/firebase_database.dart';

RTDBController rtdbRef = RTDBController();

class Reserve{
  late DataSnapshot _snapshotAvailable;
  late DataSnapshot _snapshotReserved;

  Future<void> reserve(lot) async {
    _snapshotAvailable = await rtdbRef.database.child('stats/available').get();
    _snapshotReserved = await rtdbRef.database.child('stats/reserved').get();
    await rtdbRef.database.update(
        {
          'spaces/$lot': 3,
          'stats/reserved': (_snapshotReserved.value as int) + 1,
          'stats/available': (_snapshotAvailable.value as int) - 1,
        }
    );
  }



}