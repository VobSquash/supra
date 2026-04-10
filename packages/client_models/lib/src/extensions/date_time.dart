import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toDDMMYYYY() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toYYYYMMDD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String formateDateForUi() {
    //July 10, 1996
    return DateFormat().add_yMMMMd().format(this);
  }

  String formateTimeFromDate() {
    //14:30
    return DateFormat().add_Hm().format(this);
  }

  String toYYYYMMDDHHMMSS() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }

  String toYYYYMMDDHHMM() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }
  
  String formatForSynapseAPI({bool isUTC = true}) {
    return '${(isUTC ? toUtc() : this).toIso8601String().split('.').first}Z';
  }

  bool isSelectedDay(DateTime valueToCheck) {
    //logInfo('value1: $valueToCheck  $this');
    final isSameDay = valueToCheck.formateDateForUi() == formateDateForUi();

    return isSameDay;
  }

  String toDMM() {
    return DateFormat('d MMM').format(this);
  }

  String toHMS() {
    return DateFormat('Hms').format(this);
  }

  String toMMYYYY() {
    return DateFormat('MMMM yyyy').format(this);
  }

  String toHMM() {
    return DateFormat('H:mm').format(this);
  }

  String toDMMMY() {
    return DateFormat('d MMM y').format(this);
  }

  String toDMMMMY() {
    return DateFormat('d MMMM y').format(this);
  }

  String toDD() {
    return DateFormat('EEEE').format(this);
  }

  DateTime midnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool isToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final date = this;
    final dateToCheck = DateTime(date.year, date.month, date.day);

    return today == dateToCheck;
  }
}
