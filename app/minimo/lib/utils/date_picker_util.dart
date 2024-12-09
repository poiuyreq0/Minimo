import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerUtil {
  static Future<void> showCustomDatePicker({
    required BuildContext context,
    required DateTime? initialDate,
    required Function(DateTime?) onDateChange,
  }) async {
    final DateTime? date = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale('ko', 'KR'),
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    onDateChange(date);
  }
}