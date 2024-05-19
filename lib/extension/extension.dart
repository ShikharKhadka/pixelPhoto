import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get time {
    DateFormat outputFormat = DateFormat('MM/dd/yyyy');
    return outputFormat.format(this);
  }
}
