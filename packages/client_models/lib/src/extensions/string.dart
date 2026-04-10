import 'dart:convert';

import 'package:client_models/src/extensions/date_time.dart';

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  bool get isNotNullAndNotEmpty => this?.isNotEmpty ?? false;
}

extension StringExtensions on String {
  bool isJson() {
    try {
      final dynamic jsonMap = json.decode(this);
      return jsonMap is Map<String, dynamic>;
    } catch (e) {
      return false;
    }
  }

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String lowerFirstLetter() {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }

  String capitalizeAndSplit() {
    // Insert a space before each capital letter (except the first)
    return replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (Match m) => ' ${m.group(0)}').replaceAll('And', ' & ');
  }

  String toEmailDescriptor() {
    return split('@')[0];
  }

  String toDMMMMY() {
    List<String> parts = split('/');

    // Parse each part into an integer
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    return DateTime(year, month, day).toDMMMMY();
  }

  String toPhoneNumber() {
    // Remove all non-digit characters
    String digits = replaceAll(RegExp(r'\D'), '');

    // If the number is 9 digits long, prepend a '0'
    if (digits.length == 9) {
      digits = '0$digits';
    }
    // Replace +27 or 27 with 0
    if (digits.startsWith('27')) {
      digits = '0${digits.substring(2)}';
    }
    // Check if the number has the correct length
    if (digits.length != 10) {
      // throw FormatException('Invalid phone number length');
      return this;
    }

    // Format the number as (XXX) XXX-XXXX
    return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
  }
}
