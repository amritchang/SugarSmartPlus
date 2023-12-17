import 'package:intl/intl.dart';

enum DateFormatType {
  yearMonthDayDashed,
  monthNameDayCommaYear,
  monthNameCommaYear,
  yearMonthDayDashedCommaTime,
  hourMinuteAmPm,
  dayOnly,
  monthNameDayCommaYearTimeAmPm,
  deviceFormat,
}

extension DateFormatTypeExtension on DateFormatType {
  String get pattern {
    switch (this) {
      case DateFormatType.yearMonthDayDashed:
        return 'yyyy-MM-dd';
      case DateFormatType.monthNameDayCommaYear:
        return 'MMM dd, yyyy';
      case DateFormatType.monthNameCommaYear:
        return 'MMM, yyyy';
      case DateFormatType.yearMonthDayDashedCommaTime:
        return 'yyyy-MM-dd, HH:mm:ss';
      case DateFormatType.hourMinuteAmPm:
        return 'hh:mm a';
      case DateFormatType.dayOnly:
        return 'dd';
      case DateFormatType.monthNameDayCommaYearTimeAmPm:
        return 'MMM dd, yyyy, hh:mm a';
      case DateFormatType.deviceFormat:
        return 'yyyy-MM-dd HH:mm:ss.SSS';
    }
  }
}

String formatDate(String originalDate, DateFormatType inputDateType,
    DateFormatType outputDateType) {
  final inputFormat = DateFormat(inputDateType.pattern);
  final outputFormat = DateFormat(outputDateType.pattern);

  if (inputFormat == DateFormatType.deviceFormat) {
    final date = DateTime.parse(originalDate);
    return outputFormat.format(date);
  }

  final date = inputFormat.parse(originalDate);

  return outputFormat.format(date);
}
