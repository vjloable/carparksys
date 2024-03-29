import 'dart:async';
import 'package:carparksys/services/db.dart';
import 'package:firebase_database/firebase_database.dart';

class SuggestionController{
  RTDBService rtdb = RTDBService();
  late String _prevSuggestion = '...';
  late StreamSubscription _suggestionStream;
  late StreamController<List> suggestionStreamController = StreamController<List>();

  void activateListenersSuggestion() {
    _suggestionStream = rtdb.databaseRef.child('spaces/').onValue.listen((event) {
      List<String> suggestions = [];
      Iterable<DataSnapshot> snapshot = event.snapshot.children;
      List<String> lots = snapshot.map((e) => e.key as String).toList();
      List<int> status = snapshot.map((e) => e.child('status').value as int).toList();

      for(int i = 0; i < lots.length; i++){
        if(status[i] == 1) {
          suggestions.add(lots[i].toString());
        }
      }

      if(_prevSuggestion == '...'){
        suggestionStreamController.add(suggestions);
      }else if(suggestions.contains(_prevSuggestion)){
        suggestions = [];
        suggestions.add(_prevSuggestion);
        suggestionStreamController.add(suggestions);
      }else{
        suggestionStreamController.add(suggestions);
      }
    });
  }

  void setPrevSuggestion(String lot){
    _prevSuggestion = lot;
  }

  void deactivateListenerSuggestion() {
    _suggestionStream.cancel();
  }

}