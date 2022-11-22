import 'package:intl/intl.dart';

class TimeRunner{
  String formatterMDY(DateTime dateTime){
    return DateFormat('MM/dd/yyyy').add_jms().format(dateTime);
  }

  int countdown(int seconds){
    return DateTime.now().millisecondsSinceEpoch + 1000 * seconds;
  }

  DateTime now(){
    return DateTime.now();
  }
}