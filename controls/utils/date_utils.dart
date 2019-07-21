import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

DateTime toDatetime(x){
    if (x==null) return null;
    if (x is Timestamp ){
      return x.toDate();
    }
    if (x is DateTime) return x;
    if (x is String) return DateTime.parse(x);
    return null;
  }

String shortDateTimeInfo(DateTime d) {
  var h = DateTime.now();
  if (d.month == h.month && d.year == h.year && d.day == h.day)
    return formatDate(d, [HH, ':', nn]);
  if (d.year == h.year) return formatDate(d, [dd, '/', mm, ' ', HH, ':', nn]);
  return dateTimeToStr(d);
}

String dateToStr(DateTime d) {
  //  return d.day.toString().padLeft(2,'0')+'/'+d.month.toString().padLeft(2,'0')+'/'+d.year.toString();
  return formatDate(d, [dd, '/', mm, '/', yyyy]);
}

String ddmm(DateTime d) {
  return formatDate(d, [dd, '/', mm]);
}

String dateTimeToStr(DateTime d) {
  return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
}
