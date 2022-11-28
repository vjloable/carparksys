import 'package:intl/intl.dart';

class TimeRunner{
  String formatterMDY(DateTime dateTime){
    return DateFormat('MM/dd/yyyy').add_jms().format(dateTime);
  }

  String formatterMDYMS(DateTime dateTime){
    return (DateFormat('').add_jms().format(dateTime)).trim();
  }

  String fromEpoch(int ms){
    return formatterMDYMS(DateTime.fromMillisecondsSinceEpoch(ms));
  }

  int toEpoch(){
    return now().millisecondsSinceEpoch;
  }

  DateTime now(){
    return DateTime.now();
  }
}