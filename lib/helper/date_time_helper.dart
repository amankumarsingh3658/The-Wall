// returns the timestamp to String

// yyyymmdd or ddmmyyyy

import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timeStamp) {
  // convert the time stamp to date
  DateTime timestamp = timeStamp.toDate();

  // Grab the year month and date

  String year = timestamp.year.toString();
  String month = timestamp.month.toString();
  String day = timestamp.day.toString();

  // final formatted String
  String formattedString = "$day/$month/$year";
  return formattedString;
}
