import 'package:cloud_firestore/cloud_firestore.dart';

String formatData(Timestamp timestamp) {
  DateTime datetime = timestamp.toDate();

//calrender
  String year = datetime.year.toString();
  String month = datetime.month.toString();
  String day = datetime.day.toString();

  String formattedData = '$day/$month/$year';

  return formattedData;
}
