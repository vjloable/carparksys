import 'package:intl/intl.dart';

class TimeRunner{
  String formatter(DateTime dateTime){
    return DateFormat('MM/dd/yyyy').add_jms().format(dateTime);
  }

  String now(){
    return formatter(DateTime.now());
  }
}