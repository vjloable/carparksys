import 'package:intl/intl.dart';

class TimeRunner{
  String formatterMDY(DateTime dateTime){
    return DateFormat('MM/dd/yyyy').add_jms().format(dateTime);
  }

  DateTime now(){
    return DateTime.now();
  }
}