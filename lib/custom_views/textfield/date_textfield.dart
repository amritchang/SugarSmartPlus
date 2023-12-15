import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugar_smart_assist/custom_views/textfield/app_textfield.dart';
import 'package:sugar_smart_assist/helper/string_extension.dart';

class DatePickerTextField extends StatefulWidget {
  final String placeholder;
  final String? initialDate;
  final String? firstDate;
  final String? lastDate;
  final TextChanged onTextChanged;
  final TextEditingController? controller;

  DatePickerTextField({
    Key? key,
    required this.placeholder,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onTextChanged,
    this.controller,
  }) : super(key: key);

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ??
        DateFormat(DateFormatType.yearMonthDayDashed.pattern)
            .format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    var iniDate = (widget.initialDate == null || widget.initialDate == '')
        ? DateTime.now()
        : DateFormat(DateFormatType.yearMonthDayDashed.pattern)
            .parse(widget.initialDate!);
    var firstDate = (widget.firstDate == null || widget.firstDate == '')
        ? DateTime(1990)
        : DateFormat(DateFormatType.yearMonthDayDashed.pattern)
            .parse(widget.firstDate!);
    var lastdate = (widget.lastDate == null || widget.lastDate == '')
        ? DateTime.now()
        : DateFormat(DateFormatType.yearMonthDayDashed.pattern)
            .parse(widget.lastDate!);

    if (iniDate.isAfter(lastdate)) {
      iniDate = lastdate;
    }
    if (iniDate.isBefore(firstDate)) {
      iniDate = firstDate;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: iniDate,
      firstDate: firstDate,
      lastDate: lastdate,
    );
    if (picked != null) {
      var formatedPiicked =
          DateFormat(DateFormatType.yearMonthDayDashed.pattern).format(picked);
      if (formatedPiicked != selectedDate) {
        setState(() {
          selectedDate = formatedPiicked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      placeholder: widget.placeholder,
      type: TextFieldType.datePicker,
      preText: selectedDate,
      isSecure: false,
      onTextChanged: widget.onTextChanged,
      onTap: () {
        _selectDate(context);
      },
      controller: widget.controller,
    );
  }
}
